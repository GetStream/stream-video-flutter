// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTranscriptionFailedEvent _$CallTranscriptionFailedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  error: json['error'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionFailedEventToJson(
  CallTranscriptionFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'error': instance.error,
  'type': instance.type,
};
