// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backstage_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackstageSettingsResponse _$BackstageSettingsResponseFromJson(
  Map<String, dynamic> json,
) => BackstageSettingsResponse(
  enabled: json['enabled'] as bool,
  joinAheadTimeSeconds: (json['join_ahead_time_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$BackstageSettingsResponseToJson(
  BackstageSettingsResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'join_ahead_time_seconds': instance.joinAheadTimeSeconds,
};
