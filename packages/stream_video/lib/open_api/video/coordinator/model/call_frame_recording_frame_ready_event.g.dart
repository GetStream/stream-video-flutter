// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_frame_recording_frame_ready_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallFrameRecordingFrameReadyEvent _$CallFrameRecordingFrameReadyEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingFrameReadyEvent(
  callCid: json['call_cid'] as String,
  capturedAt: const EpochDateTimeConverter().fromJson(
    json['captured_at'] as Object,
  ),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  sessionId: json['session_id'] as String,
  trackType: json['track_type'] as String,
  type: json['type'] as String,
  url: json['url'] as String,
  users:
      (json['users'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, UserResponse.fromJson(e as Map<String, dynamic>)),
      ) ??
      {},
);

Map<String, dynamic> _$CallFrameRecordingFrameReadyEventToJson(
  CallFrameRecordingFrameReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'captured_at': const EpochDateTimeConverter().toJson(instance.capturedAt),
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'session_id': instance.sessionId,
  'track_type': instance.trackType,
  'type': instance.type,
  'url': instance.url,
  'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
};
