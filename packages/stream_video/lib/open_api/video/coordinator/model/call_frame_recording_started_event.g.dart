// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_frame_recording_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallFrameRecordingStartedEvent _$CallFrameRecordingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallFrameRecordingStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallFrameRecordingStartedEventToJson(
  CallFrameRecordingStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};
