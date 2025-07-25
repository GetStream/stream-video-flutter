import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../../logger/stream_log.dart';
import 'event_type.dart';

const _tag = 'SV:OpenApiEvent';

class OpenApiEvent with EquatableMixin {
  const OpenApiEvent({
    required this.type,
    this.connected,
    this.healthCheck,
    this.callCreated,
    this.callMissed,
    this.callRing,
    this.callNotification,
    this.callAccepted,
    this.callRejected,
    this.callUpdated,
    this.callEnded,
    this.callSessionStarted,
    this.callSessionEnded,
    this.callSessionParticipantJoined,
    this.callSessionParticipantLeft,
    this.callSessionParticipantCountUpdated,
    this.callPermissionRequest,
    this.callPermissionsUpdated,
    this.callUserBlocked,
    this.callUserUnblocked,
    this.callRecordingStarted,
    this.callRecordingStopped,
    this.callBroadcastingStarted,
    this.callBroadcastingStopped,
    this.callBroadcastingFailed,
    this.callLiveStarted,
    this.callMemberAdded,
    this.callMemberRemoved,
    this.callMemberUpdated,
    this.callMemberUpdatedPermission,
    this.callReaction,
    this.callUserMuted,
    this.callRecordingReady,
    this.callRecordingFailed,
    this.callTranscriptionStarted,
    this.callTranscriptionStopped,
    this.callTranscriptionFailed,
    this.callClosedCaptionsStarted,
    this.callClosedCaptionsStopped,
    this.callClosedCaptionsFailed,
    this.callClosedCaption,
    this.callFrameRecordingStarted,
    this.callFrameRecordingFailed,
    this.callFrameRecordingStopped,
    this.callFrameRecordingFrameReady,
    this.custom,
    this.unknown,
  });

  static OpenApiEvent? fromRawJson(String rawJson) {
    return OpenApiEvent.fromJson(json.decode(rawJson));
  }

  static OpenApiEvent? fromJson(Map<String, dynamic> jsonObj) {
    final rawType = jsonObj['type'];
    if (rawType == null) {
      return null;
    }
    final type = EventType.fromAlias(rawType);
    streamLog.i(_tag, () => '[fromJson] rawType; $rawType, type: $type');
    final result = OpenApiEvent(type: type);
    switch (type) {
      case EventType.connectionOk:
        final event = open.ConnectedEvent.fromJson(jsonObj);
        return result.copyWith(connected: event);
      case EventType.healthCheck:
        final event = open.HealthCheckEvent.fromJson(jsonObj);
        return result.copyWith(healthCheck: event);
      case EventType.callCreated:
        final event = open.CallCreatedEvent.fromJson(jsonObj);
        return result.copyWith(callCreated: event);
      case EventType.callAccepted:
        final event = open.CallAcceptedEvent.fromJson(jsonObj);
        return result.copyWith(callAccepted: event);
      case EventType.callRejected:
        final event = open.CallRejectedEvent.fromJson(jsonObj);
        return result.copyWith(callRejected: event);
      case EventType.callUpdated:
        final event = open.CallUpdatedEvent.fromJson(jsonObj);
        return result.copyWith(callUpdated: event);
      case EventType.callEnded:
        final event = open.CallEndedEvent.fromJson(jsonObj);
        return result.copyWith(callEnded: event);
      case EventType.callSessionStarted:
        final event = open.CallSessionStartedEvent.fromJson(jsonObj);
        return result.copyWith(callSessionStarted: event);
      case EventType.callSessionEnded:
        final event = open.CallSessionEndedEvent.fromJson(jsonObj);
        return result.copyWith(callSessionEnded: event);
      case EventType.callSessionParticipantJoined:
        final event = open.CallSessionParticipantJoinedEvent.fromJson(jsonObj);
        return result.copyWith(callSessionParticipantJoined: event);
      case EventType.callSessionParticipantLeft:
        final event = open.CallSessionParticipantLeftEvent.fromJson(jsonObj);
        return result.copyWith(callSessionParticipantLeft: event);
      case EventType.callSessionParticipantCountUpdated:
        final event =
            open.CallSessionParticipantCountsUpdatedEvent.fromJson(jsonObj);
        return result.copyWith(callSessionParticipantCountUpdated: event);
      case EventType.callPermissionRequest:
        final event = open.PermissionRequestEvent.fromJson(jsonObj);
        return result.copyWith(callPermissionRequest: event);
      case EventType.callPermissionsUpdated:
        final event = open.UpdatedCallPermissionsEvent.fromJson(jsonObj);
        return result.copyWith(callPermissionsUpdated: event);
      case EventType.callUserBlocked:
        final event = open.BlockedUserEvent.fromJson(jsonObj);
        return result.copyWith(callUserBlocked: event);
      case EventType.callUserUnblocked:
        final event = open.UnblockedUserEvent.fromJson(jsonObj);
        return result.copyWith(callUserUnblocked: event);
      case EventType.callRecordingStarted:
        final event = open.CallRecordingStartedEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingStarted: event);
      case EventType.callRecordingStopped:
        final event = open.CallRecordingStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingStopped: event);
      case EventType.callBroadcastingStarted:
        final event = open.CallHLSBroadcastingStartedEvent.fromJson(jsonObj);
        return result.copyWith(callBroadcastingStarted: event);
      case EventType.callBroadcastingStopped:
        final event = open.CallHLSBroadcastingStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callBroadcastingStopped: event);
      case EventType.callBroadcastingFailed:
        final event = open.CallHLSBroadcastingFailedEvent.fromJson(jsonObj);
        return result.copyWith(callBroadcastingFailed: event);
      case EventType.callLiveStarted:
        final event = open.CallLiveStartedEvent.fromJson(jsonObj);
        return result.copyWith(callLiveStarted: event);
      case EventType.callMemberAdded:
        final event = open.CallMemberAddedEvent.fromJson(jsonObj);
        return result.copyWith(callMemberAdded: event);
      case EventType.callMemberRemoved:
        final event = open.CallMemberRemovedEvent.fromJson(jsonObj);
        return result.copyWith(callMemberRemoved: event);
      case EventType.callMemberUpdated:
        final event = open.CallMemberUpdatedEvent.fromJson(jsonObj);
        return result.copyWith(callMemberUpdated: event);
      case EventType.callMemberUpdatedPermission:
        final event = open.CallMemberUpdatedPermissionEvent.fromJson(jsonObj);
        return result.copyWith(callMemberUpdatedPermission: event);
      case EventType.callReaction:
        final event = open.CallReactionEvent.fromJson(jsonObj);
        return result.copyWith(callReaction: event);
      case EventType.custom:
        final event = open.CustomVideoEvent.fromJson(jsonObj);
        return result.copyWith(custom: event);
      case EventType.callRing:
        final event = open.CallRingEvent.fromJson(jsonObj);
        return result.copyWith(callRing: event);
      case EventType.callNotification:
        final event = open.CallNotificationEvent.fromJson(jsonObj);
        return result.copyWith(callNotification: event);
      case EventType.callUserMuted:
        final event = open.CallUserMutedEvent.fromJson(jsonObj);
        return result.copyWith(callUserMuted: event);
      case EventType.callRecordingReady:
        final event = open.CallRecordingReadyEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingReady: event);
      case EventType.callRecordingFailed:
        final event = open.CallRecordingFailedEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingFailed: event);
      case EventType.callMissed:
        final event = open.CallMissedEvent.fromJson(jsonObj);
        return result.copyWith(callMissed: event);
      case EventType.callTranscriptionStarted:
        final event = open.CallTranscriptionStartedEvent.fromJson(jsonObj);
        return result.copyWith(callTranscriptionStarted: event);
      case EventType.callTranscriptionStopped:
        final event = open.CallTranscriptionStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callTranscriptionStopped: event);
      case EventType.callTranscriptionFailed:
        final event = open.CallTranscriptionFailedEvent.fromJson(jsonObj);
        return result.copyWith(callTranscriptionFailed: event);
      case EventType.callClosedCaptionStarted:
        final event = open.CallClosedCaptionsStartedEvent.fromJson(jsonObj);
        return result.copyWith(callClosedCaptionsStarted: event);
      case EventType.callClosedCaptionStopped:
        final event = open.CallClosedCaptionsStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callClosedCaptionsStopped: event);
      case EventType.callClosedCaptionFailed:
        final event = open.CallClosedCaptionsFailedEvent.fromJson(jsonObj);
        return result.copyWith(callClosedCaptionsFailed: event);
      case EventType.callClosedCaption:
        final event = open.ClosedCaptionEvent.fromJson(jsonObj);
        return result.copyWith(callClosedCaption: event);
      case EventType.callFrameRecordingStarted:
        final event = open.CallFrameRecordingStartedEvent.fromJson(jsonObj);
        return result.copyWith(callFrameRecordingStarted: event);
      case EventType.callFrameRecordingStopped:
        final event = open.CallFrameRecordingStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callFrameRecordingStopped: event);
      case EventType.callFrameRecordingFailed:
        final event = open.CallFrameRecordingFailedEvent.fromJson(jsonObj);
        return result.copyWith(callFrameRecordingFailed: event);
      case EventType.callFrameRecordingReady:
        final event = open.CallFrameRecordingFrameReadyEvent.fromJson(jsonObj);
        return result.copyWith(callFrameRecordingFrameReady: event);
      case EventType.unknown:
        streamLog.d(_tag, () => '[fromJson] unexpected event: $jsonObj');
        return result.copyWith(unknown: jsonObj);
    }
  }

  final EventType type;
  final open.ConnectedEvent? connected;
  final open.HealthCheckEvent? healthCheck;
  final open.CallCreatedEvent? callCreated;
  final open.CallMissedEvent? callMissed;
  final open.CallRingEvent? callRing;
  final open.CallNotificationEvent? callNotification;
  final open.CallAcceptedEvent? callAccepted;
  final open.CallRejectedEvent? callRejected;
  final open.CallUpdatedEvent? callUpdated;
  final open.CallEndedEvent? callEnded;
  final open.CallSessionStartedEvent? callSessionStarted;
  final open.CallSessionEndedEvent? callSessionEnded;
  final open.CallSessionParticipantJoinedEvent? callSessionParticipantJoined;
  final open.CallSessionParticipantLeftEvent? callSessionParticipantLeft;
  final open.CallSessionParticipantCountsUpdatedEvent?
      callSessionParticipantCountUpdated;
  final open.PermissionRequestEvent? callPermissionRequest;
  final open.UpdatedCallPermissionsEvent? callPermissionsUpdated;
  final open.BlockedUserEvent? callUserBlocked;
  final open.UnblockedUserEvent? callUserUnblocked;
  final open.CallRecordingStartedEvent? callRecordingStarted;
  final open.CallRecordingStoppedEvent? callRecordingStopped;
  final open.CallHLSBroadcastingStartedEvent? callBroadcastingStarted;
  final open.CallHLSBroadcastingStoppedEvent? callBroadcastingStopped;
  final open.CallHLSBroadcastingFailedEvent? callBroadcastingFailed;
  final open.CallLiveStartedEvent? callLiveStarted;
  final open.CallMemberAddedEvent? callMemberAdded;
  final open.CallMemberRemovedEvent? callMemberRemoved;
  final open.CallMemberUpdatedEvent? callMemberUpdated;
  final open.CallMemberUpdatedPermissionEvent? callMemberUpdatedPermission;
  final open.CallReactionEvent? callReaction;
  final open.CallUserMutedEvent? callUserMuted;
  final open.CallRecordingReadyEvent? callRecordingReady;
  final open.CallRecordingFailedEvent? callRecordingFailed;
  final open.CallTranscriptionStartedEvent? callTranscriptionStarted;
  final open.CallTranscriptionStoppedEvent? callTranscriptionStopped;
  final open.CallTranscriptionFailedEvent? callTranscriptionFailed;
  final open.CallClosedCaptionsStartedEvent? callClosedCaptionsStarted;
  final open.CallClosedCaptionsStoppedEvent? callClosedCaptionsStopped;
  final open.CallClosedCaptionsFailedEvent? callClosedCaptionsFailed;
  final open.ClosedCaptionEvent? callClosedCaption;
  final open.CustomVideoEvent? custom;
  final open.CallFrameRecordingStartedEvent? callFrameRecordingStarted;
  final open.CallFrameRecordingFailedEvent? callFrameRecordingFailed;
  final open.CallFrameRecordingStoppedEvent? callFrameRecordingStopped;
  final open.CallFrameRecordingFrameReadyEvent? callFrameRecordingFrameReady;
  final Object? unknown;

  OpenApiEvent copyWith({
    EventType? type,
    open.ConnectedEvent? connected,
    open.HealthCheckEvent? healthCheck,
    open.CallCreatedEvent? callCreated,
    open.CallMissedEvent? callMissed,
    open.CallRingEvent? callRing,
    open.CallNotificationEvent? callNotification,
    open.CallAcceptedEvent? callAccepted,
    open.CallRejectedEvent? callRejected,
    open.CallUpdatedEvent? callUpdated,
    open.CallEndedEvent? callEnded,
    open.CallSessionStartedEvent? callSessionStarted,
    open.CallSessionEndedEvent? callSessionEnded,
    open.CallSessionParticipantJoinedEvent? callSessionParticipantJoined,
    open.CallSessionParticipantLeftEvent? callSessionParticipantLeft,
    open.CallSessionParticipantCountsUpdatedEvent?
        callSessionParticipantCountUpdated,
    open.PermissionRequestEvent? callPermissionRequest,
    open.UpdatedCallPermissionsEvent? callPermissionsUpdated,
    open.BlockedUserEvent? callUserBlocked,
    open.UnblockedUserEvent? callUserUnblocked,
    open.CallRecordingStartedEvent? callRecordingStarted,
    open.CallRecordingStoppedEvent? callRecordingStopped,
    open.CallHLSBroadcastingStartedEvent? callBroadcastingStarted,
    open.CallHLSBroadcastingStoppedEvent? callBroadcastingStopped,
    open.CallHLSBroadcastingFailedEvent? callBroadcastingFailed,
    open.CallLiveStartedEvent? callLiveStarted,
    open.CallMemberAddedEvent? callMemberAdded,
    open.CallMemberRemovedEvent? callMemberRemoved,
    open.CallMemberUpdatedEvent? callMemberUpdated,
    open.CallMemberUpdatedPermissionEvent? callMemberUpdatedPermission,
    open.CallReactionEvent? callReaction,
    open.CallUserMutedEvent? callUserMuted,
    open.CallRecordingReadyEvent? callRecordingReady,
    open.CallRecordingFailedEvent? callRecordingFailed,
    open.CallTranscriptionStartedEvent? callTranscriptionStarted,
    open.CallTranscriptionStoppedEvent? callTranscriptionStopped,
    open.CallTranscriptionFailedEvent? callTranscriptionFailed,
    open.CallClosedCaptionsStartedEvent? callClosedCaptionsStarted,
    open.CallClosedCaptionsStoppedEvent? callClosedCaptionsStopped,
    open.CallClosedCaptionsFailedEvent? callClosedCaptionsFailed,
    open.ClosedCaptionEvent? callClosedCaption,
    open.CustomVideoEvent? custom,
    open.CallFrameRecordingStartedEvent? callFrameRecordingStarted,
    open.CallFrameRecordingFailedEvent? callFrameRecordingFailed,
    open.CallFrameRecordingStoppedEvent? callFrameRecordingStopped,
    open.CallFrameRecordingFrameReadyEvent? callFrameRecordingFrameReady,
    Object? unknown,
  }) {
    return OpenApiEvent(
      type: type ?? this.type,
      connected: connected ?? this.connected,
      healthCheck: healthCheck ?? this.healthCheck,
      callCreated: callCreated ?? this.callCreated,
      callMissed: callMissed ?? this.callMissed,
      callRing: callRing ?? this.callRing,
      callNotification: callNotification ?? this.callNotification,
      callAccepted: callAccepted ?? this.callAccepted,
      callRejected: callRejected ?? this.callRejected,
      callUpdated: callUpdated ?? this.callUpdated,
      callEnded: callEnded ?? this.callEnded,
      callSessionStarted: callSessionStarted ?? this.callSessionStarted,
      callSessionEnded: callSessionEnded ?? this.callSessionEnded,
      callSessionParticipantJoined:
          callSessionParticipantJoined ?? this.callSessionParticipantJoined,
      callSessionParticipantLeft:
          callSessionParticipantLeft ?? this.callSessionParticipantLeft,
      callSessionParticipantCountUpdated: callSessionParticipantCountUpdated ??
          this.callSessionParticipantCountUpdated,
      callPermissionRequest:
          callPermissionRequest ?? this.callPermissionRequest,
      callPermissionsUpdated:
          callPermissionsUpdated ?? this.callPermissionsUpdated,
      callUserBlocked: callUserBlocked ?? this.callUserBlocked,
      callUserUnblocked: callUserUnblocked ?? this.callUserUnblocked,
      callRecordingStarted: callRecordingStarted ?? this.callRecordingStarted,
      callRecordingStopped: callRecordingStopped ?? this.callRecordingStopped,
      callBroadcastingStarted:
          callBroadcastingStarted ?? this.callBroadcastingStarted,
      callBroadcastingStopped:
          callBroadcastingStopped ?? this.callBroadcastingStopped,
      callBroadcastingFailed:
          callBroadcastingFailed ?? this.callBroadcastingFailed,
      callLiveStarted: callLiveStarted ?? this.callLiveStarted,
      callMemberAdded: callMemberAdded ?? this.callMemberAdded,
      callMemberRemoved: callMemberRemoved ?? this.callMemberRemoved,
      callMemberUpdated: callMemberUpdated ?? this.callMemberUpdated,
      callMemberUpdatedPermission:
          callMemberUpdatedPermission ?? this.callMemberUpdatedPermission,
      callReaction: callReaction ?? this.callReaction,
      callUserMuted: callUserMuted ?? this.callUserMuted,
      callRecordingReady: callRecordingReady ?? this.callRecordingReady,
      callRecordingFailed: callRecordingFailed ?? this.callRecordingFailed,
      callTranscriptionStarted:
          callTranscriptionStarted ?? this.callTranscriptionStarted,
      callTranscriptionStopped:
          callTranscriptionStopped ?? this.callTranscriptionStopped,
      callTranscriptionFailed:
          callTranscriptionFailed ?? this.callTranscriptionFailed,
      callClosedCaptionsStarted:
          callClosedCaptionsStarted ?? this.callClosedCaptionsStarted,
      callClosedCaptionsStopped:
          callClosedCaptionsStopped ?? this.callClosedCaptionsStopped,
      callClosedCaptionsFailed:
          callClosedCaptionsFailed ?? this.callClosedCaptionsFailed,
      callClosedCaption: callClosedCaption ?? this.callClosedCaption,
      callFrameRecordingStarted:
          callFrameRecordingStarted ?? this.callFrameRecordingStarted,
      callFrameRecordingFailed:
          callFrameRecordingFailed ?? this.callFrameRecordingFailed,
      callFrameRecordingStopped:
          callFrameRecordingStopped ?? this.callFrameRecordingStopped,
      callFrameRecordingFrameReady:
          callFrameRecordingFrameReady ?? this.callFrameRecordingFrameReady,
      custom: custom ?? this.custom,
      unknown: unknown ?? this.unknown,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        type,
        connected,
        healthCheck,
        callCreated,
        callMissed,
        callRing,
        callNotification,
        callAccepted,
        callRejected,
        callUpdated,
        callEnded,
        callSessionStarted,
        callSessionEnded,
        callSessionParticipantJoined,
        callSessionParticipantLeft,
        callSessionParticipantCountUpdated,
        callPermissionRequest,
        callPermissionsUpdated,
        callUserBlocked,
        callUserUnblocked,
        callRecordingStarted,
        callRecordingStopped,
        callBroadcastingStarted,
        callBroadcastingStopped,
        callLiveStarted,
        callMemberAdded,
        callMemberRemoved,
        callMemberUpdated,
        callMemberUpdatedPermission,
        callReaction,
        callUserMuted,
        callRecordingReady,
        callRecordingFailed,
        callTranscriptionStarted,
        callTranscriptionStopped,
        callTranscriptionFailed,
        callClosedCaptionsStarted,
        callClosedCaptionsStopped,
        callClosedCaptionsFailed,
        callClosedCaption,
        callFrameRecordingStarted,
        callFrameRecordingFailed,
        callFrameRecordingStopped,
        callFrameRecordingFrameReady,
        custom,
        unknown,
      ];
}
