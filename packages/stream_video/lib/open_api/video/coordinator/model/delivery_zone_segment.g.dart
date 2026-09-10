// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_zone_segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryZoneSegment _$DeliveryZoneSegmentFromJson(Map<String, dynamic> json) =>
    DeliveryZoneSegment(
      avgQualityScore: (json['avg_quality_score'] as num?)?.toDouble(),
      key: json['key'] as String,
      outlier: json['outlier'] as bool,
      p5QualityScore: (json['p5_quality_score'] as num?)?.toDouble(),
      poorPct: (json['poor_pct'] as num?)?.toDouble(),
      sessions: (json['sessions'] as num).toInt(),
      sharePct: (json['share_pct'] as num?)?.toDouble(),
      watchSharePct: (json['watch_share_pct'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeliveryZoneSegmentToJson(
  DeliveryZoneSegment instance,
) => <String, dynamic>{
  'avg_quality_score': instance.avgQualityScore,
  'key': instance.key,
  'outlier': instance.outlier,
  'p5_quality_score': instance.p5QualityScore,
  'poor_pct': instance.poorPct,
  'sessions': instance.sessions,
  'share_pct': instance.sharePct,
  'watch_share_pct': instance.watchSharePct,
};
