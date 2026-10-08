import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins how `Call.join` behaves today, including where it races `leave`, so
/// moving the connection code out of `Call` cannot change it unnoticed.
/// Idle, then connecting, then disconnected by the user's own leave.
final cancelledFromConnecting = [
  isA<CallStatusIdle>(),
  isA<CallStatusConnecting>(),
  isA<CallStatusDisconnected>().having(
    (s) => s.reason,
    'reason',
    isA<DisconnectReasonCancelled>(),
  ),
];

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  group('join while a reconnect is running', () {
    test('fails with the status the reconnect ended on', () async {
      final call = harness.buildCall();
      await call.join();

      final reconnectGate = Completer<void>();
      harness.stubFastReconnect(harness.session, () async {
        await reconnectGate.future;
        throw const StreamApiException(
          message: 'forbidden',
          statusCode: 403,
          unrecoverable: true,
        );
      });
      await harness.emitSfu(harness.session, sfuSocketDropped);
      expect(call.state.value.status, isA<CallStatusReconnecting>());

      final join = call.join();
      await pumpEventQueue();
      reconnectGate.complete();

      final result = await join;
      expect(
        result.getErrorOrNull()?.message,
        startsWith('ongoing connect failed: '),
      );
      harness.verifyJoinCallCount(1);
    });

    test('times out after connectTimeout', () async {
      final call = harness.buildCall(
        preferences: DefaultCallPreferences(
          connectTimeout: const Duration(milliseconds: 50),
        ),
      );
      await call.join();

      final reconnectGate = Completer<void>();
      addTearDown(reconnectGate.complete);
      harness.stubFastReconnect(harness.session, () async {
        await reconnectGate.future;
        return sessionStartSuccess();
      });
      await harness.emitSfu(harness.session, sfuSocketDropped);

      final result = await call.join();

      expect(
        result.getErrorOrNull()?.message,
        'timed out waiting for ongoing connect',
      );
      expect(call.state.value.status, isA<CallStatusReconnecting>());
    });

    test('waits for a reconnect, which counts as connecting', () async {
      final call = harness.buildCall();
      await call.join();

      final reconnectGate = Completer<void>();
      harness.stubFastReconnect(harness.session, () async {
        await reconnectGate.future;
        return sessionStartSuccess();
      });
      await harness.emitSfu(harness.session, sfuSocketDropped);
      expect(call.state.value.status, isA<CallStatusReconnecting>());

      var joinSettled = false;
      final join = call.join().whenComplete(() => joinSettled = true);
      await pumpEventQueue();
      expect(joinSettled, isFalse);

      reconnectGate.complete();

      expect((await join).isSuccess, isTrue);
      expect(call.state.value.status, isA<CallStatusConnected>());
      harness.verifyJoinCallCount(1);
    });
  });

  group('join called more than once', () {
    test('a join running into a failure fails both callers alike', () async {
      harness.stubJoinCall(() async => unrecoverableJoinFailure());
      final call = harness.buildCall();

      final first = call.join();
      final second = call.join();

      final results = await Future.wait([first, second]);
      expect(
        results.map((r) => r.getErrorOrNull()?.message),
        ['forbidden', 'forbidden'],
      );
      harness.verifyJoinCallCount(1);
    });

    test('a join after a failed join is refused as left', () async {
      harness.stubJoinCall(() async => unrecoverableJoinFailure());
      final call = harness.buildCall();
      await call.join();
      clearInteractions(harness.coordinatorClient);

      final result = await call.join();

      expect(result.getErrorOrNull()?.message, 'call was left');
      harness.verifyJoinCallCount(0);
    });

    test('a join after a successful join succeeds without joining', () async {
      final call = harness.buildCall();
      await call.join();

      final result = await call.join();

      expect(result.isSuccess, isTrue);
      harness.verifyJoinCallCount(1);
    });

    test('a join after leave is refused as left', () async {
      final call = harness.buildCall();
      await call.join();
      await call.leave();

      final result = await call.join();

      expect(result.getErrorOrNull()?.message, 'call was left');
      harness.verifyJoinCallCount(1);
    });
  });

  group('leave while a join is in flight', () {
    test('during the coordinator join', () async {
      final gate = Completer<void>();
      harness.stubJoinCall(() async {
        await gate.future;
        return Result.success(SampleCallData.coordinatorJoinedSuccess);
      });
      final call = harness.buildCall();
      final statuses = recordStatuses(call);

      final join = call.join();
      await pumpEventQueue();
      await call.leave();

      final result = await join;
      expect(result.getErrorOrNull()?.message, 'connect cancelled');

      gate.complete();
      await pumpEventQueue();

      harness.verifyMakeCallSessionCount(0);
      expect(statuses, cancelledFromConnecting);
    });

    test('while the SFU session is being created', () async {
      final gate = Completer<void>();
      harness.stubMakeCallSession(() => gate.future);
      final call = harness.buildCall();
      final statuses = recordStatuses(call);

      final join = call.join();
      await pumpEventQueue();
      await call.leave();

      final result = await join;
      expect(result.getErrorOrNull()?.message, 'connect cancelled');

      gate.complete();
      await pumpEventQueue();

      verifyNever(
        () => harness.session.start(
          reconnectDetails: any(named: 'reconnectDetails'),
          onRtcManagerCreatedCallback: any(
            named: 'onRtcManagerCreatedCallback',
          ),
          isAnonymousUser: any(named: 'isAnonymousUser'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
          clientEventRetryCount: any(named: 'clientEventRetryCount'),
        ),
      );
      expect(statuses, cancelledFromConnecting);
    });

    test('while the SFU session is starting', () async {
      final gate = Completer<void>();
      harness.stubSessionStart(harness.session, () async {
        await gate.future;
        return sessionStartSuccess();
      });
      final call = harness.buildCall();
      final statuses = recordStatuses(call);

      final join = call.join();
      await pumpEventQueue();
      await call.leave();

      final result = await join;
      expect(result.getErrorOrNull()?.message, 'connect cancelled');

      gate.complete();
      await pumpEventQueue();

      expect(statuses, cancelledFromConnecting);
    });
  });

  group('a failed coordinator join', () {
    test(
      'restores the state from before the request, dropping events that '
      'arrived meanwhile',
      () async {
        final gate = Completer<void>();
        harness.stubJoinCall(() async {
          await gate.future;
          return unrecoverableJoinFailure();
        });
        final call = harness.buildCall();
        final recording = <bool>[];
        call.state.map((s) => s.isRecording).distinct().listen(recording.add);

        final join = call.join();
        await pumpEventQueue();
        harness.coordinatorEvents.emit(
          CoordinatorCallRecordingStartedEvent(
            callCid: SampleCallData.defaultCid,
            createdAt: DateTime.now(),
            recordingType: RecordingType.composite,
          ),
        );
        await pumpEventQueue();
        expect(call.state.value.isRecording, isTrue);

        gate.complete();
        await join;

        expect(recording, [false, true, false]);
        expect(call.state.value.isRecording, isFalse);
      },
    );
  });
}
