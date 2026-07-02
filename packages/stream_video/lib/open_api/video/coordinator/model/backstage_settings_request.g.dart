// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backstage_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackstageSettingsRequest _$BackstageSettingsRequestFromJson(
  Map<String, dynamic> json,
) => BackstageSettingsRequest(
  enabled: json['enabled'] as bool?,
  joinAheadTimeSeconds: (json['join_ahead_time_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$BackstageSettingsRequestToJson(
  BackstageSettingsRequest instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'join_ahead_time_seconds': instance.joinAheadTimeSeconds,
};
