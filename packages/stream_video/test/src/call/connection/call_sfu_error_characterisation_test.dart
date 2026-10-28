import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins how a connected call reacts to an error the SFU sends, so moving the
/// connection code out of `Call` cannot change it unnoticed.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  SfuErrorEvent sfuError(
    SfuReconnectionStrategy strategy, {
    SfuErrorCode code = SfuErrorCode.internalServerError,
  }) {
    return SfuErrorEvent(
      error: SfuError(
        message: 'sfu says no',
        code: code,
        shouldRetry: true,
        reconnectStrategy: strategy,
      ),
    );
  }

  Future<Call> joinedCall() async {
    final call = harness.buildCall();
    await call.join();
    return call;
  }

  void verifyFastReconnectCount(int count) {
    (count == 0 ? verifyNever : verify)(
      () => harness.session.fastReconnect(
        reconnectDetails: any(named: 'reconnectDetails'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
      ),
    ).called(count);
  }

  group('join error codes are left to the join', () {
    for (final code in [
      SfuErrorCode.sfuFull,
      SfuErrorCode.sfuShuttingDown,
      SfuErrorCode.callParticipantLimitReached,
    ]) {
      test('$code is ignored, even with the migrate strategy', () async {
        final call = await joinedCall();

        await harness.emitSfu(
          harness.session,
          sfuError(SfuReconnectionStrategy.migrate, code: code),
        );

        expect(call.state.value.status, isA<CallStatusConnected>());
        harness.verifyJoinCallCount(1);
        expect(harness.reporter.aborts, isEmpty);
      });
    }
  });

  group('the strategy the error carries', () {
    test('fast starts a fast reconnect', () async {
      final call = await joinedCall();
      final reconnectGate = Completer<void>();
      harness.stubFastReconnect(harness.session, () async {
        await reconnectGate.future;
        return sessionStartSuccess();
      });

      await harness.emitSfu(
        harness.session,
        sfuError(SfuReconnectionStrategy.fast),
      );

      expect(
        call.state.value.status,
        isA<CallStatusReconnecting>().having(
          (s) => s.isFastReconnectAttempt,
          'isFastReconnectAttempt',
          isTrue,
        ),
      );
      verifyFastReconnectCount(1);
      reconnectGate.complete();
    });

    test('rejoin starts a rejoin', () async {
      final call = await joinedCall();

      await harness.emitSfu(
        harness.session,
        sfuError(SfuReconnectionStrategy.rejoin),
      );

      expect(
        call.state.value.status,
        isA<CallStatusReconnecting>().having(
          (s) => s.isFastReconnectAttempt,
          'isFastReconnectAttempt',
          isFalse,
        ),
      );
      verifyFastReconnectCount(0);
    });

    test('migrate starts a migration', () async {
      final call = await joinedCall();

      await harness.emitSfu(
        harness.session,
        sfuError(SfuReconnectionStrategy.migrate),
      );

      expect(call.state.value.status, isA<CallStatusMigrating>());
      verifyFastReconnectCount(0);
    });

    test('disconnect leaves the call with the SFU error', () async {
      final call = await joinedCall();

      await harness.emitSfu(
        harness.session,
        sfuError(SfuReconnectionStrategy.disconnect),
      );

      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonSfuError>());
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
      verify(
        () => harness.session.leave(
          reason: any(named: 'reason', that: startsWith('sfu error: ')),
        ),
      ).called(1);
    });

    test('unspecified does nothing', () async {
      final call = await joinedCall();

      await harness.emitSfu(
        harness.session,
        sfuError(SfuReconnectionStrategy.unspecified),
      );

      expect(call.state.value.status, isA<CallStatusConnected>());
      verifyFastReconnectCount(0);
      harness.verifyJoinCallCount(1);
      expect(harness.reporter.aborts, isEmpty);
    });
  });
}
