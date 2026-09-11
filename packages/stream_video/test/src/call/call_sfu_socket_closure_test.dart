import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
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
  });
}
