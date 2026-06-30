// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_ready_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTranscriptionReadyEvent _$CallTranscriptionReadyEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionReadyEvent(
  callCid: json['call_cid'] as String,
  callTranscription: CallTranscription.fromJson(
    json['call_transcription'] as Map<String, dynamic>,
  ),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionReadyEventToJson(
  CallTranscriptionReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'call_transcription': instance.callTranscription.toJson(),
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};
