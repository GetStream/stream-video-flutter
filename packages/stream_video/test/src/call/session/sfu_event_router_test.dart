import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/session/session_signaling.dart';
import 'package:stream_video/src/call/session/session_track_controller.dart';
import 'package:stream_video/src/call/session/sfu_event_router.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_ended_reason.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_video_sender.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

class _MockSessionSignaling extends Mock implements SessionSignaling {}

class _MockSessionTrackController extends Mock
    implements SessionTrackController {}

final _alice = harnessSfuParticipant();

const _codec = SfuCodec(
  payloadType: 96,
  name: 'vp8',
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

SfuParticipantJoinedEvent _joined(String userId) => SfuParticipantJoinedEvent(
  callCid: 'cid',
  participant: harnessSfuParticipant(userId: userId),
);

void main() {
  setUpAll(() {
    registerCallSessionHarnessFallbacks();
    registerFallbackValue(
      const SfuIceTrickleEvent(
        sessionId: '',
        peerType: StreamPeerType.subscriber,
        iceCandidate: '',
      ),
    );
    registerFallbackValue(
      SfuVideoSender(
        codec: _codec,
        layers: const [],
        trackType: SfuTrackType.video,
        publishOptionId: 0,
      ),
    );
  });

  late MockCallStateNotifier stateManager;
  late MockRtcManager rtcManager;
  RtcManager? manager;
  late _MockSessionSignaling signaling;
  late _MockSessionTrackController tracks;
  late Tracer tracer;
  late StreamController<SfuEvent> events;
  late SfuEventRouter router;

  setUp(() {
    stateManager = MockCallStateNotifier();
    rtcManager = MockRtcManager();
    manager = rtcManager;
    signaling = _MockSessionSignaling();
    tracks = _MockSessionTrackController();
    tracer = Tracer(null);
    events = StreamController<SfuEvent>.broadcast();

    when(rtcManager.flushPendingDecryptors).thenAnswer((_) async {});
    when(() => rtcManager.discardPendingDecryptors(any())).thenReturn(null);
    when(() => rtcManager.removeSubscriber(any())).thenAnswer((_) async {});
    when(() => signaling.onSubscriberOffer(any())).thenAnswer((_) async {});
    when(() => signaling.onIceRestart(any())).thenAnswer((_) async {});
    when(() => tracks.onTrackPublished(any())).thenAnswer((_) async {});
    when(() => tracks.onTrackUnpublished(any())).thenAnswer((_) async {});

    router = SfuEventRouter(
      stateManager: stateManager,
      rtcManager: () => manager,
      signaling: signaling,
      tracks: tracks,
      statsReporter: () => null,
      tracer: tracer,
      logTag: 'test',
    );
  });

  tearDown(() async {
    await router.dispose();
    await events.close();
  });

  List<String> joinedUserIds() => [
    for (final event in verify(
      () => stateManager.sfuParticipantJoined(captureAny()),
    ).captured.cast<SfuParticipantJoinedEvent>())
      event.participant.userId,
  ];

  group('the manager gate', () {
    test('holds events back until the manager is attached, then delivers '
        'them and the rest in order, once each', () async {
      await router.listen(events.stream);

      events
        ..add(_joined('a'))
        ..add(_joined('b'));
      await pumpEventQueue();
      verifyNever(() => stateManager.sfuParticipantJoined(any()));

      router.attachManager(rtcManager);
      await pumpEventQueue();
      events.add(_joined('c'));
      await pumpEventQueue();

      expect(joinedUserIds(), ['a', 'b', 'c']);
    });

    test('a second listen stops the first and opens a new gate', () async {
      await router.listen(events.stream);
      router.attachManager(rtcManager);

      final next = StreamController<SfuEvent>.broadcast();
      await router.listen(next.stream);
      events.add(_joined('old'));
      next.add(_joined('held'));
      await pumpEventQueue();
      verifyNever(() => stateManager.sfuParticipantJoined(any()));

      router.attachManager(rtcManager);
      await pumpEventQueue();

      expect(joinedUserIds(), ['held']);
      await next.close();
    });

    test('dispose stops routing and closes the gate', () async {
      await router.listen(events.stream);
      router.attachManager(rtcManager);
      expect(router.isManagerSubjectClosed, isFalse);

      await router.dispose();
      events.add(_joined('a'));
      await pumpEventQueue();

      expect(router.isManagerSubjectClosed, isTrue);
      verifyNever(() => stateManager.sfuParticipantJoined(any()));
    });

    test('is closed before the first listen', () {
      expect(router.isManagerSubjectClosed, isTrue);
    });
  });

  group('dispatch', () {
    test('a subscriber offer goes to the signaling only', () async {
      const offer = SfuSubscriberOfferEvent(
        sdp: 'sdp',
        iceRestart: false,
        negotiationId: 1,
      );

      await router.onEvent(offer);

      verify(() => signaling.onSubscriberOffer(offer)).called(1);
      verifyZeroInteractions(stateManager);
    });

    test('an ICE restart goes to the signaling', () async {
      const restart = SfuIceRestartEvent(peerType: StreamPeerType.publisher);

      await router.onEvent(restart);

      verify(() => signaling.onIceRestart(restart)).called(1);
      verifyZeroInteractions(stateManager);
    });

    test('a track published starts the track, then reaches state, then '
        'flushes the decryptors, and is traced', () async {
      final event = SfuTrackPublishedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
        trackType: SfuTrackType.video,
        participant: _alice,
      );

      await router.onEvent(event);

      verifyInOrder([
        () => tracks.onTrackPublished(event),
        () => stateManager.sfuTrackPublished(event),
        rtcManager.flushPendingDecryptors,
      ]);
      expect(
        [for (final r in tracer.take().snapshot) r.tag],
        [
          TraceTag.trackPublished,
        ],
      );
    });

    test('a track unpublished stops the track, then reaches state', () async {
      final event = SfuTrackUnpublishedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
        trackType: SfuTrackType.video,
        participant: _alice,
      );

      await router.onEvent(event);

      verifyInOrder([
        () => tracks.onTrackUnpublished(event),
        () => stateManager.sfuTrackUnpublished(event),
      ]);
      verifyNever(rtcManager.flushPendingDecryptors);
    });

    test('a participant left removes the subscriber, then reaches state, then '
        'discards the decryptors', () async {
      final event = SfuParticipantLeftEvent(
        callCid: 'cid',
        participant: _alice,
      );

      await router.onEvent(event);

      verifyInOrder([
        () => rtcManager.removeSubscriber('alice-prefix'),
        () => stateManager.sfuParticipantLeft(event),
        () => rtcManager.discardPendingDecryptors('alice-prefix'),
      ]);
    });

    test('a participant joined reaches state, then flushes the '
        'decryptors', () async {
      final event = _joined('a');

      await router.onEvent(event);

      verifyInOrder([
        () => stateManager.sfuParticipantJoined(event),
        rtcManager.flushPendingDecryptors,
      ]);
    });

    test('an ICE candidate goes to the signaling', () async {
      const trickle = SfuIceTrickleEvent(
        sessionId: 'session',
        peerType: StreamPeerType.subscriber,
        iceCandidate: 'candidate',
      );
      when(
        () => signaling.onRemoteIceCandidate(any()),
      ).thenAnswer((_) async {});

      await router.onEvent(trickle);

      verify(() => signaling.onRemoteIceCandidate(trickle)).called(1);
    });

    test('a publish quality change goes to the manager once per video '
        'sender', () async {
      when(
        () => rtcManager.onPublishQualityChanged(any(), any()),
      ).thenAnswer((_) async {});
      final event = SfuChangePublishQualityEvent(
        audioSenders: const [],
        videoSenders: [
          SfuVideoSender(
            trackType: SfuTrackType.video,
            codec: _codec,
            publishOptionId: 1,
            layers: const [],
          ),
          SfuVideoSender(
            trackType: SfuTrackType.screenShare,
            codec: _codec,
            publishOptionId: 2,
            layers: const [],
          ),
        ],
      );

      await router.onEvent(event);

      verify(() => rtcManager.onPublishQualityChanged(any(), null)).called(2);
      expect(
        [for (final r in tracer.take().snapshot) r.tag],
        [
          TraceTag.changePublishQuality,
        ],
      );
    });

    test('a publish options change goes to the manager', () async {
      when(
        () => rtcManager.onPublishOptionsChanged(any()),
      ).thenAnswer((_) async {});
      const event = SfuChangePublishOptionsEvent(publishOptions: []);

      await router.onEvent(event);

      verify(() => rtcManager.onPublishOptionsChanged(const [])).called(1);
      expect(
        [for (final r in tracer.take().snapshot) r.tag],
        [
          TraceTag.changePublishOptions,
        ],
      );
    });

    test('the trace-only events are only traced', () async {
      for (final event in <SfuEvent>[
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
        const SfuErrorEvent(
          error: SfuError(
            message: 'boom',
            code: SfuErrorCode.unspecified,
            shouldRetry: false,
            reconnectStrategy: SfuReconnectionStrategy.unspecified,
          ),
        ),
        const SfuCallEndedEvent(callEndedReason: SfuCallEndedReason.ended),
      ]) {
        await router.onEvent(event);
      }

      expect(
        [for (final r in tracer.take().snapshot) r.tag],
        [
          TraceTag.goAway,
          TraceTag.error,
          TraceTag.callEnded,
        ],
      );
      verifyZeroInteractions(stateManager);
    });

    test('the state-only events reach their state method', () async {
      final updated = SfuParticipantUpdatedEvent(
        callCid: 'cid',
        participant: _alice,
      );
      const quality = SfuConnectionQualityChangedEvent(
        connectionQualityUpdates: [],
      );
      const audioLevel = SfuAudioLevelChangedEvent(audioLevels: []);
      const speaker = SfuDominantSpeakerChangedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
      );
      const pins = SfuPinsUpdatedEvent(pins: []);
      const inbound = SfuInboundStateNotificationEvent(inboundVideoStates: []);

      for (final event in <SfuEvent>[
        updated,
        quality,
        audioLevel,
        speaker,
        pins,
        inbound,
      ]) {
        await router.onEvent(event);
      }

      verifyInOrder([
        () => stateManager.sfuParticipantUpdated(updated),
        () => stateManager.sfuConnectionQualityChanged(quality),
        () => stateManager.sfuUpdateAudioLevelChanged(audioLevel),
        () => stateManager.sfuDominantSpeakerChanged(speaker),
        () => stateManager.sfuPinsUpdated(const []),
        () => stateManager.sfuInboundStateNotification(inbound),
      ]);
      expect(
        [for (final r in tracer.take().snapshot) r.tag],
        [
          TraceTag.connectionQualityChanged,
          TraceTag.inboundVideoState,
        ],
      );
      verifyNever(rtcManager.flushPendingDecryptors);
    });

    test('without a manager the state is still updated', () async {
      manager = null;

      await router.onEvent(_joined('a'));

      verify(() => stateManager.sfuParticipantJoined(any())).called(1);
    });
  });

  group('join response', () {
    SfuJoinResponseEvent joinResponse({bool isReconnected = false}) =>
        SfuJoinResponseEvent(
          callState: harnessSfuCallState(),
          isReconnected: isReconnected,
        );

    List<bool> reusedFlags() => verify(
      () => stateManager.sfuJoinResponse(
        any(),
        subscriberReused: captureAny(named: 'subscriberReused'),
      ),
    ).captured.cast<bool>();

    test('reuses the subscriber only for a reconnect on the joined '
        'manager', () async {
      await router.onEvent(joinResponse(isReconnected: true));
      await router.onEvent(joinResponse(isReconnected: true));
      await router.onEvent(joinResponse());

      expect(reusedFlags(), [false, true, false]);
      verify(rtcManager.flushPendingDecryptors).called(3);
    });

    test('a reconnect on another manager does not reuse the '
        'subscriber', () async {
      await router.onEvent(joinResponse());
      final replacement = MockRtcManager();
      when(replacement.flushPendingDecryptors).thenAnswer((_) async {});
      manager = replacement;
      await router.onEvent(joinResponse(isReconnected: true));

      expect(reusedFlags(), [false, false]);
    });

    test(
      'a reconnect without a manager does not reuse the subscriber',
      () async {
        manager = null;
        await router.onEvent(joinResponse());
        await router.onEvent(joinResponse(isReconnected: true));

        expect(reusedFlags(), [false, false]);
      },
    );

    test('forgets the joined manager when told to', () async {
      await router.onEvent(joinResponse());
      router.forgetJoinedManager();
      await router.onEvent(joinResponse(isReconnected: true));

      expect(reusedFlags(), [false, false]);
    });
  });

  test('handles one event at a time', () async {
    final offerAnswered = Completer<void>();
    when(
      () => signaling.onSubscriberOffer(any()),
    ).thenAnswer((_) => offerAnswered.future);

    final offer = router.onEvent(
      const SfuSubscriberOfferEvent(
        sdp: 'sdp',
        iceRestart: false,
        negotiationId: 1,
      ),
    );
    final joined = router.onEvent(_joined('a'));
    await pumpEventQueue();
    verifyNever(() => stateManager.sfuParticipantJoined(any()));

    offerAnswered.complete();
    await Future.wait([offer, joined]);

    verify(() => stateManager.sfuParticipantJoined(any())).called(1);
  });
}
