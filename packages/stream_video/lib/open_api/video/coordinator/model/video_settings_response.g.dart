// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSettingsResponse _$VideoSettingsResponseFromJson(
  Map<String, dynamic> json,
) => VideoSettingsResponse(
  accessRequestEnabled: json['access_request_enabled'] as bool,
  cameraDefaultOn: json['camera_default_on'] as bool,
  cameraFacing: $enumDecode(
    _$VideoSettingsResponseCameraFacingEnumMap,
    json['camera_facing'],
    unknownValue: VideoSettingsResponseCameraFacing.unknown,
  ),
  enabled: json['enabled'] as bool,
  targetResolution: TargetResolution.fromJson(
    json['target_resolution'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$VideoSettingsResponseToJson(
  VideoSettingsResponse instance,
) => <String, dynamic>{
  'access_request_enabled': instance.accessRequestEnabled,
  'camera_default_on': instance.cameraDefaultOn,
  'camera_facing':
      _$VideoSettingsResponseCameraFacingEnumMap[instance.cameraFacing]!,
  'enabled': instance.enabled,
  'target_resolution': instance.targetResolution,
};

const _$VideoSettingsResponseCameraFacingEnumMap = {
  VideoSettingsResponseCameraFacing.back: 'back',
  VideoSettingsResponseCameraFacing.external: 'external',
  VideoSettingsResponseCameraFacing.front: 'front',
  VideoSettingsResponseCameraFacing.unknown: '_unknown',
};
