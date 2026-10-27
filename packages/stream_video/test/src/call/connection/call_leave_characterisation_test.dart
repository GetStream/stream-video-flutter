import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins what `Call.leave` and `Call.end` report and tear down today, so moving
/// the connection code out of `Call` cannot change it unnoticed.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() {
    harness = ConnectionHarness();
    when(
      () => harness.permissionsManager.endCall(),
    ).thenAnswer((_) async => const Result.success(none));
  });
  tearDown(() => harness.dispose());

  group('telemetry abort reported by leave', () {
    test('a plain leave reports one client abort', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave();

      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    });

    test('a second leave reports another abort', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave();
      await call.leave();

      expect(harness.reporter.aborts, [
        ClientEventStandardCode.clientAborted,
        ClientEventStandardCode.clientAborted,
      ]);
    });

    test('a leave with an ended reason reports a backend leave', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave(reason: DisconnectReason.ended());

      expect(harness.reporter.aborts, [ClientEventStandardCode.backendLeave]);
    });
  });

  group('SFU leave reason', () {
    test('a plain leave tells the SFU the user is leaving', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave();

      verify(
        () => harness.session.leave(reason: 'user is leaving the call'),
      ).called(1);
    });

    final currentUserId = SampleCallData.defaultUserInfo.id;
    final pinned =
        <
          ({
            String name,
            DisconnectReason reason,
            String message,
            ClientEventStandardCode abortCode,
            LeaveInitiator initiator,
            String code,
          })
        >[
          (
            name: 'ended',
            reason: DisconnectReason.ended(),
            message: 'call ended',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.ended',
          ),
          (
            name: 'native call ended',
            reason: DisconnectReason.nativeCallEnded(),
            message: 'call ended externally',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.callkit,
            code: 'native.call_ended',
          ),
          (
            name: 'a reject by another user',
            reason: DisconnectReason.rejected(
              byUserId: 'someone',
              reason: CallRejectReason.decline(),
            ),
            message: 'rejected: decline',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected:decline',
          ),
          (
            name: 'a reject by another user without a reason',
            reason: const DisconnectReason.rejected(byUserId: 'someone'),
            message: 'rejected: unspecified',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected',
          ),
          (
            name: 'a decline by this user',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.decline(),
            ),
            message: 'rejected: decline',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.user,
            code: 'call.rejected:decline',
          ),
          (
            name: 'a ring timeout',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.timeout(),
            ),
            message: 'rejected: timeout',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.sdkError,
            code: 'call.rejected:timeout',
          ),
          (
            name: 'an answer on another device',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.userRespondedElsewhere(),
            ),
            message: 'rejected: user-responded-elsewhere',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected:user-responded-elsewhere',
          ),
          (
            name: 'a local end brought back in sync',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.callEndedLocally(),
            ),
            message: 'rejected: call-ended-locally',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.app,
            code: 'call.rejected:call-ended-locally',
          ),
          (
            name: 'a reject by this user without a reason',
            reason: DisconnectReason.rejected(byUserId: currentUserId),
            message: 'rejected: unspecified',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.user,
            code: 'call.rejected',
          ),
          (
            name: 'a stale ring the backend ended',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.callEnded(),
            ),
            message: 'rejected: call-ended',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected:call-ended',
          ),
          (
            name: 'a ring the creator cancelled',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.creatorRejected(),
            ),
            message: 'rejected: ring: creator rejected',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected:ring: creator rejected',
          ),
          (
            name: 'a ring everyone else rejected',
            reason: DisconnectReason.rejected(
              byUserId: currentUserId,
              reason: CallRejectReason.allOtherParticipantsRejected(),
            ),
            message: 'rejected: ring: everyone rejected',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.rejected:ring: everyone rejected',
          ),
          (
            name: 'cancelled',
            reason: const DisconnectReason.cancelled(byUserId: 'caller'),
            message: 'cancelled: caller',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'ring.cancelled',
          ),
          (
            name: 'blocked',
            reason: const DisconnectReason.blocked(),
            message: 'blocked',
            abortCode: ClientEventStandardCode.backendLeave,
            initiator: LeaveInitiator.remoteEvent,
            code: 'call.blocked_user',
          ),
          (
            name: 'replaced',
            reason: DisconnectReason.replaced(),
            message: 'replaced by another call',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.app,
            code: 'active_call_replaced',
          ),
          (
            name: 'last participant left',
            reason: DisconnectReason.lastParticipantLeft(),
            message: 'last participant left',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.app,
            code: 'auto-leave',
          ),
          (
            name: 'reconnection failed',
            reason: DisconnectReason.reconnectionFailed(),
            message: 'reconnection failed',
            abortCode: ClientEventStandardCode.networkOffline,
            initiator: LeaveInitiator.sdkError,
            code: 'reconnection_failed',
          ),
          (
            name: 'failure',
            reason: const DisconnectReason.failure(
              StreamVideoException(message: 'boom'),
            ),
            message: 'failure: boom',
            abortCode: ClientEventStandardCode.clientAborted,
            initiator: LeaveInitiator.sdkError,
            code: 'error',
          ),
          (
            name: 'SFU error',
            reason: const DisconnectReason.sfuError(_sfuError),
            message: 'sfu error: unspecified: kicked',
            abortCode: ClientEventStandardCode.sfuError,
            initiator: LeaveInitiator.sdkError,
            code: 'sfu_error:unspecified',
          ),
        ];

    for (final row in pinned) {
      test(
        'a leave for ${row.name} tells the SFU "${row.message}" and reports '
        '${row.initiator.wireValue} / ${row.code}',
        () async {
          final call = harness.buildCall();
          await call.join();

          await call.leave(reason: row.reason);

          verify(() => harness.session.leave(reason: row.message)).called(1);
          final failure = harness.reporter.abortFailures.single;
          expect(failure.code, row.abortCode);
          expect(failure.reason, row.message);
          expect(failure.leaveInitiator, row.initiator);
          expect(failure.leaveReason, row.code);
        },
      );
    }

    test('a leave without a reason reports unknown', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave();

      final failure = harness.reporter.abortFailures.single;
      expect(failure.code, ClientEventStandardCode.clientAborted);
      expect(failure.reason, 'user is leaving the call');
      expect(failure.leaveInitiator, LeaveInitiator.unknown);
      expect(failure.leaveReason, 'left');
    });

    test('a failed SFU join tells the SFU about the failure', () async {
      harness.stubSessionStart(
        harness.session,
        () async => unrecoverableSfuFailure(),
      );
      final call = harness.buildCall();

      await call.join();

      verify(
        () => harness.session.leave(
          reason: any(named: 'reason', that: startsWith('failure: ')),
        ),
      ).called(1);
    });
  });

  group('a failed join leaves once', () {
    test(
      'an unrecoverable coordinator refusal reports one abort and returns '
      'the refusal',
      () async {
        harness.stubJoinCall(() async => unrecoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.getErrorOrNull()?.message, 'forbidden');
        harness.verifyJoinCallCount(1);
        await harness.settleAborts(1);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    test(
      'a retryable coordinator failure is retried, then reports one abort and '
      'returns the last failure',
      () async {
        harness.stubJoinCall(() async => recoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.getErrorOrNull()?.message, 'unavailable');
        harness.verifyJoinCallCount(3);
        await harness.settleAborts(1);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    test(
      'an unrecoverable SFU join error reports one abort and returns the SFU '
      'error',
      () async {
        harness.stubSessionStart(
          harness.session,
          () async => unrecoverableSfuFailure(),
        );
        final call = harness.buildCall();

        final result = await call.join();

        harness.verifyJoinCallCount(1);
        expect(result.getErrorOrNull()?.message, 'SFU disconnect');
        await harness.settleAborts(1);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    test(
      'an SFU join that runs out of retries reports one abort and returns the '
      'last SFU error',
      () async {
        harness.stubSessionStart(
          harness.session,
          () async => const Result.failure(
            StreamVideoException(message: 'sfu unreachable'),
          ),
        );
        final call = harness.buildCall();

        final result = await call.join();

        // Three SFU attempts. The second reuses the first one's credentials;
        // the third asks the coordinator for another SFU after two failures
        // on the same one.
        harness
          ..verifyMakeCallSessionCount(3)
          ..verifyJoinCallCount(2);
        expect(result.getErrorOrNull()?.message, 'sfu unreachable');
        await harness.settleAborts(1);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );
  });

  test(
    'a leave while another is tearing down short-circuits, and so does every '
    'leave after it',
    () async {
      final call = harness.buildCall();
      await call.join();
      final disposeGate = Completer<void>();
      when(harness.session.dispose).thenAnswer((_) => disposeGate.future);

      final first = call.leave();
      await pumpEventQueue();
      await call.leave();
      final third = call.leave();
      await pumpEventQueue();

      disposeGate.complete();
      await Future.wait([first, third]);

      verify(
        () => harness.session.leave(reason: any(named: 'reason')),
      ).called(1);
      verify(harness.session.dispose).called(1);
      expect(call.state.value.status, isA<CallStatusDisconnected>());
    },
  );

  group('end', () {
    test('ends the call on the server and settles disconnected', () async {
      final call = harness.buildCall();
      await call.join();

      final result = await call.end();

      expect(result.isSuccess, isTrue);
      verify(() => harness.permissionsManager.endCall()).called(1);
      final status = call.state.value.status;
      expect(status, isA<CallStatusDisconnected>());
      expect(
        (status as CallStatusDisconnected).reason,
        isA<DisconnectReasonEnded>(),
      );
      verify(
        () => harness.session.leave(reason: 'user is ending the call'),
      ).called(1);
    });

    test(
      'when the server refuses to end, returns the failure but stays '
      'disconnected as ended',
      () async {
        when(() => harness.permissionsManager.endCall()).thenAnswer(
          (_) async => const Result.failure(
            StreamVideoException(message: 'end refused'),
          ),
        );
        final call = harness.buildCall();
        await call.join();

        final result = await call.end();

        expect(result.getErrorOrNull()?.message, 'end refused');
        final status = call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonEnded>());
      },
    );

    test('on a call that is not active, fails with invalid status', () async {
      final call = harness.buildCall();

      final result = await call.end();

      expect(result.getErrorOrNull()?.message, startsWith('invalid status: '));
      verifyNever(() => harness.permissionsManager.endCall());
    });

    test('disposes the SFU session once', () async {
      final call = harness.buildCall();
      await call.join();

      await call.end();
      await pumpEventQueue();

      verify(harness.session.dispose).called(1);
    });

    test('reports no telemetry abort', () async {
      final call = harness.buildCall();
      await call.join();

      await call.end();
      await pumpEventQueue();

      expect(harness.reporter.aborts, isEmpty);
    });

    test(
      'while a leave is disconnecting, does not end on the server',
      () async {
        final call = harness.buildCall();
        await call.join();

        // Holds the leave inside its teardown, so end() lands mid-disconnect.
        final disposeGate = Completer<void>();
        when(harness.session.dispose).thenAnswer((_) => disposeGate.future);

        final leave = call.leave();
        await pumpEventQueue();
        final end = await call.end();

        disposeGate.complete();
        await leave;

        expect(end.isSuccess, isTrue);
        verifyNever(() => harness.permissionsManager.endCall());
        expect(call.state.value.status, isA<CallStatusDisconnected>());
      },
    );
  });

  group('client state', () {
    test('joining makes the call active and leaving removes it', () async {
      final call = harness.buildCall();
      final clientState = harness.streamVideo.state;

      await call.join();
      verify(() => clientState.setActiveCall(call)).called(1);

      await call.leave();
      verify(() => clientState.removeActiveCall(call)).called(greaterThan(0));
    });

    test('leaving the incoming call clears it', () async {
      final call = harness.buildCall();
      final clientState = harness.streamVideo.state;
      final incomingCall =
          clientState.incomingCall as MutableStateEmitter<Call?>;
      when(() => clientState.setIncomingCall(any())).thenAnswer((invocation) {
        incomingCall.value = invocation.positionalArguments.first as Call?;
        return Future.value();
      });
      incomingCall.value = call;
      await call.join();

      await call.leave();

      expect(incomingCall.value, isNull);
    });
  });
}

const _sfuError = SfuError(
  message: 'kicked',
  code: SfuErrorCode.unspecified,
  shouldRetry: false,
  reconnectStrategy: SfuReconnectionStrategy.disconnect,
);
