// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricDescriptor _$MetricDescriptorFromJson(Map<String, dynamic> json) =>
    MetricDescriptor(
      description: json['description'] as String?,
      label: json['label'] as String,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$MetricDescriptorToJson(MetricDescriptor instance) =>
    <String, dynamic>{
      'description': instance.description,
      'label': instance.label,
      'unit': instance.unit,
    };
