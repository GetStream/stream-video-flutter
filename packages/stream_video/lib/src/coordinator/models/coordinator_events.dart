import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_cid.dart';
import '../../models/call_created_data.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';
import '../../models/call_ringing_data.dart';
import '../../models/call_session_data.dart';

/// Represents the events coming in from the socket.
@immutable
abstract class CoordinatorEvent with EquatableMixin {
  const CoordinatorEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

/// Sent one time after successful connection.
class CoordinatorConnectedEvent extends CoordinatorEvent {
  const CoordinatorConnectedEvent({
    required this.connectionId,
    required this.userId,
  });

  final String connectionId;
  final String userId;

  @override
  List<Object?> get props => [connectionId, userId];
}

/// Fired when web socket is closed.
class CoordinatorDisconnectedEvent extends CoordinatorEvent {
  const CoordinatorDisconnectedEvent({
    this.connectionId,
    this.userId,
    this.closeCode,
    this.closeReason,
  });

  final String? connectionId;
  final String? userId;
  final int? closeCode;
  final String? closeReason;

  @override
  List<Object?> get props => [connectionId, userId, closeCode, closeReason];
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEvent {
  const CoordinatorHealthCheckEvent({
    required this.clientId,
  });

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

abstract class CoordinatorCallEvent extends CoordinatorEvent {
  const CoordinatorCallEvent();

  StreamCallCid get callCid;

  @override
  List<Object?> get props => [callCid];
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallCreatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallCreatedEvent({
    required this.data,
    required this.createdAt,
  });

  final CallCreatedData data;
  final DateTime createdAt;

  @override
  StreamCallCid get callCid => data.callCid;

  CallMetadata get metadata => data.metadata;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        metadata,
      ];
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallRingingEvent extends CoordinatorCallEvent {
  const CoordinatorCallRingingEvent({
    required this.data,
    required this.sessionId,
    required this.createdAt,
  });

  final CallRingingData data;
  final String sessionId;
  final DateTime createdAt;

  bool get ringing => data.ringing;

  @override
  StreamCallCid get callCid => data.callCid;

  CallMetadata get metadata => data.metadata;

  @override
  List<Object?> get props => [
        ...super.props,
        ringing,
        sessionId,
        createdAt,
        metadata,
      ];
}

/// Sent when a call gets updated.
class CoordinatorCallUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUpdatedEvent({
    required this.callCid,
    required this.metadata,
    required this.capabilitiesByRole,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final CallMetadata metadata;
  final Map<String, List<String>> capabilitiesByRole;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        metadata,
        capabilitiesByRole,
        createdAt,
      ];
}

/// Sent when a calls gets ended.
class CoordinatorCallEndedEvent extends CoordinatorCallEvent {
  const CoordinatorCallEndedEvent({
    required this.callCid,
    required this.endedBy,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final CallUser? endedBy;
  final DateTime createdAt;

  String? get endedByUserId => endedBy?.id;

  @override
  List<Object?> get props => [
        ...super.props,
        endedBy,
        createdAt,
      ];
}

/// Sent when a user accepts the call.
class CoordinatorCallAcceptedEvent extends CoordinatorCallEvent {
  const CoordinatorCallAcceptedEvent({
    required this.callCid,
    required this.acceptedBy,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final CallUser acceptedBy;
  final DateTime createdAt;

  String get acceptedByUserId => acceptedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        acceptedBy,
        createdAt,
      ];
}

/// Sent when a user rejects the call.
class CoordinatorCallRejectedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRejectedEvent({
    required this.callCid,
    required this.rejectedBy,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final CallUser rejectedBy;
  final DateTime createdAt;

  String get rejectedByUserId => rejectedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        rejectedBy,
        createdAt,
      ];
}

class CoordinatorCallPermissionRequestEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionRequestEvent({
    required this.callCid,
    required this.createdAt,
    required this.permissions,
    required this.user,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final List<CallPermission> permissions;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        permissions,
        user,
      ];
}

class CoordinatorCallPermissionsUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionsUpdatedEvent({
    required this.callCid,
    required this.createdAt,
    required this.ownCapabilities,
    required this.user,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final Iterable<CallPermission> ownCapabilities;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        ownCapabilities,
        user,
      ];
}

class CoordinatorCallRecordingStartedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRecordingStartedEvent({
    required this.callCid,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallRecordingStoppedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRecordingStoppedEvent({
    required this.callCid,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallBroadcastingStartedEvent extends CoordinatorCallEvent {
  const CoordinatorCallBroadcastingStartedEvent({
    required this.callCid,
    required this.hlsPlaylistUrl,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final String hlsPlaylistUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        hlsPlaylistUrl,
        createdAt,
      ];
}

class CoordinatorCallBroadcastingStoppedEvent extends CoordinatorCallEvent {
  const CoordinatorCallBroadcastingStoppedEvent({
    required this.callCid,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallUserBlockedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUserBlockedEvent({
    required this.callCid,
    required this.createdAt,
    required this.user,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [...super.props, createdAt, user];
}

class CoordinatorCallUserUnblockedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUserUnblockedEvent({
    required this.callCid,
    required this.createdAt,
    required this.user,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [...super.props, createdAt, user];
}

class CoordinatorCallReactionEvent extends CoordinatorCallEvent {
  const CoordinatorCallReactionEvent({
    required this.callCid,
    required this.createdAt,
    required this.reactionType,
    required this.user,
    this.emojiCode,
    this.custom = const {},
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final String reactionType;
  final String? emojiCode;
  final CallUser user;
  final Map<String, Object>? custom;

  @override
  List<Object?> get props => [...super.props, createdAt, emojiCode, custom];
}

class CoordinatorCallCustomEvent extends CoordinatorCallEvent {
  const CoordinatorCallCustomEvent({
    required this.callCid,
    required this.senderUserId,
    required this.createdAt,
    required this.eventType,
    required this.users,
    required this.custom,
  });

  @override
  final StreamCallCid callCid;
  final String senderUserId;
  final DateTime createdAt;
  final String eventType;
  final Map<String, Object>? custom;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        senderUserId,
        createdAt,
        eventType,
        custom,
        users,
      ];
}

class CoordinatorCallSessionStartedEvent extends CoordinatorCallEvent {
  const CoordinatorCallSessionStartedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [...super.props, createdAt, sessionId, metadata];
}

class CoordinatorCallSessionEndedEvent extends CoordinatorCallEvent {
  const CoordinatorCallSessionEndedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [...super.props, createdAt, sessionId, metadata];
}

class CoordinatorCallSessionParticipantJoinedEvent
    extends CoordinatorCallEvent {
  const CoordinatorCallSessionParticipantJoinedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        sessionId,
        participant,
        user,
      ];
}

class CoordinatorCallSessionParticipantLeftEvent extends CoordinatorCallEvent {
  const CoordinatorCallSessionParticipantLeftEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  @override
  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        sessionId,
        participant,
        user,
      ];
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEvent {
  const CoordinatorUnknownEvent();
}

class CoordinatorUnsupportedEvent extends CoordinatorEvent {
  const CoordinatorUnsupportedEvent();
}
