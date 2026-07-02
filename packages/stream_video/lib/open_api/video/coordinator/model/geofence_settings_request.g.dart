// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeofenceSettingsRequest _$GeofenceSettingsRequestFromJson(
  Map<String, dynamic> json,
) => GeofenceSettingsRequest(
  names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$GeofenceSettingsRequestToJson(
  GeofenceSettingsRequest instance,
) => <String, dynamic>{'names': instance.names};
