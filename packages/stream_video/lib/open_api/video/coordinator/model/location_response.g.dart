// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) =>
    LocationResponse(
      continentCode: json['continent_code'] as String,
      countryIsoCode: json['country_iso_code'] as String,
      subdivisionIsoCode: json['subdivision_iso_code'] as String,
    );

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) =>
    <String, dynamic>{
      'continent_code': instance.continentCode,
      'country_iso_code': instance.countryIsoCode,
      'subdivision_iso_code': instance.subdivisionIsoCode,
    };
