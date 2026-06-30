// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_participant_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsParticipantSession _$CallStatsParticipantSessionFromJson(
  Map<String, dynamic> json,
) => CallStatsParticipantSession(
  browser: json['browser'] as String?,
  browserVersion: json['browser_version'] as String?,
  cqScore: (json['cq_score'] as num?)?.toInt(),
  currentIp: json['current_ip'] as String?,
  currentSfu: json['current_sfu'] as String?,
  distanceToSfuKilometers: (json['distance_to_sfu_kilometers'] as num?)
      ?.toDouble(),
  endedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['ended_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  freezesDurationMs: (json['freezes_duration_ms'] as num?)?.toInt(),
  ingress: json['ingress'] as String?,
  isLive: json['is_live'] as bool,
  jitterMs: (json['jitter_ms'] as num?)?.toInt(),
  latencyMs: (json['latency_ms'] as num?)?.toInt(),
  location: json['location'] == null
      ? null
      : CallStatsLocation.fromJson(json['location'] as Map<String, dynamic>),
  os: json['os'] as String?,
  publishedTracks: PublishedTrackFlags.fromJson(
    json['published_tracks'] as Map<String, dynamic>,
  ),
  publisherType: json['publisher_type'] as String?,
  sdk: json['sdk'] as String?,
  sdkVersion: json['sdk_version'] as String?,
  startedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['started_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  unifiedSessionId: json['unified_session_id'] as String?,
  userSessionId: json['user_session_id'] as String,
  webrtcVersion: json['webrtc_version'] as String?,
);

Map<String, dynamic> _$CallStatsParticipantSessionToJson(
  CallStatsParticipantSession instance,
) => <String, dynamic>{
  'browser': instance.browser,
  'browser_version': instance.browserVersion,
  'cq_score': instance.cqScore,
  'current_ip': instance.currentIp,
  'current_sfu': instance.currentSfu,
  'distance_to_sfu_kilometers': instance.distanceToSfuKilometers,
  'ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'freezes_duration_ms': instance.freezesDurationMs,
  'ingress': instance.ingress,
  'is_live': instance.isLive,
  'jitter_ms': instance.jitterMs,
  'latency_ms': instance.latencyMs,
  'location': instance.location?.toJson(),
  'os': instance.os,
  'published_tracks': instance.publishedTracks.toJson(),
  'publisher_type': instance.publisherType,
  'sdk': instance.sdk,
  'sdk_version': instance.sdkVersion,
  'started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.startedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'unified_session_id': instance.unifiedSessionId,
  'user_session_id': instance.userSessionId,
  'webrtc_version': instance.webrtcVersion,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
