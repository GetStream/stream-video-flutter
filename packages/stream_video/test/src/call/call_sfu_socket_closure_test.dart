import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    show PerformanceStats;
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

/// Emits [event] the way `CallSession` would.
void _emit(MockCallSession session, SfuEvent event) {
  (session.events as MutableSharedEmitter<SfuEvent>).emit(event);
}

SfuSocketDisconnected _disconnected({required bool isReconnectable}) {
  return SfuSocketDisconnected(
    sessionId: 'test-session-id',
    url: 'wss://sfu.invalid',
    reason: DisconnectionReason(
      isReconnectable: isReconnectable,
      closeCode: isReconnectable ? 1006 : 1000,
      closeReason: isReconnectable ? 'abnormal' : 'closed',
    ),
  );
}

SfuSocketFailed _failed({required bool isReconnectable}) {
  return SfuSocketFailed(
    sessionId: 'test-session-id',
    url: 'wss://sfu.invalid',
    isReconnectable: isReconnectable,
    error: const StreamVideoException(message: 'permission denied'),
  );
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() {
    return Future.value();
  }
}

class _MockSubscriber extends Mock implements TracedStreamPeerConnection {
  @override
  final Tracer tracer = Tracer('subscriber');

  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  Future<void> traceStats(List<Map<String, dynamic>> newRtcStats) async {}

  @override
  List<PerformanceStats> getPerformanceStats(
    List<RtcStats> rtcStats,
    SfuTrackType? Function(String) trackIdToTrackType,
  ) => const [];
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  // A closure the disconnection source calls non-reconnectable settles the
  // call: retrying cannot help, but neither can leaving it live on a socket
  // that is not coming back. Both branches used to leave the call stranded —
  // one did nothing at all, the other reported a reconnection that never ran.
  group('an SFU closure the call cannot recover from', () {
    late BehaviorSubject<InternetStatus> internetStatus;
    late MockCoordinatorClient coordinatorClient;
    late MockCallSession callSession;
    late MockSessionFactory sessionFactory;

    setUp(() {
      internetStatus = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      coordinatorClient = setupMockCoordinatorClient();
      callSession = setupMockCallSession();
      sessionFactory = setupMockSessionFactory(callSession: callSession);
    });

    tearDown(() => internetStatus.close());

    Call buildCall() {
      return createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatus,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: sessionFactory,
      );
    }

    test('a non-reconnectable disconnect ends the call', () async {
      final call = buildCall();
      await call.join();

      _emit(callSession, _disconnected(isReconnectable: false));
      await pumpEventQueue();

      expect(
        call.state.value.status,
        isA<CallStatusDisconnected>(),
        reason: 'it must not sit on a socket that will not come back',
      );
      verifyNever(
        () => callSession.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      );
    });

    test(
      'a non-reconnectable failure reports the error it failed on',
      () async {
        final call = buildCall();
        await call.join();

        _emit(callSession, _failed(isReconnectable: false));
        await pumpEventQueue();

        final status = call.state.value.status;
        expect(status, isA<CallStatusDisconnected>());

        // Not DisconnectReasonReconnectionFailed, which reads as "reconnection
        // gave up" for an attempt that never happened.
        final reason = (status as CallStatusDisconnected).reason;
        expect(reason, isA<DisconnectReasonFailure>());
        expect(
          (reason as DisconnectReasonFailure).error.message,
          'permission denied',
        );
      },
    );
  });

  // The other half: the gate must not swallow closures that are worth
  // retrying, which is what it is there for.
  group('an SFU closure the call can recover from', () {
    late BehaviorSubject<InternetStatus> internetStatus;
    late MockCallSession callSession;
    late MockSessionFactory sessionFactory;

    setUp(() {
      internetStatus = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      callSession = setupMockCallSession();
      sessionFactory = setupMockSessionFactory(callSession: callSession);
    });

    tearDown(() => internetStatus.close());

    Call buildCall() {
      return createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatus,
        ),
        coordinatorClient: setupMockCoordinatorClient(),
        sessionFactory: sessionFactory,
      );
    }

    test('a reconnectable disconnect still reconnects', () async {
      final call = buildCall();
      await call.join();

      _emit(callSession, _disconnected(isReconnectable: true));
      await pumpEventQueue();

      expect(call.state.value.status, isNot(isA<CallStatusDisconnected>()));
    });

    test('a reconnectable failure still reconnects', () async {
      final call = buildCall();
      await call.join();

      _emit(callSession, _failed(isReconnectable: true));
      await pumpEventQueue();

      expect(call.state.value.status, isNot(isA<CallStatusDisconnected>()));
    });

    test('stats that do not go out do not hold up the reconnect', () async {
      // The stats collect, but sending them never finishes.
      final subscriber = _MockSubscriber();
      when(subscriber.getStats).thenAnswer(
        (_) async => (
          rtcStats: <RtcStats>[],
          printable: const RtcPrintableStats(local: '', remote: ''),
          rawStats: <Map<String, dynamic>>[],
        ),
      );
      final rtcManager = _MockRtcManager();
      when(() => rtcManager.subscriber).thenReturn(subscriber);
      when(() => callSession.rtcManager).thenReturn(rtcManager);
      final sfuClient = callSession.sfuClient;
      when(
        () => sfuClient.sendStats(any()),
      ).thenAnswer((_) => Completer<Never>().future);

      // The stats read the battery saver mode on the way.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dev.fluttercommunity.plus/battery'),
            (call) async => false,
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('dev.fluttercommunity.plus/battery'),
              null,
            ),
      );

      // Short, so the test does not sit out the real 2s.
      CallConnectionCoordinator.statsBeforeReconnectTimeout = const Duration(
        milliseconds: 50,
      );
      addTearDown(
        () => CallConnectionCoordinator.statsBeforeReconnectTimeout =
            const Duration(seconds: 2),
      );

      final call = buildCall();
      await call.join();

      _emit(callSession, _disconnected(isReconnectable: true));

      // Without a bound on the wait for the stats, it never starts.
      await untilCalled(
        () => callSession.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      ).timeout(const Duration(seconds: 10));
    });
  });
}
