// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingStoppedEvent _$CallRecordingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: CallRecordingStoppedEventRecordingType.fromJson(
    json['recording_type'] as String,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStoppedEventToJson(
  CallRecordingStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType.toJson(),
  'type': instance.type,
};
