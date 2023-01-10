import 'package:stream_video/protobuf/video/coordinator/call_v1/call.pb.dart'
    as coordinator_call;
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import 'package:stream_video/protobuf/video/coordinator/member_v1/member.pb.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/v2/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/v2/coordinator/ws/coordinator_events.dart';

/// Converts [coordinator.WebsocketEvent] into [CoordinatorEvent].
extension WebsocketEventMapperExt on coordinator.WebsocketEvent {
  /// Returns [CoordinatorEvent].
  CoordinatorEvent toEvent() {
    final eventType = whichEvent();
    switch (eventType) {
      case coordinator.WebsocketEvent_Event.healthcheck:
        return CoordinatorHealthCheckEvent(
          clientId: healthcheck.clientId,
          userId: healthcheck.userId,
        );
      case coordinator.WebsocketEvent_Event.callCreated:
        return CoordinatorCallCreatedEvent(
          callCid: callCreated.call.callCid,
          ringing: callCreated.ringing,
          info: callCreated.call.toCallInfo(),
          details: callCreated.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callUpdated:
        return CoordinatorCallUpdatedEvent(
          callCid: callUpdated.call.callCid,
          info: callUpdated.call.toCallInfo(),
          details: callUpdated.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callEnded:
        return CoordinatorCallEndedEvent(
          callCid: callEnded.call.callCid,
          info: callEnded.call.toCallInfo(),
          details: callEnded.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callAccepted:
        return CoordinatorCallAcceptedEvent(
          callCid: callAccepted.call.callCid,
          sentByUserId: callAccepted.senderUserId,
          info: callAccepted.call.toCallInfo(),
          details: callAccepted.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callRejected:
        return CoordinatorCallRejectedEvent(
          callCid: callRejected.call.callCid,
          sentByUserId: callRejected.senderUserId,
          info: callRejected.call.toCallInfo(),
          details: callRejected.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callCancelled:
        return CoordinatorCallCancelledEvent(
          callCid: callCancelled.call.callCid,
          sentByUserId: callCancelled.senderUserId,
          info: callCancelled.call.toCallInfo(),
          details: callCancelled.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callMembersUpdated:
        return CoordinatorCallMembersUpdatedEvent(
          callCid: callMembersUpdated.call.callCid,
          info: callMembersUpdated.call.toCallInfo(),
          details: callMembersUpdated.callDetails.toCallDetails(),
        );
      case coordinator.WebsocketEvent_Event.callMembersDeleted:
        return CoordinatorCallMembersDeletedEvent(
          callCid: callMembersDeleted.call.callCid,
          info: callMembersDeleted.call.toCallInfo(),
          details: callMembersDeleted.callDetails.toCallDetails(),
        );
      default:
        logger.warning('Unknown Video Event $eventType');
        return const CoordinatorUnknownEvent();
    }
  }
}

extension on coordinator_call.Call {
  CallInfo toCallInfo() {
    return CallInfo(
      cid: '$type:$id',
      id: id,
      type: type,
      createdByUserId: createdByUserId,
    );
  }
}

extension on coordinator_call.CallDetails {
  CallDetails toCallDetails() {
    return CallDetails(
      memberUserIds: memberUserIds,
      members: members.map((key, value) => MapEntry(key, value.toCallMember())),
      isBroadcastingEnabled: settings.broadcasting.enabled,
      isRecordingEnabled: settings.recording.enabled,
    );
  }
}

extension on Member {
  CallMember toCallMember() {
    return CallMember(callCid: callCid, userId: userId, role: role);
  }
}
