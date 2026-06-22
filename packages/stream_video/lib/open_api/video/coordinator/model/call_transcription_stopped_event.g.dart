// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTranscriptionStoppedEvent _$CallTranscriptionStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallTranscriptionStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  egressId: json['egress_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallTranscriptionStoppedEventToJson(
  CallTranscriptionStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'egress_id': instance.egressId,
  'type': instance.type,
};
