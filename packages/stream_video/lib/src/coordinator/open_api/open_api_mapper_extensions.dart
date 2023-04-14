import 'package:collection/collection.dart';

import '../../../open_api/video/coordinator/api.dart' as open;
import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';
import '../../models/call_setting.dart';
import '../../utils/standard.dart';
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
      case EventType.connectionOk:
        final event = this.connected!;
        return CoordinatorConnectedEvent(
          clientId: event.connectionId,
          userId: event.me.id,
        );
      case EventType.healthCheck:
        final healthCheck = this.healthCheck!;

        return CoordinatorHealthCheckEvent(
          clientId: healthCheck.connectionId,
        );
      case EventType.callCreated:
        final callCreated = this.callCreated!;
        final call = callCreated.call;
        final createdBy = call.createdBy.toCallUser();
        final createdByMember = call.createdBy.toCallMember();

        return CoordinatorCallCreatedEvent(
          callCid: StreamCallCid(cid: call.cid),
          ringing: callCreated.ringing,
          createdAt: callCreated.createdAt,
          info: CallInfo(
            cid: StreamCallCid(cid: call.cid),
            createdBy: createdBy,
            createdAt: call.createdAt,
            updatedAt: call.updatedAt,
          ),
          details: CallDetails(
            isBroadcastingEnabled: call.settings.broadcasting.enabled,
            members: {
              createdByMember.userId: createdByMember,
              ...callCreated.members.toCallMembers(),
            },
            isRecordingEnabled: call.settings.recording.audioOnly,
            ownCapabilities: call.ownCapabilities.map(
              (it) => CallPermission.fromAlias(it.value),
            ),
            settings: call.settings.toCallSettings(),
          ),
          users: {
            createdBy.id: createdBy,
            ...callCreated.members.toCallUsers(),
          },
        );
      case EventType.callAccepted:
        final callAccepted = this.callAccepted!;
        final acceptedBy = callAccepted.user.toCallUser();
        return CoordinatorCallAcceptedEvent(
          callCid: StreamCallCid(cid: callAccepted.callCid),
          acceptedBy: acceptedBy,
          createdAt: callAccepted.createdAt,
          users: {acceptedBy.id: acceptedBy},
        );
      case EventType.callRejected:
        final callRejected = this.callRejected!;
        final rejectedBy = callRejected.user.toCallUser();
        return CoordinatorCallRejectedEvent(
          callCid: StreamCallCid(cid: callRejected.callCid),
          rejectedBy: rejectedBy,
          createdAt: callRejected.createdAt,
          users: {rejectedBy.id: rejectedBy},
        );
      case EventType.callUpdated:
        final callUpdated = this.callUpdated!;
        final call = callUpdated.call;
        final createdBy = call.createdBy.toCallUser();
        return CoordinatorCallUpdatedEvent(
          callCid: StreamCallCid(cid: call.cid),
          info: CallInfo(
            cid: StreamCallCid(cid: call.cid),
            createdBy: createdBy,
            createdAt: call.createdAt,
            updatedAt: call.updatedAt,
          ),
          details: CallDetails(
            isBroadcastingEnabled: call.settings.broadcasting.enabled,
            members: const {},
            isRecordingEnabled: call.settings.recording.audioOnly,
            ownCapabilities: call.ownCapabilities.map(
              (it) => CallPermission.fromAlias(it.value),
            ),
            settings: call.settings.toCallSettings(),
          ),
          users: {createdBy.id: createdBy},
        );
      case EventType.callEnded:
        final callEnded = this.callEnded!;
        final endedBy = callEnded.user?.toCallUser();
        return CoordinatorCallEndedEvent(
          callCid: StreamCallCid(cid: callEnded.callCid),
          endedBy: endedBy,
          createdAt: callEnded.createdAt,
          users: {
            ...?endedBy?.let((it) => {it.id: it})
          },
        );
      case EventType.callPermissionRequest:
        final callPermissionRequest = this.callPermissionRequest!;

        return CoordinatorCallPermissionRequestEvent(
          callCid: StreamCallCid(cid: callPermissionRequest.callCid),
          createdAt: callPermissionRequest.createdAt,
          permissions: callPermissionRequest.permissions,
          user: callPermissionRequest.user.toCallUser(),
        );
      case EventType.callPermissionsUpdated:
        final callPermissionsUpdated = this.callPermissionsUpdated!;

        return CoordinatorCallPermissionsUpdatedEvent(
          callCid: StreamCallCid(cid: callPermissionsUpdated.callCid),
          createdAt: callPermissionsUpdated.createdAt,
          ownCapabilities: callPermissionsUpdated.ownCapabilities.map(
            (it) => CallPermission.fromAlias(it.value),
          ),
          user: callPermissionsUpdated.user.toCallUser(),
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
      case EventType.custom:
        final custom = this.custom!;

        return CoordinatorCallCustomEvent(
          callCid: StreamCallCid(cid: custom.callCid),
          senderUserId: custom.user.id,
          createdAt: custom.createdAt,
          eventType: custom.type,
          custom: custom.custom,
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
      direction: direction.toOpenDto(),
      field: field,
    );
  }
}

extension on DirectionInput {
  int toOpenDto() {
    switch (this) {
      case DirectionInput.asc:
        return 1;
      case DirectionInput.desc:
        return -1;
    }
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
    // TODO
    return open.RecordSettingsRequest(
      audioOnly: audioOnly,
      mode: open.RecordSettingsRequestModeEnum.values.firstWhereOrNull(
        (it) => it.value == mode,
      ),
      quality: open.RecordSettingsRequestQualityEnum.values.firstWhereOrNull(
        (it) => it.value == quality,
      ),
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
