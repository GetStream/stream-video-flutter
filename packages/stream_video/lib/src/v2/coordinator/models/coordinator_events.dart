import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'coordinator_models.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
@immutable
abstract class CoordinatorEventV2 with EquatableMixin {
  const CoordinatorEventV2();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEventV2 {
  const CoordinatorHealthCheckEvent(
      {required this.clientId, required this.userId});

  final String clientId;
  final String userId;

  @override
  List<Object?> get props => [clientId, userId];
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

  @override
  List<Object?> get props => [callCid, ringing, info, details, users];
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

  @override
  List<Object?> get props => [callCid, info, details, users];
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

  @override
  List<Object?> get props => [callCid, info, details, users];
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

  @override
  List<Object?> get props => [callCid, sentByUserId, info, details, users];
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

  @override
  List<Object?> get props => [callCid, sentByUserId, info, details, users];
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

  @override
  List<Object?> get props => [callCid, sentByUserId, info, details, users];
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

  @override
  List<Object?> get props => [callCid, info, details, users];
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

  @override
  List<Object?> get props => [callCid, info, details, users];
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

  @override
  List<Object?> get props => [
        callCid,
        type,
        senderUserId,
        info,
        details,
        users,
        customJson,
      ];
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEventV2 {
  const CoordinatorUnknownEvent();
}
