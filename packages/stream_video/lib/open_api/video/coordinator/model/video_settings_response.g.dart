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
  cameraFacing: VideoSettingsResponseCameraFacing.fromJson(
    json['camera_facing'] as String,
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
  'camera_facing': instance.cameraFacing.toJson(),
  'enabled': instance.enabled,
  'target_resolution': instance.targetResolution.toJson(),
};
