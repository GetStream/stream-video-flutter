// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsLocation _$CallStatsLocationFromJson(Map<String, dynamic> json) =>
    CallStatsLocation(
      accuracyRadiusMeters: (json['accuracy_radius_meters'] as num?)?.toInt(),
      city: json['city'] as String?,
      continent: json['continent'] as String?,
      country: json['country'] as String?,
      countryIsoCode: json['country_iso_code'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      subdivision: json['subdivision'] as String?,
    );

Map<String, dynamic> _$CallStatsLocationToJson(CallStatsLocation instance) =>
    <String, dynamic>{
      'accuracy_radius_meters': instance.accuracyRadiusMeters,
      'city': instance.city,
      'continent': instance.continent,
      'country': instance.country,
      'country_iso_code': instance.countryIsoCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'subdivision': instance.subdivision,
    };
