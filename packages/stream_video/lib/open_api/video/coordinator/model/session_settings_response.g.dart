// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionSettingsResponse _$SessionSettingsResponseFromJson(
  Map<String, dynamic> json,
) => SessionSettingsResponse(
  inactivityTimeoutSeconds: (json['inactivity_timeout_seconds'] as num).toInt(),
);

Map<String, dynamic> _$SessionSettingsResponseToJson(
  SessionSettingsResponse instance,
) => <String, dynamic>{
  'inactivity_timeout_seconds': instance.inactivityTimeoutSeconds,
};
