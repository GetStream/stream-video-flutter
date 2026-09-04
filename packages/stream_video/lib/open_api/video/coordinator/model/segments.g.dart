// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Segments _$SegmentsFromJson(Map<String, dynamic> json) => Segments(
  byBrowser: (json['by_browser'] as List<dynamic>)
      .map((e) => BroadcastSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
  byCountry: (json['by_country'] as List<dynamic>)
      .map((e) => BroadcastSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
  byCountryReason: json['by_country_reason'] as String,
  byDeliveryZone: (json['by_delivery_zone'] as List<dynamic>)
      .map((e) => DeliveryZoneSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
  byOs: (json['by_os'] as List<dynamic>)
      .map((e) => BroadcastSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
  bySdk: (json['by_sdk'] as List<dynamic>)
      .map((e) => BroadcastSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SegmentsToJson(Segments instance) => <String, dynamic>{
  'by_browser': instance.byBrowser.map((e) => e.toJson()).toList(),
  'by_country': instance.byCountry.map((e) => e.toJson()).toList(),
  'by_country_reason': instance.byCountryReason,
  'by_delivery_zone': instance.byDeliveryZone.map((e) => e.toJson()).toList(),
  'by_os': instance.byOs.map((e) => e.toJson()).toList(),
  'by_sdk': instance.bySdk.map((e) => e.toJson()).toList(),
};
