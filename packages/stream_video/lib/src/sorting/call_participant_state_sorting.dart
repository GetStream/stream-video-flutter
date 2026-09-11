import '../models/call_participant_state.dart';
import '../sfu/data/models/sfu_participant_source.dart';
// Referenced from the documentation below: these criteria are meant to be
// applied by it.
import 'sort_participants.dart';

/// How much of a claim a single participant has to a place on screen, higher
/// first.
///
/// Priorities are measured against `0`, the priority [ifInvisibleBy] gives
/// every participant whose tile is already on screen: a criterion that should
/// bring an off-screen participant into view scores them above zero, one that
/// should leave them out of it scores them below.
///
/// A priority depends on one participant only, so [byPriority] can never build
/// an intransitive comparator — see [byPriority] for why that matters.
typedef ParticipantPriority = double Function(CallParticipantState participant);

/// Sorts participants by a [priority] each of them carries on its own,
/// highest first.
///
/// The comparator is a total order, which a comparator that inspects both
/// participants is not obliged to be. That is what lets a stable sort leave
/// participants of equal priority in the order they came in: an intransitive
/// comparator (`a == b`, `b == c`, but `a < c`) makes the result depend on the
/// order the sort happens to compare in, so participants nothing was said
/// about still move.
///
/// Sort with [sortParticipants], or at least with a stable sort —
/// `package:collection`'s `mergeSort` — so that participants of equal priority
/// keep their previous positions.
Comparator<CallParticipantState> byPriority(ParticipantPriority priority) {
  return (a, b) => priority(b).compareTo(priority(a));
}

/// Brings the dominant speaker into view.
double dominantSpeakerPriority(CallParticipantState participant) {
  return participant.isDominantSpeaker ? 1 : 0;
}

/// Brings a participant who is speaking into view.
double speakingPriority(CallParticipantState participant) {
  return participant.isSpeaking ? 1 : 0;
}

/// Brings a participant who is sharing their screen into view.
double screenSharingPriority(CallParticipantState participant) {
  return participant.isScreenShareEnabled ? 1 : 0;
}

/// Leaves a participant who is not publishing video out of view.
double publishingVideoPriority(CallParticipantState participant) {
  return participant.isVideoEnabled ? 0 : -1;
}

/// Leaves a participant who is not publishing audio out of view.
double publishingAudioPriority(CallParticipantState participant) {
  return participant.isAudioEnabled ? 0 : -1;
}

/// Brings a participant who reacted with [type] into view.
ParticipantPriority byReactionTypePriority(String type) {
  return (participant) => participant.reaction?.type == type ? 1 : 0;
}

/// Brings participants from one of [sources] into view, in the order the
/// sources are given (e.g. WebRTC, RTMP, WHIP...).
ParticipantPriority byParticipantSourcePriority(
  List<SfuParticipantSource> sources,
) {
  return (participant) {
    final source = participant.participantSource;
    if (source == null) return 0;

    final index = sources.indexOf(source);
    return index == -1 ? 0 : (sources.length - index).toDouble();
  };
}

/// Brings participants coming from a video ingress into view.
ParticipantPriority byVideoIngressSourcePriority() {
  return byParticipantSourcePriority([
    SfuParticipantSource.rtmp,
    SfuParticipantSource.srt,
    SfuParticipantSource.whip,
    SfuParticipantSource.rtsp,
  ]);
}

/// Brings a participant into view by how many of [roles] they hold.
ParticipantPriority byRolePriority(List<String> roles) {
  return (participant) {
    return participant.roles.where(roles.contains).length.toDouble();
  };
}

/// A comparator which sorts participants by the fact that they are the
/// dominant speaker or not.
int dominantSpeaker(CallParticipantState a, CallParticipantState b) {
  return dominantSpeakerPriority(b).compareTo(dominantSpeakerPriority(a));
}

/// A comparator which sorts participants by the fact that they are
/// speaking or not.
int speaking(CallParticipantState a, CallParticipantState b) {
  return speakingPriority(b).compareTo(speakingPriority(a));
}

/// A comparator which sorts participants by screen sharing status.
int screenSharing(CallParticipantState a, CallParticipantState b) {
  return screenSharingPriority(b).compareTo(screenSharingPriority(a));
}

/// A comparator which sorts participants by video status.
int publishingVideo(CallParticipantState a, CallParticipantState b) {
  return publishingVideoPriority(b).compareTo(publishingVideoPriority(a));
}

/// A comparator which sorts participants by audio status.
int publishingAudio(CallParticipantState a, CallParticipantState b) {
  return publishingAudioPriority(b).compareTo(publishingAudioPriority(a));
}

/// A comparator which prioritizes participants who are pinned.
int pinned(CallParticipantState a, CallParticipantState b) {
  if (a.pin != null && b.pin != null) {
    if (!a.pin!.isLocalPin && b.pin!.isLocalPin) return -1;
    if (a.pin!.isLocalPin && !b.pin!.isLocalPin) return 1;
    if (a.pin!.pinnedAt.isAfter(b.pin!.pinnedAt)) return -1;
    if (a.pin!.pinnedAt.isBefore(b.pin!.pinnedAt)) return 1;
  }

  if (a.pin != null && b.pin == null) return -1;
  if (a.pin == null && b.pin != null) return 1;

  return 0;
}

/// A comparator factory which creates a comparator which prioritizes
/// participants who are from a specific sources (e.g., WebRTC, RTMP, WHIP...).
Comparator<CallParticipantState> byParticipantSource(
  List<SfuParticipantSource> sources,
) {
  return byPriority(byParticipantSourcePriority(sources));
}

/// A comparator which prioritizes participants coming from a video ingress.
Comparator<CallParticipantState> byVideoIngressSource() {
  return byPriority(byVideoIngressSourcePriority());
}

/// A comparator creator which will set up a comparator which prioritizes
/// participants who have a specific reaction.
Comparator<CallParticipantState> byReactionType(String type) {
  return byPriority(byReactionTypePriority(type));
}

/// A comparator creator which will set up a comparator which prioritizes
/// participants who have a specific role.
Comparator<CallParticipantState> byRole(List<String> roles) {
  return byPriority(byRolePriority(roles));
}

/// A comparator which sorts participants by name.
int byName(CallParticipantState a, CallParticipantState b) {
  return a.name.compareTo(b.name);
}

/// Creates a new combined [Comparator] which sorts items
/// by the given [comparators].
///
/// The result is a total order as long as every comparator in [comparators] is
/// one, which the comparators built by [byPriority] and [ifInvisibleBy] are.
Comparator<T> combineComparators<T>(List<Comparator<T>> comparators) {
  return (T a, T b) {
    for (final comparator in comparators) {
      final result = comparator(a, b);
      if (result != 0) return result;
    }
    return 0;
  };
}

extension ConditionalComparator<T> on Comparator<T> {
  /// Applies this comparator only to the pairs [predicate] accepts.
  ///
  /// A predicate that reads both items usually makes the result intransitive,
  /// and a sort over an intransitive comparator moves items the comparator
  /// said nothing about. Prefer [byPriority], whose priorities are per item,
  /// whenever the condition can be expressed as one.
  Comparator<T> conditional(bool Function(T a, T b) predicate) {
    return (T a, T b) {
      if (!predicate(a, b)) return 0;
      return this(a, b);
    };
  }
}

/// A comparator which gives [priority] only to participants whose tile is not
/// visible in the viewport.
///
/// A participant on screen always has priority `0`, so nothing about them
/// speaking, reacting or publishing can move their tile. An off-screen
/// participant is still scored, which is what earns a speaker a place on the
/// screen and leaves a participant with nothing to show off it.
///
/// Sort with [sortParticipants] to have that place cost one tile rather than
/// shifting the screen.
Comparator<CallParticipantState> ifInvisibleBy(ParticipantPriority priority) {
  return byPriority(
    (participant) =>
        participant.viewportVisibility.isVisible ? 0 : priority(participant),
  );
}
