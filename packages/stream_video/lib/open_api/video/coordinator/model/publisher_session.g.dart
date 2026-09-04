// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublisherSession _$PublisherSessionFromJson(Map<String, dynamic> json) =>
    PublisherSession(
      avgJitterMs: (json['avg_jitter_ms'] as num?)?.toDouble(),
      browser: json['browser'] as String?,
      deliveryZone: json['delivery_zone'] as String?,
      durationMin: (json['duration_min'] as num).toDouble(),
      encoding: json['encoding'] == null
          ? null
          : EncodingProfile.fromJson(json['encoding'] as Map<String, dynamic>),
      ingest: json['ingest'] as String?,
      os: json['os'] as String?,
      sendQualityScore: (json['send_quality_score'] as num?)?.toDouble(),
      startedOffsetMin: (json['started_offset_min'] as num).toDouble(),
      tool: json['tool'] as String?,
      userId: json['user_id'] as String,
      userSessionId: json['user_session_id'] as String,
    );

Map<String, dynamic> _$PublisherSessionToJson(PublisherSession instance) =>
    <String, dynamic>{
      'avg_jitter_ms': instance.avgJitterMs,
      'browser': instance.browser,
      'delivery_zone': instance.deliveryZone,
      'duration_min': instance.durationMin,
      'encoding': instance.encoding?.toJson(),
      'ingest': instance.ingest,
      'os': instance.os,
      'send_quality_score': instance.sendQualityScore,
      'started_offset_min': instance.startedOffsetMin,
      'tool': instance.tool,
      'user_id': instance.userId,
      'user_session_id': instance.userSessionId,
    };
