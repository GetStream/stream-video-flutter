// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientEvent _$ClientEventFromJson(Map<String, dynamic> json) => ClientEvent(
  callSessionId: json['call_session_id'] as String?,
  cameraPermissionStatus: json['camera_permission_status'] as String?,
  coordinatorConnectId: json['coordinator_connect_id'] as String?,
  elapsedTime: (json['elapsed_time'] as num?)?.toInt(),
  eventType: json['event_type'] as String?,
  iceState: json['ice_state'] as String?,
  id: json['id'] as String?,
  joinAttemptId: json['join_attempt_id'] as String?,
  microphonePermissionStatus: json['microphone_permission_status'] as String?,
  outcome: json['outcome'] as String?,
  peerConnection: json['peer_connection'] as String?,
  previouslyConnectedTimestamp: _$JsonConverterFromJson<Object, DateTime>(
    json['previously_connected_timestamp'],
    const EpochDateTimeConverter().fromJson,
  ),
  retryCountAttempt: (json['retry_count_attempt'] as num?)?.toInt(),
  retryFailureCode: json['retry_failure_code'] as String?,
  retryFailureReason: json['retry_failure_reason'] as String?,
  screenShareStatus: json['screen_share_status'] as String?,
  sdkVersion: json['sdk_version'] as String?,
  sfuId: json['sfu_id'] as String?,
  stage: json['stage'] as String?,
  stageId: json['stage_id'] as String?,
  timestamp: _$JsonConverterFromJson<Object, DateTime>(
    json['timestamp'],
    const EpochDateTimeConverter().fromJson,
  ),
  trackId: json['track_id'] as String?,
  type: json['type'] as String?,
  userAgent: json['user_agent'] as String?,
  userId: json['user_id'] as String?,
  wasPreviouslyConnected: json['was_previously_connected'] as bool?,
);

Map<String, dynamic> _$ClientEventToJson(ClientEvent instance) =>
    <String, dynamic>{
      'call_session_id': instance.callSessionId,
      'camera_permission_status': instance.cameraPermissionStatus,
      'coordinator_connect_id': instance.coordinatorConnectId,
      'elapsed_time': instance.elapsedTime,
      'event_type': instance.eventType,
      'ice_state': instance.iceState,
      'id': instance.id,
      'join_attempt_id': instance.joinAttemptId,
      'microphone_permission_status': instance.microphonePermissionStatus,
      'outcome': instance.outcome,
      'peer_connection': instance.peerConnection,
      'previously_connected_timestamp': _$JsonConverterToJson<Object, DateTime>(
        instance.previouslyConnectedTimestamp,
        const EpochDateTimeConverter().toJson,
      ),
      'retry_count_attempt': instance.retryCountAttempt,
      'retry_failure_code': instance.retryFailureCode,
      'retry_failure_reason': instance.retryFailureReason,
      'screen_share_status': instance.screenShareStatus,
      'sdk_version': instance.sdkVersion,
      'sfu_id': instance.sfuId,
      'stage': instance.stage,
      'stage_id': instance.stageId,
      'timestamp': _$JsonConverterToJson<Object, DateTime>(
        instance.timestamp,
        const EpochDateTimeConverter().toJson,
      ),
      'track_id': instance.trackId,
      'type': instance.type,
      'user_agent': instance.userAgent,
      'user_id': instance.userId,
      'was_previously_connected': instance.wasPreviouslyConnected,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
