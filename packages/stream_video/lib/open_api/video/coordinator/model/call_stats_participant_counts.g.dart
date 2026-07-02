// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_participant_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsParticipantCounts _$CallStatsParticipantCountsFromJson(
  Map<String, dynamic> json,
) => CallStatsParticipantCounts(
  averageJitterMs: (json['average_jitter_ms'] as num?)?.toInt(),
  averageLatencyMs: (json['average_latency_ms'] as num?)?.toInt(),
  avgUserRating: (json['avg_user_rating'] as num?)?.toDouble(),
  callEventCount: (json['call_event_count'] as num?)?.toInt(),
  cqScore: (json['cq_score'] as num?)?.toInt(),
  liveSessions: (json['live_sessions'] as num).toInt(),
  maxFreezesDurationMs: (json['max_freezes_duration_ms'] as num?)?.toInt(),
  minUserRating: (json['min_user_rating'] as num?)?.toInt(),
  participants: (json['participants'] as num).toInt(),
  peakConcurrentSessions: (json['peak_concurrent_sessions'] as num).toInt(),
  peakConcurrentUsers: (json['peak_concurrent_users'] as num).toInt(),
  publishers: (json['publishers'] as num).toInt(),
  sessions: (json['sessions'] as num).toInt(),
  sfusUsed: (json['sfus_used'] as num).toInt(),
  totalParticipantDuration: (json['total_participant_duration'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$CallStatsParticipantCountsToJson(
  CallStatsParticipantCounts instance,
) => <String, dynamic>{
  'average_jitter_ms': instance.averageJitterMs,
  'average_latency_ms': instance.averageLatencyMs,
  'avg_user_rating': instance.avgUserRating,
  'call_event_count': instance.callEventCount,
  'cq_score': instance.cqScore,
  'live_sessions': instance.liveSessions,
  'max_freezes_duration_ms': instance.maxFreezesDurationMs,
  'min_user_rating': instance.minUserRating,
  'participants': instance.participants,
  'peak_concurrent_sessions': instance.peakConcurrentSessions,
  'peak_concurrent_users': instance.peakConcurrentUsers,
  'publishers': instance.publishers,
  'sessions': instance.sessions,
  'sfus_used': instance.sfusUsed,
  'total_participant_duration': instance.totalParticipantDuration,
};
