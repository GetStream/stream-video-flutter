import 'package:stream_video/protobuf/video/coordinator/call_v1/call.pb.dart'
    as coordinator_call;
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator_ws;
import 'package:stream_video/protobuf/video/coordinator/member_v1/member.pb.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/v2/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/v2/coordinator/ws/coordinator_events.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart'
    as coordinator_envelopes;

/// Converts [coordinator_ws.WebsocketEvent] into [CoordinatorEventV2].
extension WebsocketEventMapperExt on coordinator_ws.WebsocketEvent {
  /// Returns [CoordinatorEventV2].
  CoordinatorEventV2 toEvent() {
    final eventType = whichEvent();
    switch (eventType) {
      case coordinator_ws.WebsocketEvent_Event.healthcheck:
        return CoordinatorHealthCheckEvent(
          clientId: healthcheck.clientId,
          userId: healthcheck.userId,
        );
      case coordinator_ws.WebsocketEvent_Event.callCreated:
        return CoordinatorCallCreatedEvent(
          callCid: callCreated.call.callCid,
          ringing: callCreated.ringing,
          info: callCreated.call.toCallInfo(),
          details: callCreated.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callUpdated:
        return CoordinatorCallUpdatedEvent(
          callCid: callUpdated.call.callCid,
          info: callUpdated.call.toCallInfo(),
          details: callUpdated.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callEnded:
        return CoordinatorCallEndedEvent(
          callCid: callEnded.call.callCid,
          info: callEnded.call.toCallInfo(),
          details: callEnded.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callAccepted:
        return CoordinatorCallAcceptedEvent(
          callCid: callAccepted.call.callCid,
          sentByUserId: callAccepted.senderUserId,
          info: callAccepted.call.toCallInfo(),
          details: callAccepted.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callRejected:
        return CoordinatorCallRejectedEvent(
          callCid: callRejected.call.callCid,
          sentByUserId: callRejected.senderUserId,
          info: callRejected.call.toCallInfo(),
          details: callRejected.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callCancelled:
        return CoordinatorCallCancelledEvent(
          callCid: callCancelled.call.callCid,
          sentByUserId: callCancelled.senderUserId,
          info: callCancelled.call.toCallInfo(),
          details: callCancelled.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callMembersUpdated:
        return CoordinatorCallMembersUpdatedEvent(
          callCid: callMembersUpdated.call.callCid,
          info: callMembersUpdated.call.toCallInfo(),
          details: callMembersUpdated.callDetails.toCallDetails(),
        );
      case coordinator_ws.WebsocketEvent_Event.callMembersDeleted:
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
    // TODO users map is missing in proto model
    return CallInfo(
      cid: '$type:$id',
      id: id,
      type: type,
      createdByUserId: createdByUserId,
      createdAt: createdAt.toDateTime(),
      updatedAt: updatedAt.toDateTime(),
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

extension Envelope on coordinator_envelopes.CallEnvelope {
  CallMetadata toCallMetadata({required bool ringing, required bool created}) {
    return CallMetadata(
      createdByMe: created,
      ringing: ringing,
      details: details.toCallDetails(),
      info: call.toCallInfo(),
    );
  }
}
