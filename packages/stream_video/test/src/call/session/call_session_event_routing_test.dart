import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/call/stats/stats_reporter.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_ended_reason.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_pin.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_layer_setting.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_sender.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

SfuJoinResponseEvent _joinResponse({bool isReconnected = false}) =>
    SfuJoinResponseEvent(
      callState: harnessSfuCallState(),
      isReconnected: isReconnected,
    );

final _alice = harnessSfuParticipant();

class _MockStatsReporter extends Mock implements StatsReporter {}

class _MockCallMetrics extends Mock implements CallMetrics {}

const _vp8 = SfuCodec(
  payloadType: 96,
  name: 'vp8',
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

SfuVideoSender _videoSender(int publishOptionId) => SfuVideoSender(
  codec: _vp8,
  layers: const <SfuVideoLayerSetting>[],
  trackType: SfuTrackType.video,
  publishOptionId: publishOptionId,
);

const _pin = SfuPin(userId: 'alice', sessionId: 'alice-session');

void main() {
  setUpAll(() {
    registerCallSessionHarnessFallbacks();
    registerFallbackValue(_videoSender(0));
    registerFallbackValue(StreamPeerType.subscriber);
  });

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

  group('the media handlers', () {
    test('a publish quality change goes to the manager once per video '
        'sender, with the codec the publisher reports', () async {
      final metrics = _MockCallMetrics();
      when(() => metrics.publisher).thenReturn(
        const PeerConnectionStats(
          latency: null,
          resolution: null,
          qualityDropReason: null,
          jitterInMs: null,
          bitrateKbps: null,
          videoCodec: ['vp9', 'vp8'],
        ),
      );
      final statsReporter = _MockStatsReporter();
      when(() => statsReporter.currentMetrics).thenReturn(metrics);
      harness.session.statsReporter = statsReporter;
      when(
        () => harness.rtcManager.onPublishQualityChanged(any(), any()),
      ).thenAnswer((_) async {});

      await harness.session.debugHandleSfuEvent(
        SfuChangePublishQualityEvent(
          audioSenders: const [],
          videoSenders: [_videoSender(1), _videoSender(2)],
        ),
      );

      verifyInOrder([
        () =>
            harness.rtcManager.onPublishQualityChanged(_videoSender(1), 'vp9'),
        () =>
            harness.rtcManager.onPublishQualityChanged(_videoSender(2), 'vp9'),
      ]);
      verify(() => statsReporter.currentMetrics).called(1);
    });

    test('a publish options change goes to the manager', () async {
      when(
        () => harness.rtcManager.onPublishOptionsChanged(any()),
      ).thenAnswer((_) async {});

      await harness.session.debugHandleSfuEvent(
        SfuChangePublishOptionsEvent(publishOptions: harnessPublishOptions),
      );

      verify(
        () => harness.rtcManager.onPublishOptionsChanged(harnessPublishOptions),
      ).called(1);
    });

    test('an ICE trickle goes to the manager', () async {
      when(
        () => harness.rtcManager.onRemoteIceCandidate(
          peerType: any(named: 'peerType'),
          iceCandidate: any(named: 'iceCandidate'),
        ),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.session.debugHandleSfuEvent(
        const SfuIceTrickleEvent(
          sessionId: 'session',
          peerType: StreamPeerType.subscriber,
          iceCandidate: 'candidate',
        ),
      );

      verify(
        () => harness.rtcManager.onRemoteIceCandidate(
          peerType: StreamPeerType.subscriber,
          iceCandidate: 'candidate',
        ),
      ).called(1);
    });
  });

  group('the state forwards', () {
    // Each case sends one event and names the state method it should reach.
    final cases =
        <String, (SfuEvent, void Function(CallStateNotifier, SfuEvent))>{
          'connection quality changed': (
            const SfuConnectionQualityChangedEvent(
              connectionQualityUpdates: [],
            ),
            (s, e) => s.sfuConnectionQualityChanged(
              e as SfuConnectionQualityChangedEvent,
            ),
          ),
          'audio level changed': (
            const SfuAudioLevelChangedEvent(audioLevels: []),
            (s, e) =>
                s.sfuUpdateAudioLevelChanged(e as SfuAudioLevelChangedEvent),
          ),
          'dominant speaker changed': (
            const SfuDominantSpeakerChangedEvent(
              userId: 'alice',
              sessionId: 'alice-session',
            ),
            (s, e) => s.sfuDominantSpeakerChanged(
              e as SfuDominantSpeakerChangedEvent,
            ),
          ),
          'pins updated': (
            const SfuPinsUpdatedEvent(pins: [_pin]),
            (s, e) => s.sfuPinsUpdated((e as SfuPinsUpdatedEvent).pins),
          ),
          'inbound state notification': (
            const SfuInboundStateNotificationEvent(inboundVideoStates: []),
            (s, e) => s.sfuInboundStateNotification(
              e as SfuInboundStateNotificationEvent,
            ),
          ),
          'track unpublished': (
            SfuTrackUnpublishedEvent(
              userId: 'alice',
              sessionId: 'alice-session',
              trackType: SfuTrackType.video,
              participant: _alice,
            ),
            (s, e) => s.sfuTrackUnpublished(e as SfuTrackUnpublishedEvent),
          ),
        };

    for (final MapEntry(key: name, value: (event, forward)) in cases.entries) {
      test('$name reaches the state once', () async {
        await harness.session.debugHandleSfuEvent(event);

        verify(() => forward(harness.stateManager, event)).called(1);
      });
    }
  });

  test('the traced events are traced under their tag', () async {
    harness.takeTraceTags();
    const error = SfuError(
      message: 'boom',
      code: SfuErrorCode.unspecified,
      shouldRetry: false,
      reconnectStrategy: SfuReconnectionStrategy.unspecified,
    );
    when(
      () => harness.rtcManager.onPublishQualityChanged(any(), any()),
    ).thenAnswer((_) async {});
    when(
      () => harness.rtcManager.onPublishOptionsChanged(any()),
    ).thenAnswer((_) async {});

    for (final event in <SfuEvent>[
      SfuTrackPublishedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
        trackType: SfuTrackType.video,
        participant: _alice,
      ),
      SfuTrackUnpublishedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
        trackType: SfuTrackType.video,
        participant: _alice,
      ),
      const SfuChangePublishQualityEvent(audioSenders: [], videoSenders: []),
      const SfuChangePublishOptionsEvent(publishOptions: []),
      const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      const SfuErrorEvent(error: error),
      const SfuCallEndedEvent(callEndedReason: SfuCallEndedReason.ended),
      const SfuConnectionQualityChangedEvent(connectionQualityUpdates: []),
      const SfuInboundStateNotificationEvent(inboundVideoStates: []),
    ]) {
      await harness.session.debugHandleSfuEvent(event);
    }

    expect(harness.takeTraceTags(), [
      TraceTag.trackPublished,
      TraceTag.trackUnpublished,
      TraceTag.changePublishQuality,
      TraceTag.changePublishOptions,
      TraceTag.goAway,
      TraceTag.error,
      TraceTag.callEnded,
      TraceTag.connectionQualityChanged,
      TraceTag.inboundVideoState,
    ]);
  });
}
