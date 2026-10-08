import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
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
    'a go-away migrates to a new SFU session and disposes the old one once '
    'the old SFU confirms',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final [first, second] = harness.sessions;
      final migrationGate = Completer<Result<None>>();
      when(
        first.waitForMigrationComplete,
      ).thenAnswer((_) => migrationGate.future);
      final call = harness.buildCall();
      await call.join();
      final statuses = recordStatuses(call);

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      // The old SFU sends the confirmation on the old socket, so that socket
      // stays open until it arrives; the status stays migrating meanwhile.
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await pumpEventQueue();
      expect(call.state.value.status, isA<CallStatusMigrating>());
      verify(first.waitForMigrationComplete).called(1);
      verifyNever(first.dispose);

      migrationGate.complete(const Result.success(none));
      await waitUntil(() => call.state.value.status is CallStatusConnected);

      verify(first.dispose).called(1);
      verifyNever(second.waitForMigrationComplete);
      verifyNever(second.dispose);
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

  test(
    'a migration whose first attempt fails still waits on the session it '
    'started from, then disposes it and the failed attempt',
    () async {
      harness = ConnectionHarness(sessionCount: 3);
      final [first, second, third] = harness.sessions;
      harness.stubSessionStart(
        second,
        () async => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );
      final call = harness.buildCall();
      await call.join();

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      await waitUntil(
        () => harness.reconnectionCallbacks.length == 3,
        timeout: const Duration(seconds: 15),
      );
      await waitUntil(() => call.state.value.status is CallStatusConnected);

      // Each attempt waits on the session the call migrated from, never on
      // the failed attempt's session, which the old SFU knows nothing about.
      verify(first.waitForMigrationComplete).called(2);
      verifyNever(second.waitForMigrationComplete);
      verifyNever(third.waitForMigrationComplete);
      verify(first.dispose).called(1);
      verify(second.dispose).called(1);
      verifyNever(third.dispose);
      verify(
        () => first.getReconnectDetails(
          SfuReconnectionStrategy.migrate,
          migratingFromSfuId: any(named: 'migratingFromSfuId'),
          reconnectAttempts: any(named: 'reconnectAttempts'),
          reason: any(named: 'reason'),
        ),
      ).called(2);
      verifyNever(
        () => second.getReconnectDetails(
          any(),
          migratingFromSfuId: any(named: 'migratingFromSfuId'),
          reconnectAttempts: any(named: 'reconnectAttempts'),
          reason: any(named: 'reason'),
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );

  test(
    'a migration that does not complete escalates to a rejoin',
    () async {
      harness = ConnectionHarness(sessionCount: 3);
      final [first, second, third] = harness.sessions;
      when(first.waitForMigrationComplete).thenAnswer(
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
      verify(first.dispose).called(1);
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
