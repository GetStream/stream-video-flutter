// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'percentiles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Percentiles _$PercentilesFromJson(Map<String, dynamic> json) => Percentiles(
  p50: (json['p50'] as num?)?.toDouble(),
  p95: (json['p95'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PercentilesToJson(Percentiles instance) =>
    <String, dynamic>{'p50': instance.p50, 'p95': instance.p95};
