// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingFailedEvent _$CallRecordingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: $enumDecode(
    _$CallRecordingFailedEventRecordingTypeEnumMap,
    json['recording_type'],
    unknownValue: CallRecordingFailedEventRecordingType.unknown,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingFailedEventToJson(
  CallRecordingFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type':
      _$CallRecordingFailedEventRecordingTypeEnumMap[instance.recordingType]!,
  'type': instance.type,
};

const _$CallRecordingFailedEventRecordingTypeEnumMap = {
  CallRecordingFailedEventRecordingType.composite: 'composite',
  CallRecordingFailedEventRecordingType.individual: 'individual',
  CallRecordingFailedEventRecordingType.raw: 'raw',
  CallRecordingFailedEventRecordingType.unknown: '_unknown',
};
