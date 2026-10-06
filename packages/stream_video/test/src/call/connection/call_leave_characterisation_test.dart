import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

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

  group('known hazard', () {
    // Changes with FLU-864: a failed join decides to leave in one place,
    // reports one abort and returns the error it failed with.
    test(
      'an unrecoverable coordinator refusal returns connect cancelled and '
      'reports three aborts, the last after join returns',
      () async {
        harness.stubJoinCall(() async => unrecoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        // The join loop the first leave cancelled still runs to its own
        // unrecoverable-error leave.
        await harness.settleAborts(3);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864: a retryable coordinator failure is retried, and
    // the join reports one abort.
    test(
      'a retryable coordinator failure is never retried, returns connect '
      'cancelled and reports three aborts, the last after join returns',
      () async {
        harness.stubJoinCall(() async => recoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        // The cancelled join loop runs out its attempts against a call that
        // was left, then leaves once more for running out.
        await harness.settleAborts(3);
        harness.verifyJoinCallCount(1);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864: reports one abort and returns the SFU error.
    test(
      'an unrecoverable SFU join error reports two aborts and returns '
      'connect cancelled',
      () async {
        harness.stubSessionStart(
          harness.session,
          () async => unrecoverableSfuFailure(),
        );
        final call = harness.buildCall();

        final result = await call.join();

        harness.verifyJoinCallCount(1);
        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        await harness.settleAborts(2);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864: reports one abort and returns the last SFU error.
    test(
      'an SFU join that runs out of retries reports two aborts and returns '
      'connect cancelled',
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
        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        await harness.settleAborts(2);
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
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
