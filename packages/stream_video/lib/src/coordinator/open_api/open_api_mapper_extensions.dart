import '../../../open_api/video/coordinator/api.dart' as open;
import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../models/coordinator_events.dart';
import '../models/coordinator_inputs.dart';
import 'event/open_api_event.dart';
import 'open_api_extensions.dart';

const _tag = 'SV:OpenWsEventMapper';

extension WebsocketEventMapperExt on OpenApiEvent {
  /// Returns [CoordinatorEvent].
  CoordinatorEvent? toCoordinatorEvent() {
    if (healthCheck != null) {
      final healthCheck = this.healthCheck!;

      return CoordinatorHealthCheckEvent(
        clientId: healthCheck.connectionId!,
        userId: healthCheck.me?.id ?? '',
      );
    } else if (callCreated != null) {
      final callCreated = this.callCreated!;
      final call = callCreated.call;

      return CoordinatorCallCreatedEvent(
        callCid: call.cid,
        ringing: callCreated.ringing,
        createdAt: callCreated.createdAt,
        info: CallInfo(
          cid: StreamCallCid(cid: call.cid),
          createdByUserId: call.createdBy.id ?? '',
          createdAt: call.createdAt,
          updatedAt: call.updatedAt,
        ),
        details: CallDetails(
          isBroadcastingEnabled: call.settings.broadcasting.enabled,
          memberUserIds: callCreated.members.map((it) => it.userId).toList(),
          members: callCreated.members.toCallMembers(call.cid),
          isRecordingEnabled: call.settings.recording.audioOnly,
        ),
        users: callCreated.members.toCallUsers(),
      );
    } else if (callAccepted != null) {
      final callAccepted = this.callAccepted!;

      return CoordinatorCallAcceptedEvent(
        callCid: callAccepted.callCid,
        sentByUserId: callAccepted.user.id,
        createdAt: callAccepted.createdAt,
        info: CallInfo(
          cid: StreamCallCid(cid: callAccepted.callCid),
          createdByUserId: '',
        ),
        details: const CallDetails(
          isBroadcastingEnabled: false,
          memberUserIds: [],
          members: {},
          isRecordingEnabled: false,
        ),
        users: const {},
      );
    } else if (callRejected != null) {
      final callRejected = this.callRejected!;

      return CoordinatorCallRejectedEvent(
        callCid: callRejected.callCid,
        sentByUserId: callRejected.user.id,
        createdAt: callRejected.createdAt,
        info: CallInfo(
          cid: StreamCallCid(cid: callRejected.callCid),
          createdByUserId: '',
        ),
        details: const CallDetails(
          isBroadcastingEnabled: false,
          memberUserIds: [],
          members: {},
          isRecordingEnabled: false,
        ),
        users: const {},
      );
    } else if (callCancelled != null) {
      final callCancelled = this.callCancelled!;

      return CoordinatorCallCancelledEvent(
        callCid: callCancelled.callCid,
        sentByUserId: callCancelled.user.id,
        createdAt: callCancelled.createdAt,
        info: CallInfo(
          cid: StreamCallCid(cid: callCancelled.callCid),
          createdByUserId: '',
        ),
        details: const CallDetails(
          isBroadcastingEnabled: false,
          memberUserIds: [],
          members: {},
          isRecordingEnabled: false,
        ),
        users: const {},
      );
    } else if (callUpdated != null) {
      final callUpdated = this.callUpdated!;
      final call = callUpdated.call;

      return CoordinatorCallUpdatedEvent(
        callCid: call.cid,
        info: CallInfo(
          cid: StreamCallCid(cid: call.cid),
          createdByUserId: call.createdBy.id ?? '',
          createdAt: call.createdAt,
          updatedAt: call.updatedAt,
        ),
        details: CallDetails(
          isBroadcastingEnabled: call.settings.broadcasting.enabled,
          memberUserIds: const [],
          members: const {},
          isRecordingEnabled: call.settings.recording.audioOnly,
        ),
        users: const {},
      );
    } else if (callEnded != null) {
      final callEnded = this.callEnded!;

      return CoordinatorCallEndedEvent(
        callCid: callEnded.callCid,
        sentByUserId: callEnded.user.id,
        createdAt: callEnded.createdAt,
        info: CallInfo(
          cid: StreamCallCid(cid: callEnded.callCid),
          createdByUserId: '',
        ),
        details: const CallDetails(
          isBroadcastingEnabled: false,
          memberUserIds: [],
          members: {},
          isRecordingEnabled: false,
        ),
        users: const {},
      );
    } else if (callPermissionRequest != null) {
      final callPermissionRequest = this.callPermissionRequest!;

      // TODO support
    } else if (callPermissionsUpdated != null) {
      final callPermissionsUpdated = this.callPermissionsUpdated!;

      // TODO support
    } else if (custom != null) {
      final custom = this.custom!;

      return CoordinatorCallCustomEvent(
        callCid: custom.callCid,
        senderUserId: custom.user.id,
        createdAt: custom.createdAt,
        type: custom.type,
        customJson: custom.custom,
        info: CallInfo(
          cid: StreamCallCid(cid: custom.callCid),
          createdByUserId: '',
        ),
        details: const CallDetails(
          isBroadcastingEnabled: false,
          memberUserIds: [],
          members: {},
          isRecordingEnabled: false,
        ),
        users: {custom.user.id: custom.user.toCallUser()},
      );
    }
    return null;
  }
}

extension MemberExt on MemberInput {
  open.MemberRequest toOpenDto() {
    return open.MemberRequest(
      userId: userId,
      role: role ?? '',
    );
  }
}

extension MemberListExt on Iterable<MemberInput> {
  List<open.MemberRequest> toOpenDto() {
    return map((it) => it.toOpenDto()).toList();
  }
}
