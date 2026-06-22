// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTranscriptionStartedEvent _$CallTranscriptionStartedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionStartedEventToJson(
  CallTranscriptionStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};
