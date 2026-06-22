// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeResponse _$EdgeResponseFromJson(Map<String, dynamic> json) => EdgeResponse(
  continentCode: json['continent_code'] as String,
  countryIsoCode: json['country_iso_code'] as String,
  green: (json['green'] as num).toInt(),
  id: json['id'] as String,
  latencyTestUrl: json['latency_test_url'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  red: (json['red'] as num).toInt(),
  subdivisionIsoCode: json['subdivision_iso_code'] as String,
  yellow: (json['yellow'] as num).toInt(),
);

Map<String, dynamic> _$EdgeResponseToJson(EdgeResponse instance) =>
    <String, dynamic>{
      'continent_code': instance.continentCode,
      'country_iso_code': instance.countryIsoCode,
      'green': instance.green,
      'id': instance.id,
      'latency_test_url': instance.latencyTestUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'red': instance.red,
      'subdivision_iso_code': instance.subdivisionIsoCode,
      'yellow': instance.yellow,
    };
