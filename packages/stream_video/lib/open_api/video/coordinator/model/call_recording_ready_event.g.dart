// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_ready_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
  recordingType: CallRecordingReadyEventRecordingType.fromJson(
    json['recording_type'] as String,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingReadyEventToJson(
  CallRecordingReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'call_recording': instance.callRecording.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType.toJson(),
  'type': instance.type,
};
