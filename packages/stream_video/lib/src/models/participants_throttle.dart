/// How long `Call.participantsStream` holds participant updates back, given
/// how many participants the call currently has.
///
/// See `CallPreferences.participantsThrottleIntervalResolver`.
typedef ParticipantsThrottleIntervalResolver =
    Duration Function(int participantCount);

/// The interval `Call.participantsStream` uses unless a call overrides it:
/// roughly a frame below 16 participants, widening to a second at 100 or more.
///
/// The tiers were taken from stream-video-swift's
/// `CollectionDelayedUpdateObserver` (v1.52.0, September 2026). Nothing in this
/// repository keeps them in step, so treat that as where they came from rather
/// than as a guarantee they still match.
Duration defaultParticipantsThrottleInterval(int participantCount) {
  if (participantCount < 16) return const Duration(milliseconds: 16);
  if (participantCount < 50) return const Duration(milliseconds: 250);
  if (participantCount < 100) return const Duration(milliseconds: 500);
  return const Duration(seconds: 1);
}
