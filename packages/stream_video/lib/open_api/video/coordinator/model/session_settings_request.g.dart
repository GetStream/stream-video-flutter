// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionSettingsRequest _$SessionSettingsRequestFromJson(
  Map<String, dynamic> json,
) => SessionSettingsRequest(
  inactivityTimeoutSeconds: (json['inactivity_timeout_seconds'] as num).toInt(),
);

Map<String, dynamic> _$SessionSettingsRequestToJson(
  SessionSettingsRequest instance,
) => <String, dynamic>{
  'inactivity_timeout_seconds': instance.inactivityTimeoutSeconds,
};
