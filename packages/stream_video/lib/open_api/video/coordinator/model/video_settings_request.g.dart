// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSettingsRequest _$VideoSettingsRequestFromJson(
  Map<String, dynamic> json,
) => VideoSettingsRequest(
  accessRequestEnabled: json['access_request_enabled'] as bool?,
  cameraDefaultOn: json['camera_default_on'] as bool?,
  cameraFacing: $enumDecodeNullable(
    _$VideoSettingsRequestCameraFacingEnumMap,
    json['camera_facing'],
    unknownValue: VideoSettingsRequestCameraFacing.unknown,
  ),
  enabled: json['enabled'] as bool?,
  targetResolution: json['target_resolution'] == null
      ? null
      : TargetResolution.fromJson(
          json['target_resolution'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$VideoSettingsRequestToJson(
  VideoSettingsRequest instance,
) => <String, dynamic>{
  'access_request_enabled': instance.accessRequestEnabled,
  'camera_default_on': instance.cameraDefaultOn,
  'camera_facing':
      _$VideoSettingsRequestCameraFacingEnumMap[instance.cameraFacing],
  'enabled': instance.enabled,
  'target_resolution': instance.targetResolution?.toJson(),
};

const _$VideoSettingsRequestCameraFacingEnumMap = {
  VideoSettingsRequestCameraFacing.back: 'back',
  VideoSettingsRequestCameraFacing.external: 'external',
  VideoSettingsRequestCameraFacing.front: 'front',
  VideoSettingsRequestCameraFacing.unknown: '_unknown',
};
