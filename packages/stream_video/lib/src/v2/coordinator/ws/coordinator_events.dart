import 'package:stream_video/src/v2/coordinator/models/coordinator_models.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
class CoordinatorEvent {
  const CoordinatorEvent();
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEvent {
  const CoordinatorHealthCheckEvent(
      {required this.clientId, required this.userId});

  final String clientId;
  final String userId;
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallCreatedEvent extends CoordinatorEvent {
  const CoordinatorCallCreatedEvent({
    required this.callCid,
    required this.ringing,
    required this.info,
    required this.details,
  });

  final String callCid;
  final bool ringing;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a call gets updated.
class CoordinatorCallUpdatedEvent extends CoordinatorEvent {
  const CoordinatorCallUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a calls gets ended.
class CoordinatorCallEndedEvent extends CoordinatorEvent {
  const CoordinatorCallEndedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user accepts the call.
class CoordinatorCallAcceptedEvent extends CoordinatorEvent {
  const CoordinatorCallAcceptedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user rejects the call.
class CoordinatorCallRejectedEvent extends CoordinatorEvent {
  const CoordinatorCallRejectedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user cancels the call.
class CoordinatorCallCancelledEvent extends CoordinatorEvent {
  const CoordinatorCallCancelledEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when call members are updated.
class CoordinatorCallMembersUpdatedEvent extends CoordinatorEvent {
  const CoordinatorCallMembersUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when call members are deleted.
class CoordinatorCallMembersDeletedEvent extends CoordinatorEvent {
  const CoordinatorCallMembersDeletedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEvent {
  const CoordinatorUnknownEvent();
}
