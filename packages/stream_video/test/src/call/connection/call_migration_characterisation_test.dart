import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/ws/ws.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins an SFU migration from the go-away event to the connected status, so
/// moving the connection code out of `Call` cannot change it unnoticed.
///
/// Each migration and rejoin waits out the reconnect's three second network
/// stability window, so these tests run for several seconds.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  final sfuName = SampleCallData.defaultCredentials.sfuServer.name;

  late ConnectionHarness harness;

  tearDown(() => harness.dispose());

  test(
    'a go-away migrates to a new SFU session and closes the old one',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final [first, second] = harness.sessions;
      final migrationGate = Completer<Result<None>>();
      when(
        second.waitForMigrationComplete,
      ).thenAnswer((_) => migrationGate.future);
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
      // The wait for the new SFU's confirmation is asked for when the session
      // is made, before the old socket closes; the status stays migrating
      // until it arrives.
      await waitUntil(() => firstClosed);
      expect(call.state.value.status, isA<CallStatusMigrating>());
      verifyInOrder([
        second.waitForMigrationComplete,
        () => first.close(StreamVideoCloseCode.disposeOldSocket),
      ]);

      migrationGate.complete(const Result.success(none));
      await waitUntil(() => call.state.value.status is CallStatusConnected);

      verify(
        () => harness.coordinatorClient.joinCall(
          callCid: any(named: 'callCid'),
          create: any(named: 'create'),
          migratingFrom: sfuName,
          migratingFromList: [sfuName],
          video: any(named: 'video'),
          membersLimit: any(named: 'membersLimit'),
          e2ee: any(named: 'e2ee'),
        ),
      ).called(1);
      verify(
        () => first.getReconnectDetails(
          SfuReconnectionStrategy.migrate,
          migratingFromSfuId: any(named: 'migratingFromSfuId'),
          reconnectAttempts: 1,
          reason: 'go away',
        ),
      ).called(1);
      verifyNever(() => first.leave(reason: any(named: 'reason')));
      expect(harness.captureMakeCallSessionIds(), [
        (sessionId: null, sessionSeq: 0),
        (sessionId: 'session-0', sessionSeq: 1),
      ]);
      expect(statuses, [
        isA<CallStatusConnected>(),
        isA<CallStatusMigrating>(),
        isA<CallStatusConnected>(),
      ]);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  group('known hazard', () {
    // Changes with FLU-861: a migration disposes the session it moved off.
    test(
      'a migration closes the old session but never disposes it',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final [first, _] = harness.sessions;
        final call = harness.buildCall();
        await call.join();

        await harness.emitSfu(
          first,
          const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
        );
        await waitUntil(() => call.state.value.status is CallStatusConnected);

        verify(
          () => first.close(StreamVideoCloseCode.disposeOldSocket),
        ).called(1);
        verifyNever(first.dispose);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  test(
    'a migration that does not complete escalates to a rejoin',
    () async {
      harness = ConnectionHarness(sessionCount: 3);
      final [first, second, third] = harness.sessions;
      when(second.waitForMigrationComplete).thenAnswer(
        (_) async => const Result.failure(
          StreamVideoException(message: 'migration timed out'),
        ),
      );
      final call = harness.buildCall();
      await call.join();
      final statuses = recordStatuses(call);

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      await waitUntil(
        () => call.state.value.status is CallStatusConnected,
        timeout: const Duration(seconds: 20),
      );

      expect(
        statuses,
        containsAllInOrder([
          isA<CallStatusMigrating>(),
          isA<CallStatusReconnecting>().having(
            (s) => s.isFastReconnectAttempt,
            'isFastReconnectAttempt',
            isFalse,
          ),
          isA<CallStatusConnected>(),
        ]),
      );
      verify(
        () => first.close(StreamVideoCloseCode.disposeOldSocket),
      ).called(1);
      verify(
        () => second.getReconnectDetails(
          SfuReconnectionStrategy.rejoin,
          migratingFromSfuId: any(named: 'migratingFromSfuId'),
          reconnectAttempts: any(named: 'reconnectAttempts'),
          reason: any(named: 'reason'),
        ),
      ).called(1);
      verify(() => second.leave(reason: any(named: 'reason'))).called(1);
      verify(second.dispose).called(1);
      verifyNever(third.waitForMigrationComplete);
      // A migration keeps the session id, a rejoin starts a new one.
      expect(harness.captureMakeCallSessionIds(), [
        (sessionId: null, sessionSeq: 0),
        (sessionId: 'session-0', sessionSeq: 1),
        (sessionId: null, sessionSeq: 2),
      ]);
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );
}
