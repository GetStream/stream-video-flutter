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

    test('a call ended by the server reports a backend leave', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave(reason: DisconnectReason.ended());

      expect(harness.reporter.aborts, [ClientEventStandardCode.backendLeave]);
    });
  });

  group('known hazard', () {
    // Changes with FLU-864: a failed join decides to leave in one place,
    // reports one abort and returns the error it failed with.
    test(
      'an unrecoverable coordinator refusal reports two aborts and returns '
      'connect cancelled',
      () async {
        harness.stubJoinCall(() async => unrecoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864: a retryable coordinator failure is retried.
    test(
      'a retryable coordinator failure leaves on the first attempt, so the '
      'join is never retried',
      () async {
        harness.stubJoinCall(() async => recoverableJoinFailure());
        final call = harness.buildCall();

        final result = await call.join();

        harness.verifyJoinCallCount(1);
        expect(result.getErrorOrNull()?.message, 'connect cancelled');
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864.
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
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );

    // Changes with FLU-864.
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
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );
  });

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
}
