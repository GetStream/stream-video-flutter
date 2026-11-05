// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdatedEvent _$AppUpdatedEventFromJson(Map<String, dynamic> json) =>
    AppUpdatedEvent(
      app: AppEventResponse.fromJson(json['app'] as Map<String, dynamic>),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$AppUpdatedEventToJson(AppUpdatedEvent instance) =>
    <String, dynamic>{
      'app': instance.app.toJson(),
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'type': instance.type,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

BlockedUserEvent _$BlockedUserEventFromJson(Map<String, dynamic> json) =>
    BlockedUserEvent(
      blockedByUser: json['blocked_by_user'] == null
          ? null
          : UserResponse.fromJson(
              json['blocked_by_user'] as Map<String, dynamic>,
            ),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockedUserEventToJson(BlockedUserEvent instance) =>
    <String, dynamic>{
      'blocked_by_user': instance.blockedByUser?.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

CallAcceptedEvent _$CallAcceptedEventFromJson(Map<String, dynamic> json) =>
    CallAcceptedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallAcceptedEventToJson(CallAcceptedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

CallClosedCaptionsFailedEvent _$CallClosedCaptionsFailedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsFailedEventToJson(
  CallClosedCaptionsFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallClosedCaptionsStartedEvent _$CallClosedCaptionsStartedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsStartedEventToJson(
  CallClosedCaptionsStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallClosedCaptionsStoppedEvent _$CallClosedCaptionsStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsStoppedEventToJson(
  CallClosedCaptionsStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallCreatedEvent _$CallCreatedEventFromJson(Map<String, dynamic> json) =>
    CallCreatedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallCreatedEventToJson(CallCreatedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };

CallDeletedEvent _$CallDeletedEventFromJson(Map<String, dynamic> json) =>
    CallDeletedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallDeletedEventToJson(CallDeletedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };

CallDTMFEvent _$CallDTMFEventFromJson(Map<String, dynamic> json) =>
    CallDTMFEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      digit: json['digit'] as String,
      durationMs: (json['duration_ms'] as num).toInt(),
      seqNumber: (json['seq_number'] as num).toInt(),
      timestamp: const StreamDateTimeConverter().fromJson(
        json['timestamp'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallDTMFEventToJson(CallDTMFEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'digit': instance.digit,
      'duration_ms': instance.durationMs,
      'seq_number': instance.seqNumber,
      'timestamp': const StreamDateTimeConverter().toJson(instance.timestamp),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

CallEndedEvent _$CallEndedEventFromJson(Map<String, dynamic> json) =>
    CallEndedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      reason: json['reason'] as String?,
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallEndedEventToJson(CallEndedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members?.map((e) => e.toJson()).toList(),
      'reason': instance.reason,
      'type': instance.type,
      'user': instance.user?.toJson(),
    };

CallFrameRecordingFailedEvent _$CallFrameRecordingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingFailedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallFrameRecordingFailedEventToJson(
  CallFrameRecordingFailedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallFrameRecordingFrameReadyEvent _$CallFrameRecordingFrameReadyEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingFrameReadyEvent(
  callCid: json['call_cid'] as String,
  capturedAt: const StreamDateTimeConverter().fromJson(
    json['captured_at'] as Object,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  sessionId: json['session_id'] as String,
  trackType: json['track_type'] as String,
  type: json['type'] as String,
  url: json['url'] as String,
  users: (json['users'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, UserResponse.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$CallFrameRecordingFrameReadyEventToJson(
  CallFrameRecordingFrameReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'captured_at': const StreamDateTimeConverter().toJson(instance.capturedAt),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'session_id': instance.sessionId,
  'track_type': instance.trackType,
  'type': instance.type,
  'url': instance.url,
  'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
};

CallFrameRecordingStartedEvent _$CallFrameRecordingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallFrameRecordingStartedEventToJson(
  CallFrameRecordingStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallFrameRecordingStoppedEvent _$CallFrameRecordingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingStoppedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallFrameRecordingStoppedEventToJson(
  CallFrameRecordingStoppedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallHLSBroadcastingFailedEvent _$CallHLSBroadcastingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingFailedEventToJson(
  CallHLSBroadcastingFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallHLSBroadcastingStartedEvent _$CallHLSBroadcastingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  hlsPlaylistUrl: json['hls_playlist_url'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingStartedEventToJson(
  CallHLSBroadcastingStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'hls_playlist_url': instance.hlsPlaylistUrl,
  'type': instance.type,
};

CallHLSBroadcastingStoppedEvent _$CallHLSBroadcastingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingStoppedEventToJson(
  CallHLSBroadcastingStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallLiveStartedEvent _$CallLiveStartedEventFromJson(
  Map<String, dynamic> json,
) => CallLiveStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallLiveStartedEventToJson(
  CallLiveStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};

CallMemberAddedEvent _$CallMemberAddedEventFromJson(
  Map<String, dynamic> json,
) => CallMemberAddedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberAddedEventToJson(
  CallMemberAddedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'type': instance.type,
};

CallMemberRemovedEvent _$CallMemberRemovedEventFromJson(
  Map<String, dynamic> json,
) => CallMemberRemovedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberRemovedEventToJson(
  CallMemberRemovedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members,
  'type': instance.type,
};

CallMemberUpdatedEvent _$CallMemberUpdatedEventFromJson(
  Map<String, dynamic> json,
) => CallMemberUpdatedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberUpdatedEventToJson(
  CallMemberUpdatedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'type': instance.type,
};

CallMemberUpdatedPermissionEvent _$CallMemberUpdatedPermissionEventFromJson(
  Map<String, dynamic> json,
) => CallMemberUpdatedPermissionEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  capabilitiesByRole: _capabilitiesByRoleFromJson(
    json['capabilities_by_role'] as Map<String, dynamic>,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberUpdatedPermissionEventToJson(
  CallMemberUpdatedPermissionEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'capabilities_by_role': instance.capabilitiesByRole,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'type': instance.type,
};

CallMissedEvent _$CallMissedEventFromJson(Map<String, dynamic> json) =>
    CallMissedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      notifyUser: json['notify_user'] as bool,
      sessionId: json['session_id'] as String,
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallMissedEventToJson(CallMissedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'notify_user': instance.notifyUser,
      'session_id': instance.sessionId,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

CallModerationBlurEvent _$CallModerationBlurEventFromJson(
  Map<String, dynamic> json,
) => CallModerationBlurEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallModerationBlurEventToJson(
  CallModerationBlurEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'type': instance.type,
  'user_id': instance.userId,
};

CallModerationWarningEvent _$CallModerationWarningEventFromJson(
  Map<String, dynamic> json,
) => CallModerationWarningEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] as String,
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallModerationWarningEventToJson(
  CallModerationWarningEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message,
  'type': instance.type,
  'user_id': instance.userId,
};

CallNotificationEvent _$CallNotificationEventFromJson(
  Map<String, dynamic> json,
) => CallNotificationEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallNotificationEventToJson(
  CallNotificationEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'session_id': instance.sessionId,
  'type': instance.type,
  'user': instance.user.toJson(),
};

CallReactionEvent _$CallReactionEventFromJson(Map<String, dynamic> json) =>
    CallReactionEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      reaction: VideoReactionResponse.fromJson(
        json['reaction'] as Map<String, dynamic>,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallReactionEventToJson(CallReactionEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'reaction': instance.reaction.toJson(),
      'type': instance.type,
    };

CallRecordingFailedEvent _$CallRecordingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: json['recording_type'] as RecordingType,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingFailedEventToJson(
  CallRecordingFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType,
  'type': instance.type,
};

CallRecordingReadyEvent _$CallRecordingReadyEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingReadyEvent(
  callCid: json['call_cid'] as String,
  callRecording: CallRecording.fromJson(
    json['call_recording'] as Map<String, dynamic>,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: json['recording_type'] as RecordingType,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingReadyEventToJson(
  CallRecordingReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'call_recording': instance.callRecording.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType,
  'type': instance.type,
};

CallRecordingStartedEvent _$CallRecordingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: json['recording_type'] as RecordingType,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStartedEventToJson(
  CallRecordingStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType,
  'type': instance.type,
};

CallRecordingStoppedEvent _$CallRecordingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: json['recording_type'] as RecordingType,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStoppedEventToJson(
  CallRecordingStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType,
  'type': instance.type,
};

CallRejectedEvent _$CallRejectedEventFromJson(Map<String, dynamic> json) =>
    CallRejectedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      reason: json['reason'] as String?,
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallRejectedEventToJson(CallRejectedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'reason': instance.reason,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

CallRingEvent _$CallRingEventFromJson(Map<String, dynamic> json) =>
    CallRingEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      ringId: json['ring_id'] as String?,
      sessionId: json['session_id'] as String,
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      video: json['video'] as bool,
    );

Map<String, dynamic> _$CallRingEventToJson(CallRingEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'ring_id': instance.ringId,
      'session_id': instance.sessionId,
      'type': instance.type,
      'user': instance.user.toJson(),
      'video': instance.video,
    };

CallRtmpBroadcastFailedEvent _$CallRtmpBroadcastFailedEventFromJson(
  Map<String, dynamic> json,
) => CallRtmpBroadcastFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  name: json['name'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRtmpBroadcastFailedEventToJson(
  CallRtmpBroadcastFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'name': instance.name,
  'type': instance.type,
};

CallRtmpBroadcastStartedEvent _$CallRtmpBroadcastStartedEventFromJson(
  Map<String, dynamic> json,
) => CallRtmpBroadcastStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  name: json['name'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRtmpBroadcastStartedEventToJson(
  CallRtmpBroadcastStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'name': instance.name,
  'type': instance.type,
};

CallRtmpBroadcastStoppedEvent _$CallRtmpBroadcastStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallRtmpBroadcastStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  name: json['name'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRtmpBroadcastStoppedEventToJson(
  CallRtmpBroadcastStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'name': instance.name,
  'type': instance.type,
};

CallSessionEndedEvent _$CallSessionEndedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionEndedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionEndedEventToJson(
  CallSessionEndedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallSessionParticipantCountsUpdatedEvent
_$CallSessionParticipantCountsUpdatedEventFromJson(Map<String, dynamic> json) =>
    CallSessionParticipantCountsUpdatedEvent(
      anonymousParticipantCount: (json['anonymous_participant_count'] as num)
          .toInt(),
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      participantsCountByRole: Map<String, int>.from(
        json['participants_count_by_role'] as Map,
      ),
      sessionId: json['session_id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallSessionParticipantCountsUpdatedEventToJson(
  CallSessionParticipantCountsUpdatedEvent instance,
) => <String, dynamic>{
  'anonymous_participant_count': instance.anonymousParticipantCount,
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'participants_count_by_role': instance.participantsCountByRole,
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallSessionParticipantJoinedEvent _$CallSessionParticipantJoinedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionParticipantJoinedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  participant: CallParticipantResponse.fromJson(
    json['participant'] as Map<String, dynamic>,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionParticipantJoinedEventToJson(
  CallSessionParticipantJoinedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'participant': instance.participant.toJson(),
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallSessionParticipantLeftEvent _$CallSessionParticipantLeftEventFromJson(
  Map<String, dynamic> json,
) => CallSessionParticipantLeftEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  durationSeconds: (json['duration_seconds'] as num).toInt(),
  participant: CallParticipantResponse.fromJson(
    json['participant'] as Map<String, dynamic>,
  ),
  reason: json['reason'] as String?,
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionParticipantLeftEventToJson(
  CallSessionParticipantLeftEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'duration_seconds': instance.durationSeconds,
  'participant': instance.participant.toJson(),
  'reason': instance.reason,
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallSessionStartedEvent _$CallSessionStartedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionStartedEventToJson(
  CallSessionStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallStatsReportReadyEvent _$CallStatsReportReadyEventFromJson(
  Map<String, dynamic> json,
) => CallStatsReportReadyEvent(
  callCid: json['call_cid'] as String,
  counts: CallStatsParticipantCounts.fromJson(
    json['counts'] as Map<String, dynamic>,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  isTrimmed: json['is_trimmed'] as bool?,
  participantsOverview: (json['participants_overview'] as List<dynamic>?)
      ?.map((e) => CallStatsParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallStatsReportReadyEventToJson(
  CallStatsReportReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'counts': instance.counts.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'is_trimmed': instance.isTrimmed,
  'participants_overview': instance.participantsOverview
      ?.map((e) => e.toJson())
      .toList(),
  'session_id': instance.sessionId,
  'type': instance.type,
};

CallTranscriptionFailedEvent _$CallTranscriptionFailedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  error: json['error'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionFailedEventToJson(
  CallTranscriptionFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'error': instance.error,
  'type': instance.type,
};

CallTranscriptionReadyEvent _$CallTranscriptionReadyEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionReadyEvent(
  callCid: json['call_cid'] as String,
  callTranscription: CallTranscription.fromJson(
    json['call_transcription'] as Map<String, dynamic>,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionReadyEventToJson(
  CallTranscriptionReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'call_transcription': instance.callTranscription.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallTranscriptionStartedEvent _$CallTranscriptionStartedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionStartedEventToJson(
  CallTranscriptionStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallTranscriptionStoppedEvent _$CallTranscriptionStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionStoppedEventToJson(
  CallTranscriptionStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};

CallUpdatedEvent _$CallUpdatedEventFromJson(Map<String, dynamic> json) =>
    CallUpdatedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      capabilitiesByRole: _capabilitiesByRoleFromJson(
        json['capabilities_by_role'] as Map<String, dynamic>,
      ),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallUpdatedEventToJson(CallUpdatedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'capabilities_by_role': instance.capabilitiesByRole,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };

CallUserFeedbackSubmittedEvent _$CallUserFeedbackSubmittedEventFromJson(
  Map<String, dynamic> json,
) => CallUserFeedbackSubmittedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>?,
  rating: (json['rating'] as num).toInt(),
  reason: json['reason'] as String?,
  sdk: json['sdk'] as String?,
  sdkVersion: json['sdk_version'] as String?,
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallUserFeedbackSubmittedEventToJson(
  CallUserFeedbackSubmittedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'rating': instance.rating,
  'reason': instance.reason,
  'sdk': instance.sdk,
  'sdk_version': instance.sdkVersion,
  'session_id': instance.sessionId,
  'type': instance.type,
  'user': instance.user.toJson(),
};

CallUserMutedEvent _$CallUserMutedEventFromJson(Map<String, dynamic> json) =>
    CallUserMutedEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      fromUserId: json['from_user_id'] as String,
      mutedUserIds: (json['muted_user_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      reason: json['reason'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallUserMutedEventToJson(CallUserMutedEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'from_user_id': instance.fromUserId,
      'muted_user_ids': instance.mutedUserIds,
      'reason': instance.reason,
      'type': instance.type,
    };

ClosedCaptionEvent _$ClosedCaptionEventFromJson(Map<String, dynamic> json) =>
    ClosedCaptionEvent(
      callCid: json['call_cid'] as String,
      closedCaption: CallClosedCaption.fromJson(
        json['closed_caption'] as Map<String, dynamic>,
      ),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ClosedCaptionEventToJson(ClosedCaptionEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'closed_caption': instance.closedCaption.toJson(),
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };

CustomVideoEvent _$CustomVideoEventFromJson(Map<String, dynamic> json) =>
    CustomVideoEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomVideoEventToJson(CustomVideoEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

IngressErrorEvent _$IngressErrorEventFromJson(Map<String, dynamic> json) =>
    IngressErrorEvent(
      callCid: json['call_cid'] as String,
      code: json['code'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      error: json['error'] as String,
      ingressStreamId: json['ingress_stream_id'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$IngressErrorEventToJson(IngressErrorEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'code': instance.code,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'error': instance.error,
      'ingress_stream_id': instance.ingressStreamId,
      'type': instance.type,
      'user_id': instance.userId,
    };

IngressStartedEvent _$IngressStartedEventFromJson(Map<String, dynamic> json) =>
    IngressStartedEvent(
      callCid: json['call_cid'] as String,
      clientIp: json['client_ip'] as String?,
      clientName: json['client_name'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      ingressStreamId: json['ingress_stream_id'] as String,
      publisherType: json['publisher_type'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$IngressStartedEventToJson(
  IngressStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'client_ip': instance.clientIp,
  'client_name': instance.clientName,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'ingress_stream_id': instance.ingressStreamId,
  'publisher_type': instance.publisherType,
  'type': instance.type,
  'user_id': instance.userId,
  'version': instance.version,
};

IngressStoppedEvent _$IngressStoppedEventFromJson(Map<String, dynamic> json) =>
    IngressStoppedEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      ingressStreamId: json['ingress_stream_id'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$IngressStoppedEventToJson(
  IngressStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'ingress_stream_id': instance.ingressStreamId,
  'type': instance.type,
  'user_id': instance.userId,
};

KickedUserEvent _$KickedUserEventFromJson(Map<String, dynamic> json) =>
    KickedUserEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      kickedByUser: json['kicked_by_user'] == null
          ? null
          : UserResponse.fromJson(
              json['kicked_by_user'] as Map<String, dynamic>,
            ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KickedUserEventToJson(KickedUserEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'kicked_by_user': instance.kickedByUser?.toJson(),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

ModerationCustomActionEvent _$ModerationCustomActionEventFromJson(
  Map<String, dynamic> json,
) => ModerationCustomActionEvent(
  actionId: json['action_id'] as String,
  actionOptions: json['action_options'] as Map<String, dynamic>?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewQueueItem: ReviewQueueItemResponse.fromJson(
    json['review_queue_item'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationCustomActionEventToJson(
  ModerationCustomActionEvent instance,
) => <String, dynamic>{
  'action_id': instance.actionId,
  'action_options': instance.actionOptions,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'review_queue_item': instance.reviewQueueItem.toJson(),
  'type': instance.type,
};

ModerationFlaggedEvent _$ModerationFlaggedEventFromJson(
  Map<String, dynamic> json,
) => ModerationFlaggedEvent(
  contentType: json['content_type'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  objectId: json['object_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationFlaggedEventToJson(
  ModerationFlaggedEvent instance,
) => <String, dynamic>{
  'content_type': instance.contentType,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'object_id': instance.objectId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

ModerationMarkReviewedEvent _$ModerationMarkReviewedEventFromJson(
  Map<String, dynamic> json,
) => ModerationMarkReviewedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  item: ReviewQueueItemResponse.fromJson(json['item'] as Map<String, dynamic>),
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationMarkReviewedEventToJson(
  ModerationMarkReviewedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'item': instance.item.toJson(),
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PermissionRequestEvent _$PermissionRequestEventFromJson(
  Map<String, dynamic> json,
) => PermissionRequestEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PermissionRequestEventToJson(
  PermissionRequestEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'permissions': instance.permissions,
  'type': instance.type,
  'user': instance.user.toJson(),
};

UnblockedUserEvent _$UnblockedUserEventFromJson(Map<String, dynamic> json) =>
    UnblockedUserEvent(
      callCid: json['call_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnblockedUserEventToJson(UnblockedUserEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

UpdatedCallPermissionsEvent _$UpdatedCallPermissionsEventFromJson(
  Map<String, dynamic> json,
) => UpdatedCallPermissionsEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  ownCapabilities: (json['own_capabilities'] as List<dynamic>)
      .map((e) => e as OwnCapability)
      .toList(),
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdatedCallPermissionsEventToJson(
  UpdatedCallPermissionsEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'own_capabilities': instance.ownCapabilities,
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserBannedEvent _$UserBannedEventFromJson(Map<String, dynamic> json) =>
    UserBannedEvent(
      channelCustom: json['channel_custom'] as Map<String, dynamic>?,
      channelId: json['channel_id'] as String?,
      channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
      channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
      channelType: json['channel_type'] as String?,
      cid: json['cid'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: json['created_by'] == null
          ? null
          : UserResponseCommonFields.fromJson(
              json['created_by'] as Map<String, dynamic>,
            ),
      custom: json['custom'] as Map<String, dynamic>,
      expiration: _$JsonConverterFromJson<Object, DateTime>(
        json['expiration'],
        const StreamDateTimeConverter().fromJson,
      ),
      reason: json['reason'] as String?,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      reviewQueueItemId: json['review_queue_item_id'] as String?,
      shadow: json['shadow'] as bool?,
      team: json['team'] as String?,
      totalBans: (json['total_bans'] as num?)?.toInt(),
      type: json['type'] as String,
      user: UserResponseCommonFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserBannedEventToJson(UserBannedEvent instance) =>
    <String, dynamic>{
      'channel_custom': instance.channelCustom,
      'channel_id': instance.channelId,
      'channel_member_count': instance.channelMemberCount,
      'channel_message_count': instance.channelMessageCount,
      'channel_type': instance.channelType,
      'cid': instance.cid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy?.toJson(),
      'custom': instance.custom,
      'expiration': _$JsonConverterToJson<Object, DateTime>(
        instance.expiration,
        const StreamDateTimeConverter().toJson,
      ),
      'reason': instance.reason,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'review_queue_item_id': instance.reviewQueueItemId,
      'shadow': instance.shadow,
      'team': instance.team,
      'total_bans': instance.totalBans,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

UserDeactivatedEvent _$UserDeactivatedEventFromJson(
  Map<String, dynamic> json,
) => UserDeactivatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserDeactivatedEventToJson(
  UserDeactivatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserDeletedEvent _$UserDeletedEventFromJson(Map<String, dynamic> json) =>
    UserDeletedEvent(
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      deleteConversation: json['delete_conversation'] as String,
      deleteConversationChannels: json['delete_conversation_channels'] as bool,
      deleteMessages: json['delete_messages'] as String,
      deleteUser: json['delete_user'] as String,
      hardDelete: json['hard_delete'] as bool,
      markMessagesDeleted: json['mark_messages_deleted'] as bool,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
      user: UserResponseCommonFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserDeletedEventToJson(UserDeletedEvent instance) =>
    <String, dynamic>{
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'delete_conversation': instance.deleteConversation,
      'delete_conversation_channels': instance.deleteConversationChannels,
      'delete_messages': instance.deleteMessages,
      'delete_user': instance.deleteUser,
      'hard_delete': instance.hardDelete,
      'mark_messages_deleted': instance.markMessagesDeleted,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'type': instance.type,
      'user': instance.user.toJson(),
    };

UserPresenceChangedEvent _$UserPresenceChangedEventFromJson(
  Map<String, dynamic> json,
) => UserPresenceChangedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserPresenceChangedEventToJson(
  UserPresenceChangedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserReactivatedEvent _$UserReactivatedEventFromJson(
  Map<String, dynamic> json,
) => UserReactivatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserReactivatedEventToJson(
  UserReactivatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserUnbannedEvent _$UserUnbannedEventFromJson(Map<String, dynamic> json) =>
    UserUnbannedEvent(
      channelCustom: json['channel_custom'] as Map<String, dynamic>?,
      channelId: json['channel_id'] as String?,
      channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
      channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
      channelType: json['channel_type'] as String?,
      cid: json['cid'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: json['created_by'] == null
          ? null
          : UserResponseCommonFields.fromJson(
              json['created_by'] as Map<String, dynamic>,
            ),
      custom: json['custom'] as Map<String, dynamic>,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      shadow: json['shadow'] as bool?,
      team: json['team'] as String?,
      type: json['type'] as String,
      user: UserResponseCommonFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserUnbannedEventToJson(UserUnbannedEvent instance) =>
    <String, dynamic>{
      'channel_custom': instance.channelCustom,
      'channel_id': instance.channelId,
      'channel_member_count': instance.channelMemberCount,
      'channel_message_count': instance.channelMessageCount,
      'channel_type': instance.channelType,
      'cid': instance.cid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy?.toJson(),
      'custom': instance.custom,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'shadow': instance.shadow,
      'team': instance.team,
      'type': instance.type,
      'user': instance.user.toJson(),
    };

UserUpdatedEvent _$UserUpdatedEventFromJson(Map<String, dynamic> json) =>
    UserUpdatedEvent(
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
      user: UserResponsePrivacyFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserUpdatedEventToJson(UserUpdatedEvent instance) =>
    <String, dynamic>{
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
