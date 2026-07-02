// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeofenceSettingsResponse _$GeofenceSettingsResponseFromJson(
  Map<String, dynamic> json,
) => GeofenceSettingsResponse(
  names:
      (json['names'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);

Map<String, dynamic> _$GeofenceSettingsResponseToJson(
  GeofenceSettingsResponse instance,
) => <String, dynamic>{'names': instance.names};
