// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/models/call_metadata.dart';
import 'package:stream_video/src/models/call_participant_pin.dart';
import 'package:stream_video/src/models/call_participant_state.dart';
import 'package:stream_video/src/models/call_reaction.dart';
import 'package:stream_video/src/models/call_track_state.dart';
import 'package:stream_video/src/models/viewport_visibility.dart';
import 'package:stream_video/src/sfu/data/models/sfu_connection_quality.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant_source.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/sorting/call_participant_sorting_presets.dart';
import 'package:stream_video/src/sorting/call_participant_state_sorting.dart';

void main() {
  group('sorting comparators', () {
    test('byParticipantSource prioritizes requested source', () {
      final comparator = combineComparators<CallParticipantState>([
        byParticipantSource(SfuParticipantSource.rtmp),
        byName,
      ]);

      final user1 = CallParticipantState(
        name: 'user1',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.webrtc,
      );

      final user2 = CallParticipantState(
        name: 'user2',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.rtmp,
      );

      final user3 = CallParticipantState(
        name: 'user3',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.rtmp,
      );

      final user4 = CallParticipantState(
        name: 'user4',
        userId: '4',
        sessionId: '4',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.sip,
      );

      final list = [user1, user3, user4, user2]..sort(comparator);
      expect(list.first, user2);
      expect(list.map((p) => p.name), ['user2', 'user3', 'user1', 'user4']);
    });

    test('byReactionType prioritizes given reaction type', () {
      final comparator = combineComparators<CallParticipantState>([
        byReactionType('raised-hand'),
        byName,
      ]);

      final none = CallParticipantState(
        name: 'None',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
      );

      final other = CallParticipantState(
        name: 'Other',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        reaction: CallReaction(type: 'wave', user: CallUser.empty()),
      );

      final raised = CallParticipantState(
        name: 'Raised',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        reaction: CallReaction(type: 'raised-hand', user: CallUser.empty()),
      );

      final list = [none, other, raised]..sort(comparator);
      expect(list.first, raised);
      expect(list.map((p) => p.name), ['Raised', 'None', 'Other']);
    });

    test('byRole prioritizes higher number of matching roles', () {
      final comparator = byRole(['admin', 'host']);

      final viewer = CallParticipantState(
        name: 'viewer',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const ['viewer'],
        trackIdPrefix: 'prefix',
      );

      final host = CallParticipantState(
        name: 'host',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const ['host', 'speaker'],
        trackIdPrefix: 'prefix',
      );

      final admin = CallParticipantState(
        name: 'admin',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const ['admin', 'host'],
        trackIdPrefix: 'prefix',
      );

      final list = [admin, host, viewer]..sort(comparator);
      expect(list.map((p) => p.name), ['admin', 'host', 'viewer']);
    });

    test('byName sorts alphabetically', () {
      final bob = CallParticipantState(
        name: 'Bob',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
      );

      final alice = CallParticipantState(
        name: 'Alice',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
      );

      final list = [bob, alice]..sort(byName);
      expect(list.map((p) => p.name), ['Alice', 'Bob']);
    });

    test('ifInvisibleBy applies only when any is not visible', () {
      final comparator = ifInvisibleBy(dominantSpeaker);

      final visibleDominant = CallParticipantState(
        name: 'A',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        isDominantSpeaker: true,
        viewportVisibility: ViewportVisibility.visible,
      );

      final visibleNotDominant = CallParticipantState(
        name: 'B',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        isDominantSpeaker: false,
        viewportVisibility: ViewportVisibility.visible,
      );

      // When both visible, comparator must not change order (returns 0)
      expect(comparator(visibleDominant, visibleNotDominant), 0);

      final invisibleDominant = visibleDominant.copyWith(
        viewportVisibility: ViewportVisibility.unknown,
      );

      // When one is invisible, dominant speaker should be prioritized
      expect(comparator(invisibleDominant, visibleNotDominant), -1);
    });

    test('pinned comparator: remote pins before local, newer before older', () {
      final now = DateTime.now();
      final remoteNewer = CallParticipantState(
        name: 'remoteNewer',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(isLocalPin: false, pinnedAt: now),
      );

      final remoteOlder = CallParticipantState(
        name: 'remoteOlder',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(
          isLocalPin: false,
          pinnedAt: now.subtract(const Duration(minutes: 1)),
        ),
      );

      final local = CallParticipantState(
        name: 'local',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(isLocalPin: true, pinnedAt: now),
      );

      final list = [local, remoteOlder, remoteNewer]..sort(pinned);
      expect(list.map((p) => p.name), ['remoteNewer', 'remoteOlder', 'local']);
    });

    test('pinned comparator: pinned before unpinned', () {
      final pinnedUser = CallParticipantState(
        name: 'Pinned',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(isLocalPin: true, pinnedAt: DateTime.now()),
      );

      final unpinnedUser = CallParticipantState(
        name: 'NotPinned',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
      );

      final list = [unpinnedUser, pinnedUser]..sort(pinned);
      expect(list.first, pinnedUser);
    });
  });

  group('sorting combined comparators', () {
    final participants = [
      CallParticipantState(
        name: 'A',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: {
          SfuTrackType.audio: TrackState.remote(),
          SfuTrackType.video: TrackState.remote(),
        },
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: true,
        isDominantSpeaker: false,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: null,
      ),

      // Presenter, video, audio
      CallParticipantState(
        name: 'B',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: {
          SfuTrackType.audio: TrackState.remote(),
          SfuTrackType.video: TrackState.remote(),
          SfuTrackType.screenShare: TrackState.remote(),
        },
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: false,
        isDominantSpeaker: false,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: null,
      ),

      // Muted
      CallParticipantState(
        name: 'C',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: const {},
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: true,
        isDominantSpeaker: false,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: null,
      ),

      // Dominant speaker
      CallParticipantState(
        name: 'D',
        userId: '4',
        sessionId: '4',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: {SfuTrackType.audio: TrackState.remote()},
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: true,
        isDominantSpeaker: true,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: null,
      ),

      // Presenter only
      CallParticipantState(
        name: 'E',
        userId: '5',
        sessionId: '5',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: {SfuTrackType.screenShare: TrackState.remote()},
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: false,
        isDominantSpeaker: false,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: null,
      ),

      // pinned
      CallParticipantState(
        name: 'F',
        userId: '6',
        sessionId: '6',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: '123',
        publishedTracks: {
          SfuTrackType.audio: TrackState.remote(),
          SfuTrackType.video: TrackState.remote(),
        },
        connectionQuality: SfuConnectionQuality.excellent,
        isSpeaking: false,
        isDominantSpeaker: false,
        audioLevel: 0,
        viewportVisibility: ViewportVisibility.visible,
        pin: CallParticipantPin(isLocalPin: true, pinnedAt: DateTime.now()),
      ),
    ];

    test('presenter, dominant speaker, video, audio, mute', () {
      final comparator = combineComparators([
        screenSharing,
        dominantSpeaker,
        publishingVideo,
        publishingAudio,
      ]);

      final sorted = participants..sort(comparator);
      expect(sorted.map((p) => p.name), ['B', 'E', 'D', 'A', 'F', 'C']);
    });

    test('pinned, dominant speaker, audio, video, screenshare, mute', () {
      final comparator = combineComparators([
        pinned,
        dominantSpeaker,
        publishingAudio,
        publishingVideo,
        screenSharing,
      ]);

      final sorted = participants..sort(comparator);
      expect(sorted.map((p) => p.name), ['F', 'D', 'B', 'A', 'E', 'C']);
    });
  });

  group('sorting presets', () {
    test('regular: pinned > screenShare; dominant applies only if invisible',
        () {
      final now = DateTime.now();

      final pinnedUser = CallParticipantState(
        name: 'Pinned',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(isLocalPin: true, pinnedAt: now),
        viewportVisibility: ViewportVisibility.visible,
      );

      final screenSharer = CallParticipantState(
        name: 'Screen',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        publishedTracks: {
          SfuTrackType.screenShare: TrackState.remote(),
        },
        viewportVisibility: ViewportVisibility.visible,
      );

      final dominantInvisible = CallParticipantState(
        name: 'Dominant',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        isDominantSpeaker: true,
        viewportVisibility: ViewportVisibility.unknown,
      );

      final speakingVisible = CallParticipantState(
        name: 'Speaking',
        userId: '4',
        sessionId: '4',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        isSpeaking: true,
        viewportVisibility: ViewportVisibility.visible,
      );

      final others = CallParticipantState(
        name: 'Other',
        userId: '5',
        sessionId: '5',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        viewportVisibility: ViewportVisibility.visible,
      );

      final list = [
        others,
        speakingVisible,
        dominantInvisible,
        pinnedUser,
        screenSharer,
      ]..sort(CallParticipantSortingPresets.regular);

      expect(list.first, pinnedUser);
      expect(list[1], screenSharer);
      expect(list[2], dominantInvisible);
    });

    test('speaker: pinned > screenShare > dominant', () {
      final pinnedUser = CallParticipantState(
        name: 'Pinned',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        pin: CallParticipantPin(isLocalPin: true, pinnedAt: DateTime.now()),
        viewportVisibility: ViewportVisibility.visible,
      );

      final screenSharer = CallParticipantState(
        name: 'Screen',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        publishedTracks: {
          SfuTrackType.screenShare: TrackState.remote(),
        },
        viewportVisibility: ViewportVisibility.visible,
      );

      final dominant = CallParticipantState(
        name: 'Dominant',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        isDominantSpeaker: true,
        viewportVisibility: ViewportVisibility.visible,
      );

      final list = [dominant, screenSharer, pinnedUser]
        ..sort(CallParticipantSortingPresets.speaker);

      expect(list[0], pinnedUser);
      expect(list[1], screenSharer);
      expect(list[2], dominant);
    });

    test(
        'livestreamOrAudioRoom: rtmp prioritized; then roles (admin/host/speaker)',
        () {
      final viewer = CallParticipantState(
        name: 'Viewer',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const ['viewer'],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.webrtc,
        viewportVisibility: ViewportVisibility.visible,
      );

      final admin = CallParticipantState(
        name: 'Admin',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const ['admin'],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.webrtc,
        viewportVisibility: ViewportVisibility.hidden,
      );

      final rtmp = CallParticipantState(
        name: 'Rtmp',
        userId: '3',
        sessionId: '3',
        custom: const {},
        roles: const ['viewer'],
        trackIdPrefix: 'prefix',
        participantSource: SfuParticipantSource.rtmp,
        viewportVisibility: ViewportVisibility.hidden,
      );

      final list = [viewer, admin, rtmp]
        ..sort(CallParticipantSortingPresets.livestreamOrAudioRoom);

      // rtmp first due to byParticipantSource
      expect(list[0], rtmp);
      expect(list[1], admin);
      expect(list[2], viewer);
    });

    test('livestreamOrAudioRoom: raised hand prioritized when any invisible',
        () {
      final invisibleRaised = CallParticipantState(
        name: 'Raised',
        userId: '1',
        sessionId: '1',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        reaction: CallReaction(type: 'raised-hand', user: CallUser.empty()),
        viewportVisibility: ViewportVisibility.unknown,
      );

      final visibleOther = CallParticipantState(
        name: 'Other',
        userId: '2',
        sessionId: '2',
        custom: const {},
        roles: const [],
        trackIdPrefix: 'prefix',
        viewportVisibility: ViewportVisibility.visible,
      );

      final list = [visibleOther, invisibleRaised]
        ..sort(CallParticipantSortingPresets.livestreamOrAudioRoom);

      expect(list.first, invisibleRaised);
    });
  });
}
