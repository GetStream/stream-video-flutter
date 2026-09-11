import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

/// The event a call ended from another device arrives as.
CoordinatorCallEndedEvent _endedEvent() {
  return CoordinatorCallEndedEvent(
    callCid: SampleCallData.defaultCid,
    endedBy: SampleCallData.defaultCallUser,
    createdAt: DateTime.now(),
    metadata: SampleCallData.defaultCallMetadata,
    type: 'call.ended',
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  // A call ended elsewhere reaches this SDK as a coordinator event, and the
  // status it writes is torn down by `_clear` rather than by `leave`. That path
  // is the only thing that can release a join or reconnect already in flight —
  // and it used not to, so the in-flight work wrote `Connecting` back over the
  // disconnected status while `_clear` had already cancelled every
  // subscription that could have moved it on again. The call was left showing
  // "Connecting…" for good.
  group('a call ended remotely while a reconnect is in flight', () {
    late BehaviorSubject<InternetStatus> internetStatus;
    late MutableSharedEmitter<CoordinatorEvent> coordinatorEvents;
    late MockCoordinatorClient coordinatorClient;
    late MockCallSession callSession;
    late MockSessionFactory sessionFactory;

    setUp(() {
      internetStatus = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      coordinatorEvents = MutableSharedEmitter<CoordinatorEvent>();
      coordinatorClient = setupMockCoordinatorClient(
        events: coordinatorEvents,
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
        coordinatorClient: coordinatorClient,
        sessionFactory: sessionFactory,
      );
    }

    test('settles disconnected instead of reverting to connecting', () async {
      final call = buildCall();
      await call.join();

      // Hold the reconnect open so the ended event lands mid-flight, which is
      // the interleaving that produced the stuck screen.
      final reconnectGate = Completer<void>();
      when(
        () => callSession.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      ).thenAnswer((_) async {
        await reconnectGate.future;
        return Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        ));
      });

      (callSession.events as MutableSharedEmitter<SfuEvent>).emit(
        const SfuSocketDisconnected(
          sessionId: 'test-session-id',
          url: 'wss://sfu.invalid',
          reason: DisconnectionReason(
            isReconnectable: true,
            closeCode: 1006,
            closeReason: 'abnormal',
          ),
        ),
      );
      await pumpEventQueue();

      coordinatorEvents.emit(_endedEvent());
      await pumpEventQueue();

      // Release the reconnect that was still in flight. Nothing it does may
      // move the call off the terminal status.
      if (!reconnectGate.isCompleted) reconnectGate.complete();
      await pumpEventQueue();

      expect(
        call.state.value.status,
        isA<CallStatusDisconnected>(),
        reason: 'the call ended; nothing in flight may revive it',
      );
    });

    // The completer is what the in-flight work races against, so the fix is
    // observable through it: `leave` afterwards must not find anything to do.
    test('a later leave finds the call already settled', () async {
      final call = buildCall();
      await call.join();

      coordinatorEvents.emit(_endedEvent());
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusDisconnected>());

      final result = await call.leave();
      expect(result.isSuccess, isTrue);
      expect(
        call.state.value.status,
        isA<CallStatusDisconnected>(),
        reason: 'leave is idempotent once the call has ended',
      );
    });
  });
}
