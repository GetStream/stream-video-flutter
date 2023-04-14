import '../models/call_participant_state.dart';
import 'call_participant_state_sorting.dart';

mixin CallParticipantSortingPresets {
  /// The default sorting preset.
  static final regular = combineComparators<CallParticipantState>([
    pinned,
    screenSharing,
    ifInvisibleBy(dominantSpeaker),
    ifInvisibleBy(speaking),
    ifInvisibleBy(reactionType('raised-hand')),
    ifInvisibleBy(publishingVideo),
    ifInvisibleBy(publishingAudio),
  ]);

  /// The sorting preset for speaker layout.
  static final speaker = combineComparators<CallParticipantState>([
    pinned,
    screenSharing,
    dominantSpeaker,
    ifInvisibleBy(speaking),
    ifInvisibleBy(reactionType('raised-hand')),
    ifInvisibleBy(publishingVideo),
    ifInvisibleBy(publishingAudio),
  ]);

  /// The sorting preset for livestreams and audio rooms.
  static final livestreamOrAudioRoom =
      combineComparators<CallParticipantState>([
    ifInvisibleBy(dominantSpeaker),
    ifInvisibleBy(speaking),
    ifInvisibleBy(reactionType('raised-hand')),
    ifInvisibleBy(publishingVideo),
    ifInvisibleBy(publishingAudio),
    role(['admin', 'host', 'speaker']),
  ]);
}
