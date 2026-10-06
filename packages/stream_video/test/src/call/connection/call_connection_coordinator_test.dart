import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins what the connection coordinator owns: leaving is terminal, waits end
/// on leave, a failed join leaves once, a remote end leaves like a local
/// leave, a join refused before it starts leaves the call idle, and each
/// reconnect counts its attempts afresh.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  test(
    'a leave whose teardown throws still settles disconnected, and a later '
    'leave does not tear down again',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.leave(), throwsStateError);

      expect(call.state.value.status, isA<CallStatusDisconnected>());

      await call.leave();

      verify(
        () => harness.session.leave(reason: any(named: 'reason')),
      ).called(1);
      final rejoin = await call.join();
      expect(rejoin.getErrorOrNull()?.message, 'call was left');
    },
  );

  test(
    'a teardown that throws early still removes the call from the active '
    'calls',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        harness.streamVideo.isAudioProcessorConfigured,
      ).thenThrow(StateError('teardown failed'));
      clearInteractions(harness.streamVideo.state);

      await expectLater(call.leave(), throwsStateError);

      verify(
        () => harness.streamVideo.state.removeActiveCall(call),
      ).called(greaterThan(0));
    },
  );

  test(
    'an end whose teardown throws still ends the call on the server and '
    'settles disconnected as ended',
    () async {
      when(
        () => harness.permissionsManager.endCall(),
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.end(), throwsStateError);

      verify(() => harness.permissionsManager.endCall()).called(1);
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonEnded>());
    },
  );

  test('a leave during a fast reconnect that then succeeds stays '
      'disconnected', () async {
    final call = harness.buildCall();
    await call.join();
    final reconnectGate = Completer<void>();
    harness.stubFastReconnect(harness.session, () async {
      await reconnectGate.future;
      return sessionStartSuccess();
    });
    await harness.emitSfu(harness.session, sfuSocketDropped);
    expect(call.state.value.status, isA<CallStatusReconnecting>());

    await call.leave();
    reconnectGate.complete();
    await pumpEventQueue();

    expect(call.state.value.status, isA<CallStatusDisconnected>());
  });

  test('a join refused before it starts can be retried', () async {
    final call = harness.buildCall();
    final activeCalls =
        harness.streamVideo.state.activeCalls
            as MutableStateEmitter<List<Call>>;
    activeCalls.value = [harness.buildCall()];

    final refused = await call.join();
    expect(
      refused.getErrorOrNull()?.message,
      'a call with the same cid is in progress',
    );

    activeCalls.value = [];
    final retried = await call.join();

    expect(retried.isSuccess, isTrue);
    expect(call.state.value.status, isA<CallStatusConnected>());
  });

  test('each reconnect counts its attempts from 1', () async {
    final call = harness.buildCall();
    await call.join();
    harness.stubFastReconnect(
      harness.session,
      () async => sessionStartSuccess(),
    );
    final statuses = recordStatuses(call);

    Future<void> dropAndReconnect() async {
      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() => call.state.value.status.isConnected);
    }

    await dropAndReconnect();
    await dropAndReconnect();

    final attempts = statuses
        .whereType<CallStatusReconnecting>()
        .map((status) => status.attempt)
        .toSet();
    expect(attempts, {1});
    // The status recorded on listening, then one per reconnect.
    expect(statuses.whereType<CallStatusConnected>(), hasLength(3));
  });

  test(
    'a leave during the backoff between join attempts ends the join without '
    'another coordinator join',
    () async {
      harness.stubJoinCall(() async => recoverableJoinFailure());
      final call = harness.buildCall(
        retryPolicy: RetryPolicy(
          backoff: (_, _) => const Duration(seconds: 1),
        ),
      );

      final join = call.join();
      await waitUntil(() => call.state.value.status is CallStatusConnecting);
      await pumpEventQueue();
      await call.leave();

      expect((await join).isFailure, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      harness.verifyJoinCallCount(1);
    },
  );

  test('a ring that is not answered in time rejects once and reports one '
      'abort', () async {
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    final call = harness.buildCall(status: CallStatus.outgoing());
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      settings: harness.stateManager.callState.settings.copyWith(
        ring: const StreamRingSettings(
          autoCancelTimeout: Duration(milliseconds: 50),
        ),
      ),
    );

    final result = await call.join();

    expect(result.isFailure, isTrue);
    verify(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: CallRejectReason.timeout().value,
      ),
    ).called(1);
    await harness.settleAborts(1);
    expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    final status = call.state.value.status as CallStatusDisconnected;
    expect(status.reason, isA<DisconnectReasonRejected>());
  });

  void stubRejectCall() {
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  }

  test(
    'a leave while the call is being marked active leaves it neither active '
    'nor registered',
    () async {
      final gate = Completer<void>();
      final clientState = harness.streamVideo.state;
      when(() => clientState.setActiveCall(any())).thenAnswer(
        (_) => gate.future,
      );
      final call = harness.buildCall();

      final join = call.join();
      await pumpEventQueue();
      await call.leave();
      clearInteractions(clientState);
      gate.complete();

      expect((await join).getErrorOrNull()?.message, 'call was left');
      verify(() => clientState.removeActiveCall(call)).called(1);
      expect(harness.reporter.registered, isEmpty);
      harness.verifyJoinCallCount(0);
    },
  );

  test(
    'a leave during the outgoing ring wait cancels the join without '
    'rejecting the call',
    () async {
      stubRejectCall();
      final call = harness.buildCall(status: CallStatus.outgoing());

      final join = call.join();
      await pumpEventQueue();
      await call.leave();

      expect((await join).getErrorOrNull()?.message, 'connect cancelled');
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
  );

  test(
    'a callee rejecting during the ring wait ends the join with the '
    'rejection, without rejecting back',
    () async {
      stubRejectCall();
      final call = harness.buildCall(status: CallStatus.outgoing());

      final join = call.join();
      await pumpEventQueue();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.disconnected(
          const DisconnectReason.rejected(byUserId: 'callee'),
        ),
      );

      final error = (await join).getErrorOrNull();
      expect(error?.message, 'connect cancelled');
      expect(
        (error! as StreamVideoExceptionWithCause).cause,
        isA<DisconnectReasonRejected>(),
      );
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonRejected>());
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, hasLength(1));
    },
  );

  test(
    'a remote end during the coordinator join cancels the join before any '
    'SFU session',
    () async {
      final gate = Completer<void>();
      harness.stubJoinCall(() async {
        await gate.future;
        return Result.success(SampleCallData.coordinatorJoinedSuccess);
      });
      final call = harness.buildCall();

      final join = call.join();
      await pumpEventQueue();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.disconnected(DisconnectReason.ended()),
      );
      gate.complete();

      final error = (await join).getErrorOrNull();
      expect(
        (error! as StreamVideoExceptionWithCause).cause,
        isA<DisconnectReasonEnded>(),
      );
      await pumpEventQueue();
      harness.verifyMakeCallSessionCount(0);
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonEnded>());
    },
  );

  test(
    'a leave during the reconnect backoff stops the reconnect',
    () async {
      final call = harness.buildCall(
        retryPolicy: RetryPolicy(
          backoff: (_, _) => const Duration(seconds: 1),
        ),
      );
      await call.join();
      harness.stubFastReconnect(
        harness.session,
        () async => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );

      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() {
        final status = call.state.value.status;
        return status is CallStatusReconnecting &&
            status.phase == CallReconnectPhase.waiting &&
            status.attempt == 1;
      });
      await pumpEventQueue();
      await call.leave();
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      verify(
        () => harness.session.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      ).called(1);
      harness.verifyMakeCallSessionCount(1);
      expect(call.state.value.status, isA<CallStatusDisconnected>());
    },
  );

  test(
    'a session that throws while being made is retried, then the join leaves '
    'once',
    () async {
      harness.stubMakeCallSession(() async => throw StateError('no session'));
      final call = harness.buildCall();

      final result = await call.join();

      expect(result.isFailure, isTrue);
      harness.verifyMakeCallSessionCount(3);
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
  );

  test(
    'a leave during the migration wait settles disconnected without a '
    'failed reconnect',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final [first, second] = harness.sessions;
      when(
        second.waitForMigrationComplete,
      ).thenAnswer((_) => Completer<Result<None>>().future);
      var firstClosed = false;
      when(
        () => first.close(any(), closeReason: any(named: 'closeReason')),
      ).thenAnswer((_) async => firstClosed = true);
      final call = harness.buildCall();
      await call.join();
      final statuses = recordStatuses(call);

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      await waitUntil(() => firstClosed);
      await call.leave();
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusDisconnected>());
      expect(statuses, isNot(contains(isA<CallStatusReconnectionFailed>())));
      harness.verifyMakeCallSessionCount(2);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
