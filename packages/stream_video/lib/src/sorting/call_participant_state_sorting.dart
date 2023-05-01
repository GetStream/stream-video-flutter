import '../models/call_participant_state.dart';
import '../models/viewport_visibility.dart';

/// A comparator which sorts participants by the fact that they are the
/// dominant speaker or not.
int dominantSpeaker(CallParticipantState a, CallParticipantState b) {
  if (a.isDominantSpeaker && !b.isDominantSpeaker) return -1;
  if (!a.isDominantSpeaker && b.isDominantSpeaker) return 1;
  return 0;
}

/// A comparator which sorts participants by the fact that they are
/// speaking or not.
int speaking(CallParticipantState a, CallParticipantState b) {
  if (a.isSpeaking && !b.isSpeaking) return -1;
  if (!a.isSpeaking && b.isSpeaking) return 1;
  return 0;
}

/// A comparator which sorts participants by screen sharing status.
int screenSharing(CallParticipantState a, CallParticipantState b) {
  if (a.isScreenShareEnabled && !b.isScreenShareEnabled) return -1;
  if (!a.isScreenShareEnabled && b.isScreenShareEnabled) return 1;
  return 0;
}

/// A comparator which sorts participants by video status.
int publishingVideo(CallParticipantState a, CallParticipantState b) {
  if (a.isVideoEnabled && !b.isVideoEnabled) return -1;
  if (!a.isVideoEnabled && b.isVideoEnabled) return 1;
  return 0;
}

/// A comparator which sorts participants by audio status.
int publishingAudio(CallParticipantState a, CallParticipantState b) {
  if (a.isAudioEnabled && !b.isAudioEnabled) return -1;
  if (!a.isAudioEnabled && b.isAudioEnabled) return 1;
  return 0;
}

/// A comparator which prioritizes participants who are pinned.
int pinned(CallParticipantState a, CallParticipantState b) {
  if (a.isPinned && !b.isPinned) return -1;
  if (!a.isPinned && b.isPinned) return 1;
  return 0;
}

/// A comparator creator which will set up a comparator which prioritizes
/// participants who have a specific reaction.
Comparator<CallParticipantState> reactionType(String type) {
  return (CallParticipantState a, CallParticipantState b) {
    if (a.reaction?.type == type && b.reaction?.type != type) return -1;
    if (a.reaction?.type != type && b.reaction?.type == type) return 1;
    return 0;
  };
}

/// A comparator creator which will set up a comparator which prioritizes
/// participants who have a specific role.
Comparator<CallParticipantState> role(List<String> roles) {
  return (CallParticipantState a, CallParticipantState b) {
    if (roles.contains(a.role) && !roles.contains(b.role)) return -1;
    if (!roles.contains(a.role) && roles.contains(b.role)) return 1;
    return 0;
  };
}

/// Creates a new combined [Comparator] which sorts items
/// by the given [comparators].
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
  Comparator<T> conditional(bool Function(T a, T b) predicate) {
    return (T a, T b) {
      if (!predicate(a, b)) return 0;
      return this(a, b);
    };
  }
}

/// A comparator decorator which applies the decorated comparator only if the
/// participant viewport visibility is hidden or net yet determined.
Comparator<CallParticipantState> ifInvisibleBy(
  Comparator<CallParticipantState> comparator,
) {
  return comparator.conditional(
    (a, b) {
      return a.viewportVisibility != ViewportVisibility.visible ||
          b.viewportVisibility != ViewportVisibility.visible;
    },
  );
}
