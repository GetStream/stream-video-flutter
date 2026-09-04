// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supporting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supporting _$SupportingFromJson(Map<String, dynamic> json) => Supporting(
  deliveryIncidentWindows: (json['delivery_incident_windows'] as List<dynamic>)
      .map((e) => Incident.fromJson(e as Map<String, dynamic>))
      .toList(),
  edgeOutlierZones: (json['edge_outlier_zones'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  sourceDropWindows: (json['source_drop_windows'] as List<dynamic>)
      .map((e) => TimeWindow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SupportingToJson(Supporting instance) =>
    <String, dynamic>{
      'delivery_incident_windows': instance.deliveryIncidentWindows
          .map((e) => e.toJson())
          .toList(),
      'edge_outlier_zones': instance.edgeOutlierZones,
      'source_drop_windows': instance.sourceDropWindows
          .map((e) => e.toJson())
          .toList(),
    };
