// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sfu_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SFULocationResponse _$SFULocationResponseFromJson(Map<String, dynamic> json) =>
    SFULocationResponse(
      coordinates: CoordinatesResponse.fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
      count: (json['count'] as num?)?.toInt(),
      datacenter: json['datacenter'] as String,
      id: json['id'] as String,
      location: LocationResponse.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SFULocationResponseToJson(
  SFULocationResponse instance,
) => <String, dynamic>{
  'coordinates': instance.coordinates,
  'count': instance.count,
  'datacenter': instance.datacenter,
  'id': instance.id,
  'location': instance.location,
};
