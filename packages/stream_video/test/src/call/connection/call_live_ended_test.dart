import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_ended_reason.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// A livestream that ends goes back to backstage: a user who may join
/// backstage stays in the call, everyone else leaves.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  Future<Call> joinedCall({required bool canJoinBackstage}) async {
    final call = harness.buildCall();
    await call.join();
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      ownCapabilities: [
        CallPermission.sendAudio,
        if (canJoinBackstage) CallPermission.joinBackstage,
      ],
    );
    return call;
  }

  void verifyStayed(Call call) {
    final state = call.state.value;
    expect(state.status, isA<CallStatusConnected>());
    expect(state.isBackstage, isTrue);
    verifyNever(() => harness.session.leave(reason: any(named: 'reason')));
  }

  void verifyLeftAsEnded(Call call) {
    final state = call.state.value;
    expect(
      state.status,
      isA<CallStatusDisconnected>().having(
        (status) => status.reason,
        'reason',
        isA<DisconnectReasonEnded>(),
      ),
    );
    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
  }

  SfuErrorEvent liveEndedError(SfuReconnectionStrategy strategy) {
    return SfuErrorEvent(
      error: SfuError(
        message: 'live ended',
        code: SfuErrorCode.liveEnded,
        shouldRetry: false,
        reconnectStrategy: strategy,
      ),
    );
  }

  group('the SFU ends the call because the livestream ended', () {
    const liveEnded = SfuCallEndedEvent(
      callEndedReason: SfuCallEndedReason.liveEnded,
    );

    test('a user who can join backstage stays, in backstage', () async {
      final call = await joinedCall(canJoinBackstage: true);

      await harness.emitSfu(harness.session, liveEnded);

      verifyStayed(call);
    });

    test('a user who cannot join backstage leaves', () async {
      final call = await joinedCall(canJoinBackstage: false);

      await harness.emitSfu(harness.session, liveEnded);

      verifyLeftAsEnded(call);
      expect(call.state.value.isBackstage, isTrue);
    });
  });

  group('the SFU ends the call for another reason', () {
    for (final reason in [
      SfuCallEndedReason.ended,
      SfuCallEndedReason.kicked,
      SfuCallEndedReason.sessionEnded,
      SfuCallEndedReason.unspecified,
    ]) {
      test('$reason leaves, even a user who can join backstage', () async {
        final call = await joinedCall(canJoinBackstage: true);

        await harness.emitSfu(
          harness.session,
          SfuCallEndedEvent(callEndedReason: reason),
        );

        verifyLeftAsEnded(call);
      });
    }
  });

  group('the SFU reports the livestream ended as an error', () {
    for (final strategy in SfuReconnectionStrategy.values) {
      test(
        'a user who can join backstage stays, whatever the strategy '
        '($strategy)',
        () async {
          final call = await joinedCall(canJoinBackstage: true);

          await harness.emitSfu(harness.session, liveEndedError(strategy));

          verifyStayed(call);
          harness.verifyJoinCallCount(1);
        },
      );
    }

    test('a user who cannot join backstage leaves', () async {
      final call = await joinedCall(canJoinBackstage: false);

      await harness.emitSfu(
        harness.session,
        liveEndedError(SfuReconnectionStrategy.disconnect),
      );

      verifyLeftAsEnded(call);
    });
  });
}
