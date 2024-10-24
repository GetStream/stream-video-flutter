// ignore_for_file: unused_local_variable

import '../../models/call_cid.dart';
import '../../models/call_created_data.dart';
import '../../models/call_permission.dart';
import '../../models/call_ringing_data.dart';
import '../models/coordinator_events.dart';
import 'event/event_type.dart';
import 'event/open_api_event.dart';
import 'open_api_extensions.dart';

extension WebsocketEventMapperExt on OpenApiEvent {
  /// Returns [CoordinatorEvent].
  CoordinatorEvent? toCoordinatorEvent() {
    switch (type) {
      case EventType.connectionOk:
        final event = connected!;
        return CoordinatorConnectedEvent(
          connectionId: event.connectionId,
          userId: event.me.id,
        );
      case EventType.healthCheck:
        return CoordinatorHealthCheckEvent(
          clientId: healthCheck!.connectionId,
        );
      case EventType.callCreated:
        final event = callCreated!;
        final call = event.call;
        return CoordinatorCallCreatedEvent(
          data: CallCreatedData(
            callCid: StreamCallCid(cid: call.cid),
            metadata: call.toCallMetadata(members: event.members),
          ),
          createdAt: event.createdAt,
        );
      case EventType.callMissed:
        final event = callMissed!;
        final call = event.call;
        return CoordinatorCallMissedEvent(
          callCid: StreamCallCid(cid: call.cid),
          sessionId: event.sessionId,
          createdAt: event.createdAt,
          members: event.members.map((it) => it.toCallMember()).toList(),
          metadata: call.toCallMetadata(members: event.members),
          callUser: event.user.toCallUser(),
        );
      case EventType.callRing:
        final event = callRing!;
        final call = event.call;
        return CoordinatorCallRingingEvent(
          data: CallRingingData(
            callCid: StreamCallCid(cid: call.cid),
            ringing: true,
            metadata: call.toCallMetadata(members: event.members),
          ),
          sessionId: event.sessionId,
          createdAt: event.createdAt,
        );
      case EventType.callAccepted:
        final event = callAccepted!;
        final acceptedBy = event.user.toCallUser();
        return CoordinatorCallAcceptedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          acceptedBy: acceptedBy,
          createdAt: event.createdAt,
          metadata: event.call.toCallMetadata(),
          user: event.user.toCallUser(),
        );
      case EventType.callRejected:
        final event = callRejected!;
        return CoordinatorCallRejectedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          rejectedBy: event.user.toCallUser(),
          createdAt: event.createdAt,
          metadata: event.call.toCallMetadata(),
          user: event.user.toCallUser(),
        );
      case EventType.callUpdated:
        final event = callUpdated!;
        return CoordinatorCallUpdatedEvent(
          callCid: StreamCallCid(cid: event.call.cid),
          capabilitiesByRole: event.capabilitiesByRole,
          metadata: event.call.toCallMetadata(),
          createdAt: event.createdAt,
        );
      case EventType.callEnded:
        final event = callEnded!;
        final endedBy = event.user?.toCallUser();
        return CoordinatorCallEndedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          endedBy: endedBy,
          createdAt: event.createdAt,
        );
      case EventType.callSessionStarted:
        final event = callSessionStarted!;

        return CoordinatorCallSessionStartedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.call.toCallMetadata(),
        );
      case EventType.callSessionEnded:
        final event = callSessionEnded!;

        return CoordinatorCallSessionEndedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.call.toCallMetadata(),
        );
      case EventType.callSessionParticipantJoined:
        final event = callSessionParticipantJoined!;

        return CoordinatorCallSessionParticipantJoinedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.participant.user.toCallUser(),
          participant: event.participant.toCallParticipant(),
        );
      case EventType.callSessionParticipantLeft:
        final event = callSessionParticipantLeft!;

        return CoordinatorCallSessionParticipantLeftEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.participant.user.toCallUser(),
          participant: event.participant.toCallParticipant(),
        );
      case EventType.callSessionParticipantCountUpdated:
        final event = callSessionParticipantCountUpdated!;

        return CoordinatorCallSessionParticipantCountUpdatedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          anonymousParticipantCount: event.anonymousParticipantCount,
          participantsCountByRole: event.participantsCountByRole,
        );
      case EventType.callPermissionRequest:
        final event = callPermissionRequest!;
        return CoordinatorCallPermissionRequestEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          permissions: event.permissions.map(CallPermission.fromAlias).toList(),
          user: event.user.toCallUser(),
        );
      case EventType.callPermissionsUpdated:
        final event = callPermissionsUpdated!;
        return CoordinatorCallPermissionsUpdatedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          ownCapabilities: event.ownCapabilities.map(
            (it) => CallPermission.fromAlias(it.value),
          ),
          user: event.user.toCallUser(),
        );
      case EventType.callRecordingStarted:
        final event = callRecordingStarted!;

        return CoordinatorCallRecordingStartedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callRecordingStopped:
        final event = callRecordingStopped!;

        return CoordinatorCallRecordingStoppedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callRecordingFailed:
        final event = callRecordingFailed!;

        return CoordinatorCallRecordingFailedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callBroadcastingStarted:
        final event = callBroadcastingStarted!;
        return CoordinatorCallBroadcastingStartedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          hlsPlaylistUrl: event.hlsPlaylistUrl,
          createdAt: event.createdAt,
        );
      case EventType.callBroadcastingStopped:
        final event = callBroadcastingStopped!;
        return CoordinatorCallBroadcastingStoppedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callBroadcastingFailed:
        final event = callBroadcastingFailed!;
        return CoordinatorCallBroadcastingFailedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callLiveStarted:
        final event = callLiveStarted;
        // TODO: Handle this case.
        break;
      case EventType.callMemberAdded:
        final event = callMemberAdded;
        // TODO: Handle this case.
        break;
      case EventType.callMemberRemoved:
        final event = callMemberRemoved;
        // TODO: Handle this case.
        break;
      case EventType.callMemberUpdated:
        final event = callMemberUpdated;
        // TODO: Handle this case.
        break;
      case EventType.callMemberUpdatedPermission:
        final event = callMemberUpdatedPermission;
        // TODO: Handle this case.
        break;
      case EventType.callUserBlocked:
        final event = callUserBlocked!;

        return CoordinatorCallUserBlockedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          user: event.user.toCallUser(),
        );
      case EventType.callUserUnblocked:
        final event = callUserUnblocked!;

        return CoordinatorCallUserUnblockedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          user: event.user.toCallUser(),
        );
      case EventType.callReaction:
        final event = callReaction!;

        return CoordinatorCallReactionEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          reactionType: event.reaction.type,
          user: event.reaction.user.toCallUser(),
          emojiCode: event.reaction.emojiCode,
          custom: event.reaction.custom,
        );
      case EventType.callTranscriptionStarted:
        final event = callTranscriptionStarted!;
        return CoordinatorCallTranscriptionStartedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callTranscriptionStopped:
        final event = callTranscriptionStopped!;
        return CoordinatorCallTranscriptionStoppedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callTranscriptionFailed:
        final event = callTranscriptionFailed!;
        return CoordinatorCallTranscriptionFailedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
        );
      case EventType.callClosedCaption:
        final event = callClosedCaption!;
        return CoordinatorCallClosedCaptionEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          startTime: event.closedCaption.startTime,
          endTime: event.closedCaption.endTime,
          speakerId: event.closedCaption.speakerId,
          text: event.closedCaption.text,
        );
      case EventType.callNotification:
        // TODO: Handle event
        break;
      case EventType.callUserMuted:
        // TODO: Handle event
        break;
      case EventType.callRecordingReady:
        // TODO: Handle event
        break;
      case EventType.custom:
        final event = custom!;

        return CoordinatorCallCustomEvent(
          callCid: StreamCallCid(cid: event.callCid),
          senderUserId: event.user.id,
          createdAt: event.createdAt,
          eventType: event.type,
          custom: event.custom,
          users: {event.user.id: event.user.toCallUser()},
        );
      case EventType.unknown:
        return const CoordinatorUnknownEvent();
    }
    return const CoordinatorUnsupportedEvent();
  }
}
