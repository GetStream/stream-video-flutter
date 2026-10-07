import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins what is left behind by an SFU session that fails to start, and by a
/// leave.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness(sessionCount: 2));
  tearDown(() => harness.dispose());

  _FakeSubscriber flushableStats(MockCallSession session) {
    final subscriber = _FakeSubscriber();
    final rtcManager = _MockRtcManager();
    when(() => rtcManager.subscriber).thenReturn(subscriber);
    when(() => rtcManager.publisher).thenReturn(null);
    when(() => session.rtcManager).thenReturn(rtcManager);
    return subscriber;
  }

  test(
    'a session that fails to start gets no SFU stats reporter, and is '
    'disposed once the next attempt succeeds',
    () async {
      final [first, second] = harness.sessions;
      final subscriber = flushableStats(first);
      final nextSubscriber = flushableStats(second);
      harness.stubSessionStart(
        first,
        () async => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );
      final call = harness.buildCall();

      final result = await call.join();

      expect(result.isSuccess, isTrue);
      harness.verifyMakeCallSessionCount(2);
      await pumpEventQueue();
      // No reporter ever sampled the failed session; the next one's does.
      expect(subscriber.statsCount, 0);
      expect(nextSubscriber.statsCount, greaterThan(0));
      verify(first.dispose).called(1);
    },
  );

  test(
    'a caption that arrives while the leave flushes the SFU stats is dropped',
    () async {
      final subscriber = flushableStats(harness.session);
      final call = harness.buildCall();
      await call.join();

      // Holds the leave inside the stats flush.
      final flushGate = Completer<void>();
      subscriber.statsGate = flushGate.future;
      final left = call.leave();
      await subscriber.statsRequested.future;
      harness.coordinatorEvents.emit(
        CoordinatorCallClosedCaptionEvent(
          callCid: call.callCid,
          createdAt: DateTime.now(),
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(seconds: 3)),
          speakerId: 'speaker1',
          text: 'Hello',
          user: SampleCallData.testCallUser1,
          language: 'en',
          translated: false,
        ),
      );
      await pumpEventQueue();
      flushGate.complete();
      await left;

      expect(await call.closedCaptions.first, isEmpty);
    },
  );

  test(
    'a join whose every attempt fails to start disposes each session once',
    () async {
      harness = ConnectionHarness(sessionCount: 3);
      for (final session in harness.sessions) {
        harness.stubSessionStart(
          session,
          () async => const Result.failure(
            StreamVideoException(message: 'sfu unreachable'),
          ),
        );
      }
      final call = harness.buildCall();

      final result = await call.join();

      expect(result.isFailure, isTrue);
      harness.verifyMakeCallSessionCount(3);
      for (final session in harness.sessions) {
        verify(session.dispose).called(1);
      }
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test('feedback can still be sent after a leave', () async {
    when(
      () => harness.coordinatorClient.collectUserFeedback(
        callType: any(named: 'callType'),
        callId: any(named: 'callId'),
        sessionId: any(named: 'sessionId'),
        rating: any(named: 'rating'),
        sdk: any(named: 'sdk'),
        sdkVersion: any(named: 'sdkVersion'),
        userSessionId: any(named: 'userSessionId'),
        reason: any(named: 'reason'),
        custom: any(named: 'custom'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    final call = harness.buildCall();
    await call.join();
    await call.leave();

    final result = await call.collectUserFeedback(rating: 4);

    expect(result.isSuccess, isTrue);
    verify(
      () => harness.coordinatorClient.collectUserFeedback(
        callType: any(named: 'callType'),
        callId: any(named: 'callId'),
        sessionId: 'session-0',
        rating: 4,
        sdk: any(named: 'sdk'),
        sdkVersion: any(named: 'sdkVersion'),
        userSessionId: 'session-0',
        reason: any(named: 'reason'),
        custom: any(named: 'custom'),
      ),
    ).called(1);
  });
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

/// A subscriber whose stats are empty but present, so a flush sends them.
class _FakeSubscriber extends Fake implements TracedStreamPeerConnection {
  /// Once set, stats are held until it completes.
  Future<void>? statsGate;
  final statsRequested = Completer<void>();
  int statsCount = 0;

  @override
  Future<void> dispose() async {}

  @override
  final Tracer tracer = Tracer('subscriber');

  @override
  Future<
    ({
      List<RtcStats> rtcStats,
      RtcPrintableStats printable,
      List<Map<String, dynamic>> rawStats,
    })
  >
  getStats() async {
    statsCount++;
    if (statsGate case final gate?) {
      if (!statsRequested.isCompleted) statsRequested.complete();
      await gate;
    }
    return (
      rtcStats: <RtcStats>[],
      printable: const RtcPrintableStats(local: '', remote: ''),
      rawStats: <Map<String, dynamic>>[],
    );
  }
}
