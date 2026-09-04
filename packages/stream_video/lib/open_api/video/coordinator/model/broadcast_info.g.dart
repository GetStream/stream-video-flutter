// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastInfo _$BroadcastInfoFromJson(Map<String, dynamic> json) =>
    BroadcastInfo(
      appId: (json['app_id'] as num).toInt(),
      callCid: json['call_cid'] as String,
      callSessionId: json['call_session_id'] as String,
      callType: json['call_type'] as String,
      creators: (json['creators'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      durationMin: (json['duration_min'] as num).toDouble(),
      endedAt: json['ended_at'] as String,
      sourceMode: json['source_mode'] as String?,
      startedAt: json['started_at'] as String,
    );

Map<String, dynamic> _$BroadcastInfoToJson(BroadcastInfo instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'call_cid': instance.callCid,
      'call_session_id': instance.callSessionId,
      'call_type': instance.callType,
      'creators': instance.creators,
      'duration_min': instance.durationMin,
      'ended_at': instance.endedAt,
      'source_mode': instance.sourceMode,
      'started_at': instance.startedAt,
    };
