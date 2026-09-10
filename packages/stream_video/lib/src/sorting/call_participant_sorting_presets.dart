import '../models/call_participant_state.dart';
import 'call_participant_state_sorting.dart';
// Referenced from the documentation below: these presets are meant to be
// applied by it.
import 'sort_participants.dart';

/// The comparators the SDK sorts call participants with.
///
/// Apply them with [sortParticipants], which is what makes an off-screen
/// participant who starts speaking cost the screen a single tile: every preset
/// gives each participant on screen the same priority, so the sort itself has
/// nothing to say about where their tile goes.
mixin CallParticipantSortingPresets {
  /// The default sorting preset.
  static final regular = combineComparators<CallParticipantState>([
    pinned,
    screenSharing,
    ifInvisibleBy(dominantSpeakerPriority),
    ifInvisibleBy(speakingPriority),
    ifInvisibleBy(byReactionTypePriority('raised-hand')),
    ifInvisibleBy(publishingVideoPriority),
    ifInvisibleBy(publishingAudioPriority),
  ]);

  /// The sorting preset for speaker layout.
  static final speaker = combineComparators<CallParticipantState>([
    pinned,
    screenSharing,
    dominantSpeaker,
    ifInvisibleBy(speakingPriority),
    ifInvisibleBy(byReactionTypePriority('raised-hand')),
    ifInvisibleBy(byVideoIngressSourcePriority()),
    ifInvisibleBy(publishingVideoPriority),
    ifInvisibleBy(publishingAudioPriority),
  ]);

  /// The sorting preset for livestreams and audio rooms.
  static final livestreamOrAudioRoom = combineComparators<CallParticipantState>(
    [
      ifInvisibleBy(dominantSpeakerPriority),
      ifInvisibleBy(speakingPriority),
      ifInvisibleBy(byReactionTypePriority('raised-hand')),
      ifInvisibleBy(byVideoIngressSourcePriority()),
      ifInvisibleBy(publishingVideoPriority),
      ifInvisibleBy(publishingAudioPriority),
      byRole(['admin', 'host', 'speaker']),
    ],
  );

  /// The sorting preset for PiP layout.
  /// For picture in picture we don't rely on visibility as it's a separate view not related to the main one.
  static final pictureInPicture = combineComparators<CallParticipantState>([
    pinned,
    screenSharing,
    dominantSpeaker,
    speaking,
    byVideoIngressSource(),
    publishingVideo,
    publishingAudio,
  ]);
}
