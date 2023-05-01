import 'package:collection/collection.dart';

import '../../../open_api/video/coordinator/api.dart' as open;
import '../../models/call_cid.dart';
import '../../models/call_created_data.dart';
import '../../models/call_permission.dart';
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
        final event = connected!;
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
        final event = callCreated!;
        final call = event.call;
        return CoordinatorCallCreatedEvent(
          data: CallCreatedData(
            callCid: StreamCallCid(cid: call.cid),
            ringing: event.ringing,
            metadata: call.toCallMetadata(event.members),
          ),
          createdAt: event.createdAt,
        );
      case EventType.callAccepted:
        final event = callAccepted!;
        final acceptedBy = event.user.toCallUser();
        return CoordinatorCallAcceptedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          acceptedBy: acceptedBy,
          createdAt: event.createdAt,
        );
      case EventType.callRejected:
        final event = callRejected!;
        return CoordinatorCallRejectedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          rejectedBy: event.user.toCallUser(),
          createdAt: event.createdAt,
        );
      case EventType.callUpdated:
        final event = callUpdated!;
        return CoordinatorCallUpdatedEvent(
          callCid: StreamCallCid(cid: event.call.cid),
          capabilitiesByRole: Map.unmodifiable(event.capabilitiesByRole),
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
      case EventType.callPermissionRequest:
        final event = callPermissionRequest!;
        return CoordinatorCallPermissionRequestEvent(
          callCid: StreamCallCid(cid: event.callCid),
          createdAt: event.createdAt,
          permissions: event.permissions,
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
