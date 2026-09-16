/// How long `Call.participantsStream` holds participant updates back, given
/// how many participants the call currently has.
///
/// See `CallPreferences.participantsThrottleInterval`.
typedef ParticipantsThrottleInterval = Duration Function(int participantCount);

/// The interval `Call.participantsStream` uses unless a call overrides it.
///
/// The tiers match the ones the iOS and Android SDKs use, so a livestream
/// updates at a comparable rate on every platform.
Duration defaultParticipantsThrottleInterval(int participantCount) {
  if (participantCount < 16) return const Duration(milliseconds: 16);
  if (participantCount < 50) return const Duration(milliseconds: 250);
  if (participantCount < 100) return const Duration(milliseconds: 500);
  return const Duration(seconds: 1);
}
