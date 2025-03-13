class CallParticipantPin {
  const CallParticipantPin({
    required this.isLocalPin,
    required this.pinnedAt,
  });

  final bool isLocalPin;
  final DateTime pinnedAt;
}
