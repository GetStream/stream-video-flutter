// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coverage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coverage _$CoverageFromJson(Map<String, dynamic> json) => Coverage(
  absent: (json['absent'] as List<dynamic>)
      .map((e) => AbsentMetric.fromJson(e as Map<String, dynamic>))
      .toList(),
  metricsPct: MetricsPct.fromJson(json['metrics_pct'] as Map<String, dynamic>),
  publisherEncodingProfiles: (json['publisher_encoding_profiles'] as num)
      .toInt(),
);

Map<String, dynamic> _$CoverageToJson(Coverage instance) => <String, dynamic>{
  'absent': instance.absent.map((e) => e.toJson()).toList(),
  'metrics_pct': instance.metricsPct.toJson(),
  'publisher_encoding_profiles': instance.publisherEncodingProfiles,
};
