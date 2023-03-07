import '../../../open_api/video/coordinator/api.dart' as open;
import '../../call_permission.dart';
import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../../models/call_setting.dart';
import '../models/coordinator_events.dart';
import '../models/coordinator_inputs.dart';
import 'event/event_type.dart';
import 'event/open_api_event.dart';
import 'open_api_extensions.dart';

const _tag = 'SV:OpenWsEventMapper';

extension WebsocketEventMapperExt on OpenApiEvent {
  /// Returns [CoordinatorEvent].
  CoordinatorEvent? toCoordinatorEvent() {
    switch (type) {
      case EventType.healthCheck:
        final healthCheck = this.healthCheck!;

        return CoordinatorHealthCheckEvent(
          clientId: healthCheck.connectionId!,
          userId: healthCheck.me?.id ?? '',
        );
      case EventType.callCreated:
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
            members: callCreated.members.toCallMembers(call.cid),
            isRecordingEnabled: call.settings.recording.audioOnly,
            ownCapabilities: call.ownCapabilities.map(CallPermission.fromAlias),
            settings: call.settings.toCallSettings(),
          ),
          users: callCreated.members.toCallUsers(),
        );
      case EventType.callAccepted:
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
            members: {},
            isRecordingEnabled: false,
            ownCapabilities: [],
            settings: CallSettings.disabled(),
          ),
          users: const {},
        );
      case EventType.callRejected:
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
            members: {},
            isRecordingEnabled: false,
            ownCapabilities: [],
            settings: CallSettings.disabled(),
          ),
          users: const {},
        );
      case EventType.callCancelled:
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
            members: {},
            isRecordingEnabled: false,
            ownCapabilities: [],
            settings: CallSettings.disabled(),
          ),
          users: const {},
        );
      case EventType.callUpdated:
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
            members: const {},
            isRecordingEnabled: call.settings.recording.audioOnly,
            ownCapabilities: call.ownCapabilities.map(CallPermission.fromAlias),
            settings: call.settings.toCallSettings(),
          ),
          users: const {},
        );
      case EventType.callEnded:
        final callEnded = this.callEnded!;

        return CoordinatorCallEndedEvent(
          callCid: callEnded.callCid,
          sentByUserId: callEnded.user?.id ?? '',
          createdAt: callEnded.createdAt,
          info: CallInfo(
            cid: StreamCallCid(cid: callEnded.callCid),
            createdByUserId: '',
          ),
          details: const CallDetails(
            isBroadcastingEnabled: false,
            members: {},
            isRecordingEnabled: false,
            ownCapabilities: [],
            settings: CallSettings.disabled(),
          ),
          users: const {},
        );
      case EventType.callPermissionRequest:
        final callPermissionRequest = this.callPermissionRequest!;

        return CoordinatorCallPermissionRequestEvent(
          callCid: callPermissionRequest.callCid,
          createdAt: callPermissionRequest.createdAt,
          permissions: callPermissionRequest.permissions,
          user: callPermissionRequest.user.toCallUser(),
        );
      case EventType.callPermissionsUpdated:
        final callPermissionsUpdated = this.callPermissionsUpdated!;

        return CoordinatorCallPermissionsUpdatedEvent(
          callCid: callPermissionsUpdated.callCid,
          createdAt: callPermissionsUpdated.createdAt,
          ownCapabilities: callPermissionsUpdated.ownCapabilities
              .map(CallPermission.fromAlias),
          user: callPermissionsUpdated.user.toCallUser(),
        );
      case EventType.callRecordingStarted:
        final event = callRecordingStarted!;

        return CoordinatorCallRecordingStartedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
        );
      case EventType.callRecordingStopped:
        final event = callRecordingStopped!;

        return CoordinatorCallRecordingStoppedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
        );
      case EventType.callUserBlocked:
        final event = callUserBlocked!;

        return CoordinatorCallUserBlockedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          userId: event.userId,
        );
      case EventType.callUserUnblocked:
        final event = callUserUnblocked!;

        return CoordinatorCallUserUnblockedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          userId: event.userId,
        );
      case EventType.callReaction:
        final event = callReaction!;

        return CoordinatorCallReactionEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          reactionType: event.reaction.type,
          user: event.reaction.user.toCallUser(),
          emojiCode: event.reaction.emojiCode,
          custom: event.reaction.custom,
        );
      case EventType.custom:
        final custom = this.custom!;

        return CoordinatorCallCustomEvent(
          callCid: custom.callCid,
          senderUserId: custom.user.id,
          createdAt: custom.createdAt,
          eventType: custom.type,
          custom: custom.custom,
          info: CallInfo(
            cid: StreamCallCid(cid: custom.callCid),
            createdByUserId: '',
          ),
          details: const CallDetails(
            isBroadcastingEnabled: false,
            members: {},
            isRecordingEnabled: false,
            ownCapabilities: [],
            settings: CallSettings.disabled(),
          ),
          users: {custom.user.id: custom.user.toCallUser()},
        );
      case EventType.unknown:
        return const CoordinatorUnknownEvent();
    }
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

extension SortExt on SortInput {
  open.SortParamRequest toOpenDto() {
    return open.SortParamRequest(
      //TODO
      direction: 1,
      field: field,
    );
  }
}

extension MemberListExt on Iterable<MemberInput> {
  List<open.MemberRequest> toOpenDto() {
    return map((it) => it.toOpenDto()).toList();
  }
}

extension SortListExt on Iterable<SortInput> {
  List<open.SortParamRequest> toOpenDto() {
    return map((it) => it.toOpenDto()).toList();
  }
}

extension CallSettingsInputExt on CallSettingsInput {
  open.CallSettingsRequest toOpenDto() {
    return open.CallSettingsRequest(
      video: video?.toOpenDto(),
      screensharing: screensharing?.toOpenDto(),
      recording: recording?.toOpenDto(),
      geofencing: geofencing?.toOpenDto(),
    );
  }
}

extension on VideoSettingsInput {
  open.VideoSettingsRequest toOpenDto() {
    return open.VideoSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
    );
  }
}

extension on ScreensharingSettingsInput {
  open.ScreensharingSettingsRequest toOpenDto() {
    return open.ScreensharingSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
    );
  }
}

extension on RecordSettingsInput {
  open.RecordSettingsRequest toOpenDto() {
    return open.RecordSettingsRequest(
      audioOnly: audioOnly,
      mode: mode,
      quality: quality,
    );
  }
}

extension on GeofenceSettingsInput {
  open.GeofenceSettingsRequest toOpenDto() {
    return open.GeofenceSettingsRequest(
      names: names,
    );
  }
}
