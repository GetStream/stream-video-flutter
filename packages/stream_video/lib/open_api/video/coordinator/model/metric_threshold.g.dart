// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_threshold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricThreshold _$MetricThresholdFromJson(Map<String, dynamic> json) =>
    MetricThreshold(
      level: json['level'] as String,
      operator: json['operator'] as String,
      value: (json['value'] as num).toDouble(),
      valueUnit: json['value_unit'] as String?,
      windowSeconds: (json['window_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetricThresholdToJson(MetricThreshold instance) =>
    <String, dynamic>{
      'level': instance.level,
      'operator': instance.operator,
      'value': instance.value,
      'value_unit': instance.valueUnit,
      'window_seconds': instance.windowSeconds,
    };
