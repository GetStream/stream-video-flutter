import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_metadata.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
@immutable
abstract class CoordinatorEvent with EquatableMixin {
  const CoordinatorEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEvent {
  const CoordinatorHealthCheckEvent({
    required this.clientId,
    required this.userId,
  });

  final String clientId;
  final String userId;

  @override
  List<Object?> get props => [clientId, userId];
}

abstract class CoordinatorCallEvent extends CoordinatorEvent {
  const CoordinatorCallEvent({required this.callCid});

  final String callCid;

  @override
  List<Object?> get props => [callCid];
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallCreatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallCreatedEvent({
    required super.callCid,
    required this.ringing,
    required this.createdAt,
    required this.info,
    required this.details,
    required this.users,
  });

  final bool ringing;
  final DateTime createdAt;
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        ringing,
        createdAt,
        info,
        details,
        users,
      ];
}

/// Sent when a call gets updated.
class CoordinatorCallUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUpdatedEvent({
    required super.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [...super.props, info, details, users];
}

/// Sent when a calls gets ended.
class CoordinatorCallEndedEvent extends CoordinatorCallEvent {
  const CoordinatorCallEndedEvent({
    required super.callCid,
    required this.sentByUserId,
    required this.createdAt,
    required this.info,
    required this.details,
    required this.users,
  });

  final String sentByUserId;
  final DateTime createdAt;
  // TODO delete props below
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        sentByUserId,
        createdAt,
        info,
        details,
        users,
      ];
}

/// Sent when a user accepts the call.
class CoordinatorCallAcceptedEvent extends CoordinatorCallEvent {
  const CoordinatorCallAcceptedEvent({
    required super.callCid,
    required this.sentByUserId,
    required this.createdAt,
    required this.info,
    required this.details,
    required this.users,
  });

  final String sentByUserId;
  final DateTime createdAt;
  // TODO delete props below
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        sentByUserId,
        info,
        details,
        users,
      ];
}

/// Sent when a user rejects the call.
class CoordinatorCallRejectedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRejectedEvent({
    required super.callCid,
    required this.sentByUserId,
    required this.info,
    required this.createdAt,
    required this.details,
    required this.users,
  });

  final String sentByUserId;
  final DateTime createdAt;
  // TODO remove props below
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        sentByUserId,
        createdAt,
        info,
        details,
        users,
      ];
}

/// Sent when a user cancels the call.
class CoordinatorCallCancelledEvent extends CoordinatorCallEvent {
  const CoordinatorCallCancelledEvent({
    required super.callCid,
    required this.sentByUserId,
    required this.createdAt,
    required this.info,
    required this.details,
    required this.users,
  });

  final String sentByUserId;
  final DateTime createdAt;
  // TODO remove props below
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        sentByUserId,
        createdAt,
        info,
        details,
        users,
      ];
}

/// Sent when call members are updated.
class CoordinatorCallMembersUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallMembersUpdatedEvent({
    required super.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [...super.props, info, details, users];
}

/// Sent when call members are deleted.
class CoordinatorCallMembersDeletedEvent extends CoordinatorCallEvent {
  const CoordinatorCallMembersDeletedEvent({
    required super.callCid,
    required this.info,
    required this.details,
    required this.users,
  });

  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [...super.props, info, details, users];
}

class CoordinatorCallPermissionRequestEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionRequestEvent({
    required super.callCid,
    required this.createdAt,
    required this.permissions,
    required this.type,
    required this.user,
  });

  final DateTime createdAt;
  final List<String> permissions;
  final String type;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        permissions,
        type,
        user,
      ];
}

class CoordinatorCallPermissionsUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionsUpdatedEvent({
    required super.callCid,
    required this.createdAt,
    required this.ownCapabilities,
    required this.type,
    required this.user,
  });

  final DateTime createdAt;
  final List<String> ownCapabilities;
  final String type;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        ownCapabilities,
        type,
        user,
      ];
}

class CoordinatorCallCustomEvent extends CoordinatorCallEvent {
  const CoordinatorCallCustomEvent({
    required super.callCid,
    required this.senderUserId,
    required this.createdAt,
    required this.type,
    required this.info,
    required this.details,
    required this.users,
    required this.customJson,
  });

  final String senderUserId;
  final DateTime createdAt;
  final String type;
  final Map<String, Object>? customJson;
  // TODO remove below
  final CallInfo info;
  final CallDetails details;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        senderUserId,
        createdAt,
        type,
        info,
        details,
        users,
        customJson,
      ];
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEvent {
  const CoordinatorUnknownEvent();
}
