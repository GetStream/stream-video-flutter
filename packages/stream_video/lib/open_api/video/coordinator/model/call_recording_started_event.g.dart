// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecordingStartedEvent _$CallRecordingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallRecordingStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  recordingType: $enumDecode(
    _$CallRecordingStartedEventRecordingTypeEnumMap,
    json['recording_type'],
    unknownValue: CallRecordingStartedEventRecordingType.unknown,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRecordingStartedEventToJson(
  CallRecordingStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'recording_type':
      _$CallRecordingStartedEventRecordingTypeEnumMap[instance.recordingType]!,
  'type': instance.type,
};

const _$CallRecordingStartedEventRecordingTypeEnumMap = {
  CallRecordingStartedEventRecordingType.composite: 'composite',
  CallRecordingStartedEventRecordingType.individual: 'individual',
  CallRecordingStartedEventRecordingType.raw: 'raw',
  CallRecordingStartedEventRecordingType.unknown: '_unknown',
};
