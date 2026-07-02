// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingStoppedEvent _$CallRecordingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: $enumDecode(
    _$CallRecordingStoppedEventRecordingTypeEnumMap,
    json['recording_type'],
    unknownValue: CallRecordingStoppedEventRecordingType.unknown,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStoppedEventToJson(
  CallRecordingStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type':
      _$CallRecordingStoppedEventRecordingTypeEnumMap[instance.recordingType]!,
  'type': instance.type,
};

const _$CallRecordingStoppedEventRecordingTypeEnumMap = {
  CallRecordingStoppedEventRecordingType.composite: 'composite',
  CallRecordingStoppedEventRecordingType.individual: 'individual',
  CallRecordingStoppedEventRecordingType.raw: 'raw',
  CallRecordingStoppedEventRecordingType.unknown: '_unknown',
};
