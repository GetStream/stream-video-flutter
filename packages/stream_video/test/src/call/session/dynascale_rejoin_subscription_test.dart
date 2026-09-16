import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';

/// The three remote participants this call has, besides the local user.
const _remoteIds = ['alice', 'bob', 'carol'];

SfuParticipant _sfuParticipant(String id) => SfuParticipant(
  userId: id,
  userName: id,
  userImage: '',
  sessionId: '$id-session',
  custom: const {},
  customData: const {},
  publishedTracks: [SfuTrackType.video],
  joinedAt: DateTime.now(),
  trackLookupPrefix: '$id-prefix',
  connectionQuality: SfuConnectionQuality.excellent,
  isSpeaking: false,
  isDominantSpeaker: false,
  audioLevel: 0,
  roles: const [],
  participantSource: SfuParticipantSource.webrtc,
);

const _dimension = RtcVideoDimension(width: 640, height: 480);

SfuJoinResponseEvent _joinResponse() => SfuJoinResponseEvent(
  callState: SfuCallState(
    participants: _remoteIds.map(_sfuParticipant).toList(),
    participantCount: const SfuParticipantCount(total: 4, anonymous: 0),
    startedAt: DateTime.now(),
    pins: const [],
    e2eeEnabled: false,
  ),
  isReconnected: true,
);

SubscriptionChange _videoChange(String id) => SubscriptionChange.update(
  userId: id,
  sessionId: '$id-session',
  trackIdPrefix: '$id-prefix',
  trackType: SfuTrackType.video,
  videoDimension: _dimension,
);

void main() {
  late CallStateNotifier stateNotifier;
  late MockSfuClient sfuClient;
  late DynascaleManager dynascale;
  late List<sfu.UpdateSubscriptionsRequest> sentRequests;

  setUpAll(() {
    registerFallbackValue(sfu.UpdateSubscriptionsRequest());
  });

  setUp(() {
    stateNotifier = CallStateNotifier(
      CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.defaultType(),
          id: 'test-call',
        ),
        currentUserId: 'local-user',
        preferences: DefaultCallPreferences(),
      ),
    );

    sentRequests = [];
    sfuClient = MockSfuClient();
    when(() => sfuClient.updateSubscriptions(any())).thenAnswer((invocation) {
      sentRequests.add(
        invocation.positionalArguments.first as sfu.UpdateSubscriptionsRequest,
      );
      return Future.value(
        Result.success(sfu.UpdateSubscriptionsResponse()),
      );
    });

    dynascale = DynascaleManager(stateManager: stateNotifier)
      ..init(sfuClient: sfuClient, sessionId: 'session-1');

    // Steady state: the initial join response lists everyone, the renderer
    // has asked for a size, and the media has arrived.
    stateNotifier.sfuJoinResponse(_joinResponse());

    for (final id in _remoteIds) {
      stateNotifier.participantUpdateSubscription(
        userId: id,
        sessionId: '$id-session',
        trackIdPrefix: '$id-prefix',
        trackType: SfuTrackType.video,
        videoDimension: _dimension,
      );
      stateNotifier.rtcUpdateSubscriberTrack(
        trackIdPrefix: '$id-prefix',
        trackType: SfuTrackType.video,
      );
    }
  });

  tearDown(() async {
    await dynascale.dispose();
    stateNotifier.dispose();
  });

  /// The track ids of the n-th request the SFU received.
  List<String> tracksOf(int index) => sentRequests[index].tracks
      .map((t) => '${t.sessionId}:${t.trackType}')
      .toList();

  test(
    'a subscription update after a rejoin keeps every participant subscribed',
    () async {
      // Baseline: all three are subscribed, so the SFU is told about all three.
      await dynascale.updateSubscriptions(
        _remoteIds.map(_videoChange).toList(),
      );

      expect(sentRequests, hasLength(1));
      expect(tracksOf(0), hasLength(3), reason: 'baseline: all three tracks');

      // A rejoin lands: the join response replaces every participant, which
      // resets their remote track state to `subscribed: false`.
      stateNotifier.sfuJoinResponse(_joinResponse());

      // One tile's size changes before the remote tracks are re-received —
      // exactly what VideoRenderer._onSizeChanged does on a placeholder swap.
      await dynascale.updateSubscriptions([_videoChange('alice')]);

      expect(sentRequests, hasLength(2));
      expect(
        tracksOf(1),
        hasLength(3),
        reason:
            'a single tile resizing must not unsubscribe bob and carol — the '
            'SFU replaces its whole subscription set with this list',
      );
    },
  );

  test(
    'a join response keeps the subscription but waits for the media again',
    () async {
      await dynascale.updateSubscriptions(
        _remoteIds.map(_videoChange).toList(),
      );

      stateNotifier.sfuJoinResponse(_joinResponse());

      final track =
          stateNotifier.state.callParticipants
                  .firstWhere((it) => it.userId == 'bob')
                  .publishedTracks[SfuTrackType.video]!
              as RemoteTrackState;

      expect(
        track.subscribed,
        isTrue,
        reason: 'what this client asked the SFU for survives the rejoin',
      );
      expect(
        track.videoDimension,
        _dimension,
        reason: 'so does the dimension the renderer asked for',
      );
      expect(
        track.received,
        isFalse,
        reason:
            'the subscriber peer connection is new, so the media has to arrive '
            'again before the renderer shows it',
      );
    },
  );
}
