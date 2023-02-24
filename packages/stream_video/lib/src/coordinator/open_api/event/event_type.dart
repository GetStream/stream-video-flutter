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
  custom('custom'),
  unknown('unknown');

  const EventType(this.alias);

  factory EventType.fromAlias(dynamic alias) {
    if (alias == EventType.healthCheck.alias) {
      return EventType.healthCheck;
    } else if (alias == EventType.callCreated.alias) {
      return EventType.callCreated;
    } else if (alias == EventType.callAccepted.alias) {
      return EventType.callAccepted;
    } else if (alias == EventType.callRejected.alias) {
      return EventType.callRejected;
    } else if (alias == EventType.callCancelled.alias) {
      return EventType.callCancelled;
    } else if (alias == EventType.callUpdated.alias) {
      return EventType.callUpdated;
    } else if (alias == EventType.callEnded.alias) {
      return EventType.callEnded;
    } else if (alias == EventType.callPermissionRequest.alias) {
      return EventType.callPermissionRequest;
    } else if (alias == EventType.callPermissionsUpdated.alias) {
      return EventType.callPermissionsUpdated;
    } else if (alias == EventType.custom.alias) {
      return EventType.custom;
    } else {
      return EventType.unknown;
    }
  }

  final String alias;
}
