// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_dtmf_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallDTMFEvent _$CallDTMFEventFromJson(Map<String, dynamic> json) =>
    CallDTMFEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      digit: json['digit'] as String,
      durationMs: (json['duration_ms'] as num).toInt(),
      seqNumber: (json['seq_number'] as num).toInt(),
      timestamp: const EpochDateTimeConverter().fromJson(
        json['timestamp'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallDTMFEventToJson(CallDTMFEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'digit': instance.digit,
      'duration_ms': instance.durationMs,
      'seq_number': instance.seqNumber,
      'timestamp': const EpochDateTimeConverter().toJson(instance.timestamp),
      'type': instance.type,
      'user': instance.user,
    };
