import 'dart:convert';

import '../../../../protobuf/video/coordinator/call_v1/call.pb.dart'
    as coordinator_call;
import '../../../../protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart'
    as coordinator_envelopes;
import '../../../../protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator_ws;
import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart'
    as coord_edge;
import '../../../../protobuf/video/coordinator/member_v1/member.pb.dart';
import '../../../../protobuf/video/coordinator/user_v1/user.pb.dart'
    as coord_users;
import '../../../logger/logger.dart';
import '../../model/call_cid.dart';
import '../../utils/result.dart';
import '../models/coordinator_models.dart';
import 'coordinator_events.dart';

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
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callUpdated:
        return CoordinatorCallUpdatedEvent(
          callCid: callUpdated.call.callCid,
          info: callUpdated.call.toCallInfo(),
          details: callUpdated.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callEnded:
        return CoordinatorCallEndedEvent(
          callCid: callEnded.call.callCid,
          info: callEnded.call.toCallInfo(),
          details: callEnded.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callAccepted:
        return CoordinatorCallAcceptedEvent(
          callCid: callAccepted.call.callCid,
          sentByUserId: callAccepted.senderUserId,
          info: callAccepted.call.toCallInfo(),
          details: callAccepted.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callRejected:
        return CoordinatorCallRejectedEvent(
          callCid: callRejected.call.callCid,
          sentByUserId: callRejected.senderUserId,
          info: callRejected.call.toCallInfo(),
          details: callRejected.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callCancelled:
        return CoordinatorCallCancelledEvent(
          callCid: callCancelled.call.callCid,
          sentByUserId: callCancelled.senderUserId,
          info: callCancelled.call.toCallInfo(),
          details: callCancelled.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callMembersUpdated:
        return CoordinatorCallMembersUpdatedEvent(
          callCid: callMembersUpdated.call.callCid,
          info: callMembersUpdated.call.toCallInfo(),
          details: callMembersUpdated.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callMembersDeleted:
        return CoordinatorCallMembersDeletedEvent(
          callCid: callMembersDeleted.call.callCid,
          info: callMembersDeleted.call.toCallInfo(),
          details: callMembersDeleted.callDetails.toCallDetails(),
          users: users.toCallUsers(),
        );
      case coordinator_ws.WebsocketEvent_Event.callCustom:
        return CoordinatorCallCustomEvent(
          callCid: callCustom.call.callCid,
          type: callCustom.type,
          senderUserId: callCustom.senderUserId,
          info: callCustom.call.toCallInfo(),
          details: callCustom.callDetails.toCallDetails(),
          users: users.toCallUsers(),
          customJson: utf8.decode(callCustom.dataJson),
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
      cid: StreamCallCid.from(type: type, id: id),
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

extension MemberExt on Member {
  CallMember toCallMember() {
    return CallMember(callCid: callCid, userId: userId, role: role);
  }
}

extension EnvelopeExt on coordinator_envelopes.CallEnvelope {
  CallMetadata toCallMetadata() {
    return CallMetadata(
      details: details.toCallDetails(),
      info: call.toCallInfo(),
      users: users.map((key, value) => MapEntry(key, value.toCallUser())),
    );
  }
}

extension CredentialsExt on coord_edge.Credentials {
  CallCredentials toCallCredentials() {
    return CallCredentials(
      sfuToken: token,
      sfuServer: CallSfuServer(
        url: server.url,
        name: server.edgeName,
      ),
      iceServers: iceServers
          .map(
            (it) => CallIceServer(
              username: it.username,
              password: it.password,
              urls: it.urls,
            ),
          )
          .toList(),
    );
  }
}

extension UserExt on coord_users.User {
  CallUser toCallUser() {
    return CallUser(
      id: id,
      teams: teams,
      role: role,
      name: name,
      imageUrl: imageUrl,
      createdAt: createdAt.toDateTime(),
      updatedAt: updatedAt.toDateTime(),
      customJson: utf8.decode(customJson),
    );
  }
}

extension UserListExt on List<coord_users.User> {
  List<CallUser> toCallUsers() {
    return map((it) => it.toCallUser()).toList();
  }
}

extension UserMapExt on Map<String, coord_users.User> {
  Map<String, CallUser> toCallUsers() {
    return map((key, value) => MapEntry(key, value.toCallUser()));
  }
}
