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

/// Pins what an SFU session that fails to start, and a leave, leave behind.
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
      final first = harness.sessions.first;
      final subscriber = flushableStats(first);
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
      // No reporter ever sampled the failed session.
      expect(subscriber.statsCount, 0);
      verify(first.dispose).called(1);
    },
  );

  test(
    'a caption that arrives while leave flushes the SFU stats is dropped',
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

  test('a leave lets go of the SFU session', () async {
    final call = harness.buildCall();
    await call.join();

    await call.leave();

    expect(call.callSession, isNull);
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
