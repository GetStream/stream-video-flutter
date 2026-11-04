import '../../../open_api/video/coordinator/api.dart' as open;
import '../../call/call_events.dart';
import '../../models/call_cid.dart';
import '../../models/call_permission.dart';
import '../../models/call_settings.dart';
import '../../models/stream_video_event.dart';
import '../models/coordinator_events.dart';
import 'event/event_type.dart';
import 'open_api_extensions.dart';

/// Decodes the coordinator message [json], an envelope of [type], into the
/// event the SDK delivers for it.
///
/// Each message is parsed once, into its generated model, and mapped from
/// there. Returns `null` for [EventType.unknown], which has no model to parse.
StreamVideoEvent? coordinatorEventFromJson(
  EventType type,
  Map<String, dynamic> json,
) {
  switch (type) {
    case EventType.connectionOk:
      final me = json['me'] as Map<String, dynamic>;
      return CoordinatorConnectedEvent(
        connectionId: json['connection_id'] as String,
        userId: me['id'] as String,
      );
    case EventType.healthCheck:
      return CoordinatorHealthCheckEvent(
        clientId: json['connection_id'] as String,
      );
    case EventType.callCreated:
      final event = open.CallCreatedEvent.fromJson(json);
      final call = event.call;
      return StreamCallCreatedEvent(
        StreamCallCid(cid: call.cid),
        metadata: call.toCallMetadata(members: event.members),
        createdAt: event.createdAt,
      );
    case EventType.callMissed:
      final event = open.CallMissedEvent.fromJson(json);
      final call = event.call;
      return StreamCallMissedEvent(
        StreamCallCid(cid: call.cid),
        sessionId: event.sessionId,
        createdAt: event.createdAt,
        members: event.members.map((it) => it.toCallMember()).toList(),
        metadata: call.toCallMetadata(members: event.members),
        callUser: event.user.toCallUser(),
      );
    case EventType.callRing:
      final event = open.CallRingEvent.fromJson(json);
      final call = event.call;
      return StreamCallRingingEvent(
        StreamCallCid(cid: call.cid),
        ringing: true,
        metadata: call.toCallMetadata(members: event.members),
        video: event.video,
        sessionId: event.sessionId,
        createdAt: event.createdAt,
      );
    case EventType.callAccepted:
      final event = open.CallAcceptedEvent.fromJson(json);
      return StreamCallAcceptedEvent(
        StreamCallCid(cid: event.callCid),
        acceptedBy: event.user.toCallUser(),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callRejected:
      final event = open.CallRejectedEvent.fromJson(json);
      return StreamCallRejectedEvent(
        StreamCallCid(cid: event.callCid),
        rejectedBy: event.user.toCallUser(),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callUpdated:
      final event = open.CallUpdatedEvent.fromJson(json);
      return StreamCallUpdatedEvent(
        StreamCallCid(cid: event.call.cid),
        capabilitiesByRole: event.capabilitiesByRole,
        metadata: event.call.toCallMetadata(),
        createdAt: event.createdAt,
      );
    case EventType.callEnded:
      final event = open.CallEndedEvent.fromJson(json);
      final endedBy = event.user?.toCallUser();
      return StreamCallEndedEvent(
        StreamCallCid(cid: event.callCid),
        endedBy: endedBy,
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        type: event.type,
        reason: event.reason,
        members: event.members?.map((it) => it.toCallMember()).toList() ?? [],
      );
    case EventType.callSessionStarted:
      final event = open.CallSessionStartedEvent.fromJson(json);

      return StreamCallSessionStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callSessionEnded:
      final event = open.CallSessionEndedEvent.fromJson(json);

      return StreamCallSessionEndedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callSessionParticipantJoined:
      final event = open.CallSessionParticipantJoinedEvent.fromJson(json);

      return StreamCallSessionParticipantJoinedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        user: event.participant.user.toCallUser(),
        participant: event.participant.toCallParticipant(),
      );
    case EventType.callSessionParticipantLeft:
      final event = open.CallSessionParticipantLeftEvent.fromJson(json);

      return StreamCallSessionParticipantLeftEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        user: event.participant.user.toCallUser(),
        participant: event.participant.toCallParticipant(),
        duration: Duration(seconds: event.durationSeconds),
        reason: event.reason,
      );
    case EventType.callSessionParticipantCountUpdated:
      final event = open.CallSessionParticipantCountsUpdatedEvent.fromJson(
        json,
      );

      return StreamCallSessionParticipantCountUpdatedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        anonymousParticipantCount: event.anonymousParticipantCount,
        participantsCountByRole: event.participantsCountByRole,
      );
    case EventType.callPermissionRequest:
      final event = open.PermissionRequestEvent.fromJson(json);
      return StreamCallPermissionRequestEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        permissions: event.permissions.map(CallPermission.fromAlias).toList(),
        user: event.user.toCallUser(),
      );
    case EventType.callPermissionsUpdated:
      final event = open.UpdatedCallPermissionsEvent.fromJson(json);
      return StreamCallPermissionsUpdatedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        ownCapabilities: event.ownCapabilities.map(
          CallPermission.fromAlias,
        ),
        user: event.user.toCallUser(),
      );
    case EventType.callRecordingStarted:
      final event = open.CallRecordingStartedEvent.fromJson(json);

      return StreamCallRecordingStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        recordingType: RecordingType.fromString(event.recordingType),
      );
    case EventType.callRecordingStopped:
      final event = open.CallRecordingStoppedEvent.fromJson(json);

      return StreamCallRecordingStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        recordingType: RecordingType.fromString(event.recordingType),
      );
    case EventType.callRecordingFailed:
      final event = open.CallRecordingFailedEvent.fromJson(json);

      return StreamCallRecordingFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        recordingType: RecordingType.fromString(event.recordingType),
      );
    case EventType.callBroadcastingStarted:
      final event = open.CallHLSBroadcastingStartedEvent.fromJson(json);
      return StreamCallBroadcastingStartedEvent(
        StreamCallCid(cid: event.callCid),
        hlsPlaylistUrl: event.hlsPlaylistUrl,
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callBroadcastingStopped:
      final event = open.CallHLSBroadcastingStoppedEvent.fromJson(json);
      return StreamCallBroadcastingStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callBroadcastingFailed:
      final event = open.CallHLSBroadcastingFailedEvent.fromJson(json);
      return StreamCallBroadcastingFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callRtmpBroadcastStarted:
      final event = open.CallRtmpBroadcastStartedEvent.fromJson(json);
      return StreamCallRtmpBroadcastStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        name: event.name,
      );
    case EventType.callRtmpBroadcastStopped:
      final event = open.CallRtmpBroadcastStoppedEvent.fromJson(json);
      return StreamCallRtmpBroadcastStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        name: event.name,
      );
    case EventType.callRtmpBroadcastFailed:
      final event = open.CallRtmpBroadcastFailedEvent.fromJson(json);
      return StreamCallRtmpBroadcastFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        name: event.name,
      );
    case EventType.callLiveStarted:
      final event = open.CallLiveStartedEvent.fromJson(json);
      return StreamCallLiveStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callMemberAdded:
      final event = open.CallMemberAddedEvent.fromJson(json);
      return StreamCallMemberAddedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        members: event.members.map((it) => it.toCallMember()).toList(),
      );
    case EventType.callMemberRemoved:
      final event = open.CallMemberRemovedEvent.fromJson(json);
      return StreamCallMemberRemovedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        removedMemberIds: event.members,
      );
    case EventType.callMemberUpdated:
      final event = open.CallMemberUpdatedEvent.fromJson(json);
      return StreamCallMemberUpdatedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        members: event.members.map((it) => it.toCallMember()).toList(),
      );
    case EventType.callMemberUpdatedPermission:
      final event = open.CallMemberUpdatedPermissionEvent.fromJson(json);
      return StreamCallMemberUpdatedPermissionEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        updatedMembers: event.members.map((it) => it.toCallMember()).toList(),
        capabilitiesByRole: event.capabilitiesByRole,
      );
    case EventType.callUserBlocked:
      final event = open.BlockedUserEvent.fromJson(json);

      return StreamCallUserBlockedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        user: event.user.toCallUser(),
      );
    case EventType.callUserUnblocked:
      final event = open.UnblockedUserEvent.fromJson(json);

      return StreamCallUserUnblockedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        user: event.user.toCallUser(),
      );
    case EventType.callUserKicked:
      final event = open.KickedUserEvent.fromJson(json);

      return StreamCallUserKickedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        user: event.user.toCallUser(),
        kickedByUser: event.kickedByUser?.toCallUser(),
      );
    case EventType.callReaction:
      final event = open.CallReactionEvent.fromJson(json);

      return StreamCallReactionEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        reactionType: event.reaction.type,
        user: event.reaction.user.toCallUser(),
        emojiCode: event.reaction.emojiCode,
        custom: event.reaction.custom,
      );
    case EventType.callTranscriptionStarted:
      final event = open.CallTranscriptionStartedEvent.fromJson(json);
      return StreamCallTranscriptionStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callTranscriptionStopped:
      final event = open.CallTranscriptionStoppedEvent.fromJson(json);
      return StreamCallTranscriptionStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callTranscriptionFailed:
      final event = open.CallTranscriptionFailedEvent.fromJson(json);
      return StreamCallTranscriptionFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        error: event.error,
      );
    case EventType.callClosedCaptionStarted:
      final event = open.CallClosedCaptionsStartedEvent.fromJson(json);
      return StreamCallClosedCaptionsStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callClosedCaptionStopped:
      final event = open.CallClosedCaptionsStoppedEvent.fromJson(json);
      return StreamCallClosedCaptionsStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callClosedCaptionFailed:
      final event = open.CallClosedCaptionsFailedEvent.fromJson(json);
      return StreamCallClosedCaptionsFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
      );
    case EventType.callClosedCaption:
      final event = open.ClosedCaptionEvent.fromJson(json);
      return StreamCallClosedCaptionsEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        startTime: event.closedCaption.startTime,
        endTime: event.closedCaption.endTime,
        speakerId: event.closedCaption.speakerId,
        text: event.closedCaption.text,
        user: event.closedCaption.user.toCallUser(),
        language: event.closedCaption.language,
        translated: event.closedCaption.translated,
        service: event.closedCaption.service,
      );
    case EventType.callFrameRecordingStarted:
      final event = open.CallFrameRecordingStartedEvent.fromJson(json);
      return StreamCallFrameRecordingStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        egressId: event.egressId,
      );
    case EventType.callFrameRecordingStopped:
      final event = open.CallFrameRecordingStoppedEvent.fromJson(json);
      return StreamCallFrameRecordingStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        egressId: event.egressId,
      );
    case EventType.callFrameRecordingFailed:
      final event = open.CallFrameRecordingFailedEvent.fromJson(json);
      return StreamCallFrameRecordingFailedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
        egressId: event.egressId,
      );
    case EventType.callFrameRecordingReady:
      final event = open.CallFrameRecordingFrameReadyEvent.fromJson(json);
      return StreamCallFrameRecordingReadyEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        url: event.url,
        capturedAt: event.capturedAt,
        egressId: event.egressId,
        sessionId: event.sessionId,
        trackType: event.trackType,
        usersInFrame: event.users.map(
          (key, value) => MapEntry(key, value.toCallUser()),
        ),
      );
    case EventType.callNotification:
      final event = open.CallNotificationEvent.fromJson(json);
      return StreamCallNotificationEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        user: event.user.toCallUser(),
        members: event.members.map((it) => it.toCallMember()).toList(),
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callUserMuted:
      final event = open.CallUserMutedEvent.fromJson(json);
      return StreamCallUserMutedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        fromUserId: event.fromUserId,
        mutedUserIds: event.mutedUserIds,
        reason: event.reason,
      );
    case EventType.callRecordingReady:
      final event = open.CallRecordingReadyEvent.fromJson(json);
      return StreamCallRecordingReadyEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        url: event.callRecording.url,
        endTime: event.callRecording.endTime,
        filename: event.callRecording.filename,
        recordingType: RecordingType.fromString(event.recordingType),
        sessionId: event.callRecording.sessionId,
        startTime: event.callRecording.startTime,
        egressId: event.egressId,
      );
    case EventType.callModerationBlur:
      final event = open.CallModerationBlurEvent.fromJson(json);
      return StreamCallModerationBlurEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        userId: event.userId,
        custom: event.custom,
      );
    case EventType.callModerationWarning:
      final event = open.CallModerationWarningEvent.fromJson(json);
      return StreamCallModerationWarningEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        userId: event.userId,
        message: event.message,
        custom: event.custom,
      );
    case EventType.callDeleted:
      final event = open.CallDeletedEvent.fromJson(json);
      return StreamCallDeletedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        metadata: event.call.toCallMetadata(),
      );
    case EventType.callUserFeedbackSubmitted:
      final event = open.CallUserFeedbackSubmittedEvent.fromJson(json);
      return StreamCallUserFeedbackSubmittedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        sessionId: event.sessionId,
        rating: event.rating,
        reason: event.reason,
        sdk: event.sdk,
        sdkVersion: event.sdkVersion,
        user: event.user.toCallUser(),
        custom: event.custom ?? const <String, Object?>{},
      );
    case EventType.callTranscriptionReady:
      final event = open.CallTranscriptionReadyEvent.fromJson(json);
      return StreamCallTranscriptionReadyEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        egressId: event.egressId,
        url: event.callTranscription.url,
        filename: event.callTranscription.filename,
        startTime: event.callTranscription.startTime,
        endTime: event.callTranscription.endTime,
        sessionId: event.callTranscription.sessionId,
      );
    case EventType.ingressStarted:
      final event = open.IngressStartedEvent.fromJson(json);
      return StreamCallIngressStartedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        ingressStreamId: event.ingressStreamId,
        publisherType: event.publisherType,
        userId: event.userId,
        clientIp: event.clientIp,
        clientName: event.clientName,
        version: event.version,
      );
    case EventType.ingressStopped:
      final event = open.IngressStoppedEvent.fromJson(json);
      return StreamCallIngressStoppedEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        ingressStreamId: event.ingressStreamId,
        userId: event.userId,
      );
    case EventType.ingressError:
      final event = open.IngressErrorEvent.fromJson(json);
      return StreamCallIngressErrorEvent(
        StreamCallCid(cid: event.callCid),
        createdAt: event.createdAt,
        ingressStreamId: event.ingressStreamId,
        userId: event.userId,
        error: event.error,
        code: event.code,
      );
    case EventType.custom:
      final event = open.CustomVideoEvent.fromJson(json);

      return StreamCallCustomEvent(
        StreamCallCid(cid: event.callCid),
        senderUserId: event.user.id,
        createdAt: event.createdAt,
        eventType: event.type,
        custom: event.custom,
        users: {event.user.id: event.user.toCallUser()},
      );
    case EventType.unknown:
      return null;
  }
}
