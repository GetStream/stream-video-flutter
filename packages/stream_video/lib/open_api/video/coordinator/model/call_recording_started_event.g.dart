// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingStartedEvent _$CallRecordingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: CallRecordingStartedEventRecordingType.fromJson(
    json['recording_type'] as String,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStartedEventToJson(
  CallRecordingStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type': instance.recordingType.toJson(),
  'type': instance.type,
};
