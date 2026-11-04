import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_ended_reason.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

SfuJoinResponseEvent _joinResponse({bool isReconnected = false}) =>
    SfuJoinResponseEvent(
      callState: harnessSfuCallState(),
      isReconnected: isReconnected,
    );

final _alice = harnessSfuParticipant();

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late CallSessionHarness harness;

  setUp(() {
    harness = CallSessionHarness();
    harness.session.rtcManager = harness.rtcManager;
  });

  group('the state forward runs after the media handler', () {
    test('a participant left removes the subscriber, then updates state, then '
        'discards the pending decryptors', () async {
      await harness.session.debugHandleSfuEvent(
        SfuParticipantLeftEvent(callCid: 'cid', participant: _alice),
      );

      verifyInOrder([
        () => harness.rtcManager.removeSubscriber('alice-prefix'),
        () => harness.stateManager.sfuParticipantLeft(any()),
        () => harness.rtcManager.discardPendingDecryptors('alice-prefix'),
      ]);
      verifyNever(harness.rtcManager.flushPendingDecryptors);
    });

    test('a track published starts the track, then updates state, then '
        'flushes the pending decryptors', () async {
      harness.state = harness.state.copyWith(
        callParticipants: [harnessParticipant()],
      );
      final track = MockRtcRemoteTrack();
      when(() => track.isAudioTrack).thenReturn(false);
      when(track.start).thenAnswer((_) async {});
      when(
        () => harness.rtcManager.getTrack('alice-prefix:${SfuTrackType.video}'),
      ).thenReturn(track);

      await harness.session.debugHandleSfuEvent(
        SfuTrackPublishedEvent(
          userId: 'alice',
          sessionId: 'alice-session',
          trackType: SfuTrackType.video,
          participant: _alice,
        ),
      );

      verifyInOrder([
        track.start,
        () => harness.stateManager.sfuTrackPublished(any()),
        harness.rtcManager.flushPendingDecryptors,
      ]);
    });
  });

  group('pending decryptors', () {
    test('a join response flushes them after the state', () async {
      await harness.session.debugHandleSfuEvent(_joinResponse());

      verifyInOrder([
        () => harness.stateManager.sfuJoinResponse(
          any(),
          subscriberReused: any(named: 'subscriberReused'),
        ),
        harness.rtcManager.flushPendingDecryptors,
      ]);
    });

    test('a participant joined flushes them after the state', () async {
      await harness.session.debugHandleSfuEvent(
        SfuParticipantJoinedEvent(callCid: 'cid', participant: _alice),
      );

      verifyInOrder([
        () => harness.stateManager.sfuParticipantJoined(any()),
        harness.rtcManager.flushPendingDecryptors,
      ]);
    });

    test('a participant updated leaves them alone', () async {
      await harness.session.debugHandleSfuEvent(
        SfuParticipantUpdatedEvent(callCid: 'cid', participant: _alice),
      );

      verify(() => harness.stateManager.sfuParticipantUpdated(any())).called(1);
      verifyNever(harness.rtcManager.flushPendingDecryptors);
      verifyNever(() => harness.rtcManager.discardPendingDecryptors(any()));
    });
  });

  group('subscriberReused', () {
    List<bool> reusedFlags() => verify(
      () => harness.stateManager.sfuJoinResponse(
        any(),
        subscriberReused: captureAny(named: 'subscriberReused'),
      ),
    ).captured.cast<bool>();

    test(
      'is false for the first join response, even a reconnected one',
      () async {
        await harness.session.debugHandleSfuEvent(
          _joinResponse(isReconnected: true),
        );

        expect(reusedFlags(), [false]);
      },
    );

    test('is true for a reconnect on the manager of the last join', () async {
      await harness.session.debugHandleSfuEvent(_joinResponse());
      await harness.session.debugHandleSfuEvent(
        _joinResponse(isReconnected: true),
      );

      expect(reusedFlags(), [false, true]);
    });

    test('is false for a join that is not a reconnect', () async {
      await harness.session.debugHandleSfuEvent(_joinResponse());
      await harness.session.debugHandleSfuEvent(_joinResponse());

      expect(reusedFlags(), [false, false]);
    });

    test('is false once the manager was replaced', () async {
      await harness.session.debugHandleSfuEvent(_joinResponse());
      final replacement = MockRtcManager();
      when(replacement.flushPendingDecryptors).thenAnswer((_) async {});
      harness.session.rtcManager = replacement;
      await harness.session.debugHandleSfuEvent(
        _joinResponse(isReconnected: true),
      );

      expect(reusedFlags(), [false, false]);
    });
  });

  test('the traced events are traced under their tag', () async {
    harness.takeTraceTags();
    const error = SfuError(
      message: 'boom',
      code: SfuErrorCode.unspecified,
      shouldRetry: false,
      reconnectStrategy: SfuReconnectionStrategy.unspecified,
    );

    for (final event in <SfuEvent>[
      const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      const SfuErrorEvent(error: error),
      const SfuCallEndedEvent(callEndedReason: SfuCallEndedReason.ended),
    ]) {
      await harness.session.debugHandleSfuEvent(event);
    }

    expect(harness.takeTraceTags(), [
      TraceTag.goAway,
      TraceTag.error,
      TraceTag.callEnded,
    ]);
  });
}
