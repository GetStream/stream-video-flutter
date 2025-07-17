part of openapi.api;

@immutable
sealed class VideoEvent {
  const VideoEvent();

  // String get callCid;
  String get type;

  static VideoEvent fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case "app.updated":
        return TypeAppUpdatedEvent.fromJson(json);
      case "call.accepted":
        return TypeCallAcceptedEvent.fromJson(json);
      case "call.blocked_user":
        return TypeBlockedUserEvent.fromJson(json);
      case "call.closed_caption":
        return TypeClosedCaptionEvent.fromJson(json);
      case "call.closed_captions_failed":
        return TypeCallClosedCaptionsFailedEvent.fromJson(json);
      case "call.closed_captions_started":
        return TypeCallClosedCaptionsStartedEvent.fromJson(json);
      case "call.closed_captions_stopped":
        return TypeCallClosedCaptionsStoppedEvent.fromJson(json);
      case "call.created":
        return TypeCallCreatedEvent.fromJson(json);
      case "call.deleted":
        return TypeCallDeletedEvent.fromJson(json);
      case "call.ended":
        return TypeCallEndedEvent.fromJson(json);
      case "call.frame_recording_failed":
        return TypeCallFrameRecordingFailedEvent.fromJson(json);
      case "call.frame_recording_ready":
        return TypeCallFrameRecordingFrameReadyEvent.fromJson(json);
      case "call.frame_recording_started":
        return TypeCallFrameRecordingStartedEvent.fromJson(json);
      case "call.frame_recording_stopped":
        return TypeCallFrameRecordingStoppedEvent.fromJson(json);
      case "call.hls_broadcasting_failed":
        return TypeCallHLSBroadcastingFailedEvent.fromJson(json);
      case "call.hls_broadcasting_started":
        return TypeCallHLSBroadcastingStartedEvent.fromJson(json);
      case "call.hls_broadcasting_stopped":
        return TypeCallHLSBroadcastingStoppedEvent.fromJson(json);
      case "call.live_started":
        return TypeCallLiveStartedEvent.fromJson(json);
      case "call.member_added":
        return TypeCallMemberAddedEvent.fromJson(json);
      case "call.member_removed":
        return TypeCallMemberRemovedEvent.fromJson(json);
      case "call.member_updated":
        return TypeCallMemberUpdatedEvent.fromJson(json);
      case "call.member_updated_permission":
        return TypeCallMemberUpdatedPermissionEvent.fromJson(json);
      case "call.missed":
        return TypeCallMissedEvent.fromJson(json);
      case "call.moderation_blur":
        return TypeCallModerationBlurEvent.fromJson(json);
      case "call.moderation_warning":
        return TypeCallModerationWarningEvent.fromJson(json);
      case "call.notification":
        return TypeCallNotificationEvent.fromJson(json);
      case "call.permission_request":
        return TypePermissionRequestEvent.fromJson(json);
      case "call.permissions_updated":
        return TypeUpdatedCallPermissionsEvent.fromJson(json);
      case "call.reaction_new":
        return TypeCallReactionEvent.fromJson(json);
      case "call.recording_failed":
        return TypeCallRecordingFailedEvent.fromJson(json);
      case "call.recording_ready":
        return TypeCallRecordingReadyEvent.fromJson(json);
      case "call.recording_started":
        return TypeCallRecordingStartedEvent.fromJson(json);
      case "call.recording_stopped":
        return TypeCallRecordingStoppedEvent.fromJson(json);
      case "call.rejected":
        return TypeCallRejectedEvent.fromJson(json);
      case "call.ring":
        return TypeCallRingEvent.fromJson(json);
      case "call.rtmp_broadcast_failed":
        return TypeCallRtmpBroadcastFailedEvent.fromJson(json);
      case "call.rtmp_broadcast_started":
        return TypeCallRtmpBroadcastStartedEvent.fromJson(json);
      case "call.rtmp_broadcast_stopped":
        return TypeCallRtmpBroadcastStoppedEvent.fromJson(json);
      case "call.session_ended":
        return TypeCallSessionEndedEvent.fromJson(json);
      case "call.session_participant_count_updated":
        return TypeCallSessionParticipantCountsUpdatedEvent.fromJson(json);
      case "call.session_participant_joined":
        return TypeCallSessionParticipantJoinedEvent.fromJson(json);
      case "call.session_participant_left":
        return TypeCallSessionParticipantLeftEvent.fromJson(json);
      case "call.session_started":
        return TypeCallSessionStartedEvent.fromJson(json);
      case "call.stats_report_ready":
        return TypeCallStatsReportReadyEvent.fromJson(json);
      case "call.transcription_failed":
        return TypeCallTranscriptionFailedEvent.fromJson(json);
      case "call.transcription_ready":
        return TypeCallTranscriptionReadyEvent.fromJson(json);
      case "call.transcription_started":
        return TypeCallTranscriptionStartedEvent.fromJson(json);
      case "call.transcription_stopped":
        return TypeCallTranscriptionStoppedEvent.fromJson(json);
      case "call.unblocked_user":
        return TypeUnblockedUserEvent.fromJson(json);
      case "call.updated":
        return TypeCallUpdatedEvent.fromJson(json);
      case "call.user_muted":
        return TypeCallUserMutedEvent.fromJson(json);
      case "connection.error":
        return TypeConnectionErrorEvent.fromJson(json);
      case "connection.ok":
        return TypeConnectedEvent.fromJson(json);
      case "custom":
        return TypeCustomVideoEvent.fromJson(json);
      case "health.check":
        return TypeHealthCheckEvent.fromJson(json);
      case "user.banned":
        return TypeUserBannedEvent.fromJson(json);
      case "user.deactivated":
        return TypeUserDeactivatedEvent.fromJson(json);
      case "user.muted":
        return TypeUserMutedEvent.fromJson(json);
      case "user.reactivated":
        return TypeUserReactivatedEvent.fromJson(json);
      case "user.updated":
        return TypeUserUpdatedEvent.fromJson(json);
      default:
        throw Exception('Unknown video event type: ${json['type']}');
    }
  }
}

class TypeAppUpdatedEvent extends VideoEvent {
  const TypeAppUpdatedEvent(this.appUpdatedEvent);

  factory TypeAppUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeAppUpdatedEvent(AppUpdatedEvent.fromJson(json)!);
  }

  final AppUpdatedEvent appUpdatedEvent;

  // @override
  // String get callCid => appUpdatedEvent.callCid;

  @override
  String get type => appUpdatedEvent.type;
}

class TypeCallAcceptedEvent extends VideoEvent {
  const TypeCallAcceptedEvent(this.callAcceptedEvent);

  factory TypeCallAcceptedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallAcceptedEvent(CallAcceptedEvent.fromJson(json)!);
  }

  final CallAcceptedEvent callAcceptedEvent;

  // @override
  // String get callCid => callAcceptedEvent.callCid;

  @override
  String get type => callAcceptedEvent.type;
}

class TypeBlockedUserEvent extends VideoEvent {
  const TypeBlockedUserEvent(this.blockedUserEvent);

  factory TypeBlockedUserEvent.fromJson(Map<String, dynamic> json) {
    return TypeBlockedUserEvent(BlockedUserEvent.fromJson(json)!);
  }

  final BlockedUserEvent blockedUserEvent;

  // @override
  // String get callCid => blockedUserEvent.callCid;

  @override
  String get type => blockedUserEvent.type;
}

class TypeClosedCaptionEvent extends VideoEvent {
  const TypeClosedCaptionEvent(this.closedCaptionEvent);

  factory TypeClosedCaptionEvent.fromJson(Map<String, dynamic> json) {
    return TypeClosedCaptionEvent(ClosedCaptionEvent.fromJson(json)!);
  }

  final ClosedCaptionEvent closedCaptionEvent;

  // @override
  // String get callCid => closedCaptionEvent.callCid;

  @override
  String get type => closedCaptionEvent.type;
}

class TypeCallClosedCaptionsFailedEvent extends VideoEvent {
  const TypeCallClosedCaptionsFailedEvent(this.callClosedCaptionsFailedEvent);

  factory TypeCallClosedCaptionsFailedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallClosedCaptionsFailedEvent(
        CallClosedCaptionsFailedEvent.fromJson(json)!);
  }

  final CallClosedCaptionsFailedEvent callClosedCaptionsFailedEvent;

  // @override
  // String get callCid => callClosedCaptionsFailedEvent.callCid;

  @override
  String get type => callClosedCaptionsFailedEvent.type;
}

class TypeCallClosedCaptionsStartedEvent extends VideoEvent {
  const TypeCallClosedCaptionsStartedEvent(this.callClosedCaptionsStartedEvent);

  factory TypeCallClosedCaptionsStartedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallClosedCaptionsStartedEvent(
        CallClosedCaptionsStartedEvent.fromJson(json)!);
  }

  final CallClosedCaptionsStartedEvent callClosedCaptionsStartedEvent;

  // @override
  // String get callCid => callClosedCaptionsStartedEvent.callCid;

  @override
  String get type => callClosedCaptionsStartedEvent.type;
}

class TypeCallClosedCaptionsStoppedEvent extends VideoEvent {
  const TypeCallClosedCaptionsStoppedEvent(this.callClosedCaptionsStoppedEvent);

  factory TypeCallClosedCaptionsStoppedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallClosedCaptionsStoppedEvent(
        CallClosedCaptionsStoppedEvent.fromJson(json)!);
  }

  final CallClosedCaptionsStoppedEvent callClosedCaptionsStoppedEvent;

  // @override
  // String get callCid => callClosedCaptionsStoppedEvent.callCid;

  @override
  String get type => callClosedCaptionsStoppedEvent.type;
}

class TypeCallCreatedEvent extends VideoEvent {
  const TypeCallCreatedEvent(this.callCreatedEvent);

  factory TypeCallCreatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallCreatedEvent(CallCreatedEvent.fromJson(json)!);
  }

  final CallCreatedEvent callCreatedEvent;

  // @override
  // String get callCid => callCreatedEvent.callCid;

  @override
  String get type => callCreatedEvent.type;
}

class TypeCallDeletedEvent extends VideoEvent {
  const TypeCallDeletedEvent(this.callDeletedEvent);

  factory TypeCallDeletedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallDeletedEvent(CallDeletedEvent.fromJson(json)!);
  }

  final CallDeletedEvent callDeletedEvent;

  // @override
  // String get callCid => callDeletedEvent.callCid;

  @override
  String get type => callDeletedEvent.type;
}

class TypeCallEndedEvent extends VideoEvent {
  const TypeCallEndedEvent(this.callEndedEvent);

  factory TypeCallEndedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallEndedEvent(CallEndedEvent.fromJson(json)!);
  }

  final CallEndedEvent callEndedEvent;

  // @override
  // String get callCid => callEndedEvent.callCid;

  @override
  String get type => callEndedEvent.type;
}

class TypeCallFrameRecordingFailedEvent extends VideoEvent {
  const TypeCallFrameRecordingFailedEvent(this.callFrameRecordingFailedEvent);

  factory TypeCallFrameRecordingFailedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallFrameRecordingFailedEvent(
        CallFrameRecordingFailedEvent.fromJson(json)!);
  }

  final CallFrameRecordingFailedEvent callFrameRecordingFailedEvent;

  // @override
  // String get callCid => callFrameRecordingFailedEvent.callCid;

  @override
  String get type => callFrameRecordingFailedEvent.type;
}

class TypeCallFrameRecordingFrameReadyEvent extends VideoEvent {
  const TypeCallFrameRecordingFrameReadyEvent(
      this.callFrameRecordingFrameReadyEvent);

  factory TypeCallFrameRecordingFrameReadyEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallFrameRecordingFrameReadyEvent(
        CallFrameRecordingFrameReadyEvent.fromJson(json)!);
  }

  final CallFrameRecordingFrameReadyEvent callFrameRecordingFrameReadyEvent;

  // @override
  // String get callCid => callFrameRecordingFrameReadyEvent.callCid;

  @override
  String get type => callFrameRecordingFrameReadyEvent.type;
}

class TypeCallFrameRecordingStartedEvent extends VideoEvent {
  const TypeCallFrameRecordingStartedEvent(this.callFrameRecordingStartedEvent);

  factory TypeCallFrameRecordingStartedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallFrameRecordingStartedEvent(
        CallFrameRecordingStartedEvent.fromJson(json)!);
  }

  final CallFrameRecordingStartedEvent callFrameRecordingStartedEvent;

  // @override
  // String get callCid => callFrameRecordingStartedEvent.callCid;

  @override
  String get type => callFrameRecordingStartedEvent.type;
}

class TypeCallFrameRecordingStoppedEvent extends VideoEvent {
  const TypeCallFrameRecordingStoppedEvent(this.callFrameRecordingStoppedEvent);

  factory TypeCallFrameRecordingStoppedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallFrameRecordingStoppedEvent(
        CallFrameRecordingStoppedEvent.fromJson(json)!);
  }

  final CallFrameRecordingStoppedEvent callFrameRecordingStoppedEvent;

  // @override
  // String get callCid => callFrameRecordingStoppedEvent.callCid;

  @override
  String get type => callFrameRecordingStoppedEvent.type;
}

class TypeCallHLSBroadcastingFailedEvent extends VideoEvent {
  const TypeCallHLSBroadcastingFailedEvent(this.callHLSBroadcastingFailedEvent);

  factory TypeCallHLSBroadcastingFailedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallHLSBroadcastingFailedEvent(
        CallHLSBroadcastingFailedEvent.fromJson(json)!);
  }

  final CallHLSBroadcastingFailedEvent callHLSBroadcastingFailedEvent;

  // @override
  // String get callCid => callHLSBroadcastingFailedEvent.callCid;

  @override
  String get type => callHLSBroadcastingFailedEvent.type;
}

class TypeCallHLSBroadcastingStartedEvent extends VideoEvent {
  const TypeCallHLSBroadcastingStartedEvent(
      this.callHLSBroadcastingStartedEvent);

  factory TypeCallHLSBroadcastingStartedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallHLSBroadcastingStartedEvent(
        CallHLSBroadcastingStartedEvent.fromJson(json)!);
  }

  final CallHLSBroadcastingStartedEvent callHLSBroadcastingStartedEvent;

  // @override
  // String get callCid => callHLSBroadcastingStartedEvent.callCid;

  @override
  String get type => callHLSBroadcastingStartedEvent.type;
}

class TypeCallHLSBroadcastingStoppedEvent extends VideoEvent {
  const TypeCallHLSBroadcastingStoppedEvent(
      this.callHLSBroadcastingStoppedEvent);

  factory TypeCallHLSBroadcastingStoppedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallHLSBroadcastingStoppedEvent(
        CallHLSBroadcastingStoppedEvent.fromJson(json)!);
  }

  final CallHLSBroadcastingStoppedEvent callHLSBroadcastingStoppedEvent;

  // @override
  // String get callCid => callHLSBroadcastingStoppedEvent.callCid;

  @override
  String get type => callHLSBroadcastingStoppedEvent.type;
}

class TypeCallLiveStartedEvent extends VideoEvent {
  const TypeCallLiveStartedEvent(this.callLiveStartedEvent);

  factory TypeCallLiveStartedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallLiveStartedEvent(CallLiveStartedEvent.fromJson(json)!);
  }

  final CallLiveStartedEvent callLiveStartedEvent;

  // @override
  // String get callCid => callLiveStartedEvent.callCid;

  @override
  String get type => callLiveStartedEvent.type;
}

class TypeCallMemberAddedEvent extends VideoEvent {
  const TypeCallMemberAddedEvent(this.callMemberAddedEvent);

  factory TypeCallMemberAddedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallMemberAddedEvent(CallMemberAddedEvent.fromJson(json)!);
  }

  final CallMemberAddedEvent callMemberAddedEvent;

  // @override
  // String get callCid => callMemberAddedEvent.callCid;

  @override
  String get type => callMemberAddedEvent.type;
}

class TypeCallMemberRemovedEvent extends VideoEvent {
  const TypeCallMemberRemovedEvent(this.callMemberRemovedEvent);

  factory TypeCallMemberRemovedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallMemberRemovedEvent(CallMemberRemovedEvent.fromJson(json)!);
  }

  final CallMemberRemovedEvent callMemberRemovedEvent;

  // @override
  // String get callCid => callMemberRemovedEvent.callCid;

  @override
  String get type => callMemberRemovedEvent.type;
}

class TypeCallMemberUpdatedEvent extends VideoEvent {
  const TypeCallMemberUpdatedEvent(this.callMemberUpdatedEvent);

  factory TypeCallMemberUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallMemberUpdatedEvent(CallMemberUpdatedEvent.fromJson(json)!);
  }

  final CallMemberUpdatedEvent callMemberUpdatedEvent;

  // @override
  // String get callCid => callMemberUpdatedEvent.callCid;

  @override
  String get type => callMemberUpdatedEvent.type;
}

class TypeCallMemberUpdatedPermissionEvent extends VideoEvent {
  const TypeCallMemberUpdatedPermissionEvent(
      this.callMemberUpdatedPermissionEvent);

  factory TypeCallMemberUpdatedPermissionEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallMemberUpdatedPermissionEvent(
        CallMemberUpdatedPermissionEvent.fromJson(json)!);
  }

  final CallMemberUpdatedPermissionEvent callMemberUpdatedPermissionEvent;

  // @override
  // String get callCid => callMemberUpdatedPermissionEvent.callCid;

  @override
  String get type => callMemberUpdatedPermissionEvent.type;
}

class TypeCallMissedEvent extends VideoEvent {
  const TypeCallMissedEvent(this.callMissedEvent);

  factory TypeCallMissedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallMissedEvent(CallMissedEvent.fromJson(json)!);
  }

  final CallMissedEvent callMissedEvent;

  // @override
  // String get callCid => callMissedEvent.callCid;

  @override
  String get type => callMissedEvent.type;
}

class TypeCallModerationBlurEvent extends VideoEvent {
  const TypeCallModerationBlurEvent(this.callModerationBlurEvent);

  factory TypeCallModerationBlurEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallModerationBlurEvent(CallModerationBlurEvent.fromJson(json)!);
  }

  final CallModerationBlurEvent callModerationBlurEvent;

  // @override
  // String get callCid => callModerationBlurEvent.callCid;

  @override
  String get type => callModerationBlurEvent.type;
}

class TypeCallModerationWarningEvent extends VideoEvent {
  const TypeCallModerationWarningEvent(this.callModerationWarningEvent);

  factory TypeCallModerationWarningEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallModerationWarningEvent(
        CallModerationWarningEvent.fromJson(json)!);
  }

  final CallModerationWarningEvent callModerationWarningEvent;

  // @override
  // String get callCid => callModerationWarningEvent.callCid;

  @override
  String get type => callModerationWarningEvent.type;
}

class TypeCallNotificationEvent extends VideoEvent {
  const TypeCallNotificationEvent(this.callNotificationEvent);

  factory TypeCallNotificationEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallNotificationEvent(CallNotificationEvent.fromJson(json)!);
  }

  final CallNotificationEvent callNotificationEvent;

  // @override
  // String get callCid => callNotificationEvent.callCid;

  @override
  String get type => callNotificationEvent.type;
}

class TypePermissionRequestEvent extends VideoEvent {
  const TypePermissionRequestEvent(this.permissionRequestEvent);

  factory TypePermissionRequestEvent.fromJson(Map<String, dynamic> json) {
    return TypePermissionRequestEvent(PermissionRequestEvent.fromJson(json)!);
  }

  final PermissionRequestEvent permissionRequestEvent;

  // @override
  // String get callCid => permissionRequestEvent.callCid;

  @override
  String get type => permissionRequestEvent.type;
}

class TypeUpdatedCallPermissionsEvent extends VideoEvent {
  const TypeUpdatedCallPermissionsEvent(this.updatedCallPermissionsEvent);

  factory TypeUpdatedCallPermissionsEvent.fromJson(Map<String, dynamic> json) {
    return TypeUpdatedCallPermissionsEvent(
        UpdatedCallPermissionsEvent.fromJson(json)!);
  }

  final UpdatedCallPermissionsEvent updatedCallPermissionsEvent;

  // @override
  // String get callCid => updatedCallPermissionsEvent.callCid;

  @override
  String get type => updatedCallPermissionsEvent.type;
}

class TypeCallReactionEvent extends VideoEvent {
  const TypeCallReactionEvent(this.callReactionEvent);

  factory TypeCallReactionEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallReactionEvent(CallReactionEvent.fromJson(json)!);
  }

  final CallReactionEvent callReactionEvent;

  // @override
  // String get callCid => callReactionEvent.callCid;

  @override
  String get type => callReactionEvent.type;
}

class TypeCallRecordingFailedEvent extends VideoEvent {
  const TypeCallRecordingFailedEvent(this.callRecordingFailedEvent);

  factory TypeCallRecordingFailedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRecordingFailedEvent(
        CallRecordingFailedEvent.fromJson(json)!);
  }

  final CallRecordingFailedEvent callRecordingFailedEvent;

  // @override
  // String get callCid => callRecordingFailedEvent.callCid;

  @override
  String get type => callRecordingFailedEvent.type;
}

class TypeCallRecordingReadyEvent extends VideoEvent {
  const TypeCallRecordingReadyEvent(this.callRecordingReadyEvent);

  factory TypeCallRecordingReadyEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRecordingReadyEvent(CallRecordingReadyEvent.fromJson(json)!);
  }

  final CallRecordingReadyEvent callRecordingReadyEvent;

  // @override
  // String get callCid => callRecordingReadyEvent.callCid;

  @override
  String get type => callRecordingReadyEvent.type;
}

class TypeCallRecordingStartedEvent extends VideoEvent {
  const TypeCallRecordingStartedEvent(this.callRecordingStartedEvent);

  factory TypeCallRecordingStartedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRecordingStartedEvent(
        CallRecordingStartedEvent.fromJson(json)!);
  }

  final CallRecordingStartedEvent callRecordingStartedEvent;

  // @override
  // String get callCid => callRecordingStartedEvent.callCid;

  @override
  String get type => callRecordingStartedEvent.type;
}

class TypeCallRecordingStoppedEvent extends VideoEvent {
  const TypeCallRecordingStoppedEvent(this.callRecordingStoppedEvent);

  factory TypeCallRecordingStoppedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRecordingStoppedEvent(
        CallRecordingStoppedEvent.fromJson(json)!);
  }

  final CallRecordingStoppedEvent callRecordingStoppedEvent;

  // @override
  // String get callCid => callRecordingStoppedEvent.callCid;

  @override
  String get type => callRecordingStoppedEvent.type;
}

class TypeCallRejectedEvent extends VideoEvent {
  const TypeCallRejectedEvent(this.callRejectedEvent);

  factory TypeCallRejectedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRejectedEvent(CallRejectedEvent.fromJson(json)!);
  }

  final CallRejectedEvent callRejectedEvent;

  // @override
  // String get callCid => callRejectedEvent.callCid;

  @override
  String get type => callRejectedEvent.type;
}

class TypeCallRingEvent extends VideoEvent {
  const TypeCallRingEvent(this.callRingEvent);

  factory TypeCallRingEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRingEvent(CallRingEvent.fromJson(json)!);
  }

  final CallRingEvent callRingEvent;

  // @override
  // String get callCid => callRingEvent.callCid;

  @override
  String get type => callRingEvent.type;
}

class TypeCallRtmpBroadcastFailedEvent extends VideoEvent {
  const TypeCallRtmpBroadcastFailedEvent(this.callRtmpBroadcastFailedEvent);

  factory TypeCallRtmpBroadcastFailedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallRtmpBroadcastFailedEvent(
        CallRtmpBroadcastFailedEvent.fromJson(json)!);
  }

  final CallRtmpBroadcastFailedEvent callRtmpBroadcastFailedEvent;

  // @override
  // String get callCid => callRtmpBroadcastFailedEvent.callCid;

  @override
  String get type => callRtmpBroadcastFailedEvent.type;
}

class TypeCallRtmpBroadcastStartedEvent extends VideoEvent {
  const TypeCallRtmpBroadcastStartedEvent(this.callRtmpBroadcastStartedEvent);

  factory TypeCallRtmpBroadcastStartedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallRtmpBroadcastStartedEvent(
        CallRtmpBroadcastStartedEvent.fromJson(json)!);
  }

  final CallRtmpBroadcastStartedEvent callRtmpBroadcastStartedEvent;

  // @override
  // String get callCid => callRtmpBroadcastStartedEvent.callCid;

  @override
  String get type => callRtmpBroadcastStartedEvent.type;
}

class TypeCallRtmpBroadcastStoppedEvent extends VideoEvent {
  const TypeCallRtmpBroadcastStoppedEvent(this.callRtmpBroadcastStoppedEvent);

  factory TypeCallRtmpBroadcastStoppedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallRtmpBroadcastStoppedEvent(
        CallRtmpBroadcastStoppedEvent.fromJson(json)!);
  }

  final CallRtmpBroadcastStoppedEvent callRtmpBroadcastStoppedEvent;

  // @override
  // String get callCid => callRtmpBroadcastStoppedEvent.callCid;

  @override
  String get type => callRtmpBroadcastStoppedEvent.type;
}

class TypeCallSessionEndedEvent extends VideoEvent {
  const TypeCallSessionEndedEvent(this.callSessionEndedEvent);

  factory TypeCallSessionEndedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallSessionEndedEvent(CallSessionEndedEvent.fromJson(json)!);
  }

  final CallSessionEndedEvent callSessionEndedEvent;

  // @override
  // String get callCid => callSessionEndedEvent.callCid;

  @override
  String get type => callSessionEndedEvent.type;
}

class TypeCallSessionParticipantCountsUpdatedEvent extends VideoEvent {
  const TypeCallSessionParticipantCountsUpdatedEvent(
      this.callSessionParticipantCountsUpdatedEvent);

  factory TypeCallSessionParticipantCountsUpdatedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallSessionParticipantCountsUpdatedEvent(
        CallSessionParticipantCountsUpdatedEvent.fromJson(json)!);
  }

  final CallSessionParticipantCountsUpdatedEvent
      callSessionParticipantCountsUpdatedEvent;

  // @override
  // String get callCid => callSessionParticipantCountsUpdatedEvent.callCid;

  @override
  String get type => callSessionParticipantCountsUpdatedEvent.type;
}

class TypeCallSessionParticipantJoinedEvent extends VideoEvent {
  const TypeCallSessionParticipantJoinedEvent(
      this.callSessionParticipantJoinedEvent);

  factory TypeCallSessionParticipantJoinedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallSessionParticipantJoinedEvent(
        CallSessionParticipantJoinedEvent.fromJson(json)!);
  }

  final CallSessionParticipantJoinedEvent callSessionParticipantJoinedEvent;

  // @override
  // String get callCid => callSessionParticipantJoinedEvent.callCid;

  @override
  String get type => callSessionParticipantJoinedEvent.type;
}

class TypeCallSessionParticipantLeftEvent extends VideoEvent {
  const TypeCallSessionParticipantLeftEvent(
      this.callSessionParticipantLeftEvent);

  factory TypeCallSessionParticipantLeftEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallSessionParticipantLeftEvent(
        CallSessionParticipantLeftEvent.fromJson(json)!);
  }

  final CallSessionParticipantLeftEvent callSessionParticipantLeftEvent;

  // @override
  // String get callCid => callSessionParticipantLeftEvent.callCid;

  @override
  String get type => callSessionParticipantLeftEvent.type;
}

class TypeCallSessionStartedEvent extends VideoEvent {
  const TypeCallSessionStartedEvent(this.callSessionStartedEvent);

  factory TypeCallSessionStartedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallSessionStartedEvent(CallSessionStartedEvent.fromJson(json)!);
  }

  final CallSessionStartedEvent callSessionStartedEvent;

  // @override
  // String get callCid => callSessionStartedEvent.callCid;

  @override
  String get type => callSessionStartedEvent.type;
}

class TypeCallStatsReportReadyEvent extends VideoEvent {
  const TypeCallStatsReportReadyEvent(this.callStatsReportReadyEvent);

  factory TypeCallStatsReportReadyEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallStatsReportReadyEvent(
        CallStatsReportReadyEvent.fromJson(json)!);
  }

  final CallStatsReportReadyEvent callStatsReportReadyEvent;

  // @override
  // String get callCid => callStatsReportReadyEvent.callCid;

  @override
  String get type => callStatsReportReadyEvent.type;
}

class TypeCallTranscriptionFailedEvent extends VideoEvent {
  const TypeCallTranscriptionFailedEvent(this.callTranscriptionFailedEvent);

  factory TypeCallTranscriptionFailedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallTranscriptionFailedEvent(
        CallTranscriptionFailedEvent.fromJson(json)!);
  }

  final CallTranscriptionFailedEvent callTranscriptionFailedEvent;

  // @override
  // String get callCid => callTranscriptionFailedEvent.callCid;

  @override
  String get type => callTranscriptionFailedEvent.type;
}

class TypeCallTranscriptionReadyEvent extends VideoEvent {
  const TypeCallTranscriptionReadyEvent(this.callTranscriptionReadyEvent);

  factory TypeCallTranscriptionReadyEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallTranscriptionReadyEvent(
        CallTranscriptionReadyEvent.fromJson(json)!);
  }

  final CallTranscriptionReadyEvent callTranscriptionReadyEvent;

  // @override
  // String get callCid => callTranscriptionReadyEvent.callCid;

  @override
  String get type => callTranscriptionReadyEvent.type;
}

class TypeCallTranscriptionStartedEvent extends VideoEvent {
  const TypeCallTranscriptionStartedEvent(this.callTranscriptionStartedEvent);

  factory TypeCallTranscriptionStartedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallTranscriptionStartedEvent(
        CallTranscriptionStartedEvent.fromJson(json)!);
  }

  final CallTranscriptionStartedEvent callTranscriptionStartedEvent;

  // @override
  // String get callCid => callTranscriptionStartedEvent.callCid;

  @override
  String get type => callTranscriptionStartedEvent.type;
}

class TypeCallTranscriptionStoppedEvent extends VideoEvent {
  const TypeCallTranscriptionStoppedEvent(this.callTranscriptionStoppedEvent);

  factory TypeCallTranscriptionStoppedEvent.fromJson(
      Map<String, dynamic> json) {
    return TypeCallTranscriptionStoppedEvent(
        CallTranscriptionStoppedEvent.fromJson(json)!);
  }

  final CallTranscriptionStoppedEvent callTranscriptionStoppedEvent;

  // @override
  // String get callCid => callTranscriptionStoppedEvent.callCid;

  @override
  String get type => callTranscriptionStoppedEvent.type;
}

class TypeUnblockedUserEvent extends VideoEvent {
  const TypeUnblockedUserEvent(this.unblockedUserEvent);

  factory TypeUnblockedUserEvent.fromJson(Map<String, dynamic> json) {
    return TypeUnblockedUserEvent(UnblockedUserEvent.fromJson(json)!);
  }

  final UnblockedUserEvent unblockedUserEvent;

  // @override
  // String get callCid => unblockedUserEvent.callCid;

  @override
  String get type => unblockedUserEvent.type;
}

class TypeCallUpdatedEvent extends VideoEvent {
  const TypeCallUpdatedEvent(this.callUpdatedEvent);

  factory TypeCallUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallUpdatedEvent(CallUpdatedEvent.fromJson(json)!);
  }

  final CallUpdatedEvent callUpdatedEvent;

  // @override
  // String get callCid => callUpdatedEvent.callCid;

  @override
  String get type => callUpdatedEvent.type;
}

class TypeCallUserMutedEvent extends VideoEvent {
  const TypeCallUserMutedEvent(this.callUserMutedEvent);

  factory TypeCallUserMutedEvent.fromJson(Map<String, dynamic> json) {
    return TypeCallUserMutedEvent(CallUserMutedEvent.fromJson(json)!);
  }

  final CallUserMutedEvent callUserMutedEvent;

  // @override
  // String get callCid => callUserMutedEvent.callCid;

  @override
  String get type => callUserMutedEvent.type;
}

class TypeConnectionErrorEvent extends VideoEvent {
  const TypeConnectionErrorEvent(this.connectionErrorEvent);

  factory TypeConnectionErrorEvent.fromJson(Map<String, dynamic> json) {
    return TypeConnectionErrorEvent(ConnectionErrorEvent.fromJson(json)!);
  }

  final ConnectionErrorEvent connectionErrorEvent;

  // @override
  // String get callCid => connectionErrorEvent.callCid;

  @override
  String get type => connectionErrorEvent.type;
}

class TypeConnectedEvent extends VideoEvent {
  const TypeConnectedEvent(this.connectedEvent);

  factory TypeConnectedEvent.fromJson(Map<String, dynamic> json) {
    return TypeConnectedEvent(ConnectedEvent.fromJson(json)!);
  }

  final ConnectedEvent connectedEvent;

  // @override
  // String get callCid => connectedEvent.callCid;

  @override
  String get type => connectedEvent.type;
}

class TypeCustomVideoEvent extends VideoEvent {
  const TypeCustomVideoEvent(this.customVideoEvent);

  factory TypeCustomVideoEvent.fromJson(Map<String, dynamic> json) {
    return TypeCustomVideoEvent(CustomVideoEvent.fromJson(json)!);
  }

  final CustomVideoEvent customVideoEvent;

  // @override
  // String get callCid => customVideoEvent.callCid;

  @override
  String get type => customVideoEvent.type;
}

class TypeHealthCheckEvent extends VideoEvent {
  const TypeHealthCheckEvent(this.healthCheckEvent);

  factory TypeHealthCheckEvent.fromJson(Map<String, dynamic> json) {
    return TypeHealthCheckEvent(HealthCheckEvent.fromJson(json)!);
  }

  final HealthCheckEvent healthCheckEvent;

  // @override
  // String get callCid => healthCheckEvent.callCid;

  @override
  String get type => healthCheckEvent.type;
}

class TypeUserBannedEvent extends VideoEvent {
  const TypeUserBannedEvent(this.userBannedEvent);

  factory TypeUserBannedEvent.fromJson(Map<String, dynamic> json) {
    return TypeUserBannedEvent(UserBannedEvent.fromJson(json)!);
  }

  final UserBannedEvent userBannedEvent;

  // @override
  // String get callCid => userBannedEvent.callCid;

  @override
  String get type => userBannedEvent.type;
}

class TypeUserDeactivatedEvent extends VideoEvent {
  const TypeUserDeactivatedEvent(this.userDeactivatedEvent);

  factory TypeUserDeactivatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeUserDeactivatedEvent(UserDeactivatedEvent.fromJson(json)!);
  }

  final UserDeactivatedEvent userDeactivatedEvent;

  // @override
  // String get callCid => userDeactivatedEvent.callCid;

  @override
  String get type => userDeactivatedEvent.type;
}

class TypeUserMutedEvent extends VideoEvent {
  const TypeUserMutedEvent(this.userMutedEvent);

  factory TypeUserMutedEvent.fromJson(Map<String, dynamic> json) {
    return TypeUserMutedEvent(UserMutedEvent.fromJson(json)!);
  }

  final UserMutedEvent userMutedEvent;

  // @override
  // String get callCid => userMutedEvent.callCid;

  @override
  String get type => userMutedEvent.type;
}

class TypeUserReactivatedEvent extends VideoEvent {
  const TypeUserReactivatedEvent(this.userReactivatedEvent);

  factory TypeUserReactivatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeUserReactivatedEvent(UserReactivatedEvent.fromJson(json)!);
  }

  final UserReactivatedEvent userReactivatedEvent;

  // @override
  // String get callCid => userReactivatedEvent.callCid;

  @override
  String get type => userReactivatedEvent.type;
}

class TypeUserUpdatedEvent extends VideoEvent {
  const TypeUserUpdatedEvent(this.userUpdatedEvent);

  factory TypeUserUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return TypeUserUpdatedEvent(UserUpdatedEvent.fromJson(json)!);
  }

  final UserUpdatedEvent userUpdatedEvent;

  // @override
  // String get callCid => userUpdatedEvent.callCid;

  @override
  String get type => userUpdatedEvent.type;
}
