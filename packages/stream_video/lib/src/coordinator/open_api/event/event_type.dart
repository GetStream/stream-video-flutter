enum EventType {
  healthCheck('health.check'),
  callCreated('call.created'),
  callAccepted('call.accepted'),
  callRejected('call.rejected'),
  callCancelled('call.cancelled'),
  callUpdated('call.updated'),
  callEnded('call.ended'),
  callPermissionRequest('call.permission_request'),
  callPermissionsUpdated('call.permissions_updated'),
  callRecordingStarted('call.recording_started'),
  callRecordingStopped('call.recording_stopped'),
  custom('custom'),
  unknown('unknown');

  const EventType(this.alias);

  factory EventType.fromAlias(dynamic alias) {
    return EventType.values.firstWhere(
      (it) => it.alias == alias,
      orElse: () => EventType.unknown,
    );
  }

  final String alias;
}
