// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastSegment _$BroadcastSegmentFromJson(Map<String, dynamic> json) =>
    BroadcastSegment(
      avgQualityScore: (json['avg_quality_score'] as num?)?.toDouble(),
      key: json['key'] as String,
      p5QualityScore: (json['p5_quality_score'] as num?)?.toDouble(),
      poorPct: (json['poor_pct'] as num?)?.toDouble(),
      sessions: (json['sessions'] as num).toInt(),
      sharePct: (json['share_pct'] as num?)?.toDouble(),
      watchSharePct: (json['watch_share_pct'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BroadcastSegmentToJson(BroadcastSegment instance) =>
    <String, dynamic>{
      'avg_quality_score': instance.avgQualityScore,
      'key': instance.key,
      'p5_quality_score': instance.p5QualityScore,
      'poor_pct': instance.poorPct,
      'sessions': instance.sessions,
      'share_pct': instance.sharePct,
      'watch_share_pct': instance.watchSharePct,
    };
