// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoordinatesResponse _$CoordinatesResponseFromJson(Map<String, dynamic> json) =>
    CoordinatesResponse(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesResponseToJson(
  CoordinatesResponse instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
