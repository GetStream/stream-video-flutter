// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingFailedEvent _$CallRecordingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: CallRecordingFailedEventRecordingType.fromJson(
    json['recording_type'] as String,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingFailedEventToJson(
  CallRecordingFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType.toJson(),
  'type': instance.type,
};
