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
      final call = harness.buildCall();
      await call.join();
      final statuses = recordStatuses(call);

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      expect(call.state.value.status, isA<CallStatusMigrating>());
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
      verify(second.waitForMigrationComplete).called(1);
      verify(
        () => first.close(StreamVideoCloseCode.disposeOldSocket),
      ).called(1);
      verifyNever(() => first.leave(reason: any(named: 'reason')));
      harness.verifyMakeCallSessionCount(2);
      expect(statuses.last, isA<CallStatusConnected>());
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

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
      harness.verifyMakeCallSessionCount(3);
      verifyNever(third.waitForMigrationComplete);
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );
}
