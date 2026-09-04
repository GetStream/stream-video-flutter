// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics_pct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricsPct _$MetricsPctFromJson(Map<String, dynamic> json) => MetricsPct(
  freezes: (json['freezes'] as num?)?.toDouble(),
  geo: (json['geo'] as num?)?.toDouble(),
  jitter: (json['jitter'] as num?)?.toDouble(),
  latency: (json['latency'] as num?)?.toDouble(),
  qualityScore: (json['quality_score'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MetricsPctToJson(MetricsPct instance) =>
    <String, dynamic>{
      'freezes': instance.freezes,
      'geo': instance.geo,
      'jitter': instance.jitter,
      'latency': instance.latency,
      'quality_score': instance.qualityScore,
    };
