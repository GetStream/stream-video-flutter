import 'package:stream_video/src/v2/coordinator/models/coordinator_models.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
abstract class CoordinatorEventV2 {
  const CoordinatorEventV2();
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEventV2 {
  const CoordinatorHealthCheckEvent(
      {required this.clientId, required this.userId});

  final String clientId;
  final String userId;
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallCreatedEvent extends CoordinatorEventV2 {
  const CoordinatorCallCreatedEvent({
    required this.callCid,
    required this.ringing,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final bool ringing;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when a call gets updated.
class CoordinatorCallUpdatedEvent extends CoordinatorEventV2 {
  const CoordinatorCallUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when a calls gets ended.
class CoordinatorCallEndedEvent extends CoordinatorEventV2 {
  const CoordinatorCallEndedEvent({
    required this.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when a user accepts the call.
class CoordinatorCallAcceptedEvent extends CoordinatorEventV2 {
  const CoordinatorCallAcceptedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when a user rejects the call.
class CoordinatorCallRejectedEvent extends CoordinatorEventV2 {
  const CoordinatorCallRejectedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when a user cancels the call.
class CoordinatorCallCancelledEvent extends CoordinatorEventV2 {
  const CoordinatorCallCancelledEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when call members are updated.
class CoordinatorCallMembersUpdatedEvent extends CoordinatorEventV2 {
  const CoordinatorCallMembersUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

/// Sent when call members are deleted.
class CoordinatorCallMembersDeletedEvent extends CoordinatorEventV2 {
  const CoordinatorCallMembersDeletedEvent({
    required this.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
}

class CoordinatorCallCustomEvent extends CoordinatorEventV2 {
  const CoordinatorCallCustomEvent({
    required this.callCid,
    required this.type,
    required this.senderUserId,
    required this.info,
    required this.details,
    required this.users,
    required this.customJson,
  });

  final String callCid;
  final String type;
  final String senderUserId;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;
  final String? customJson;
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEventV2 {
  const CoordinatorUnknownEvent();
}
