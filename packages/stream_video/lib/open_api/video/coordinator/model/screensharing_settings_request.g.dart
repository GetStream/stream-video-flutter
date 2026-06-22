// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screensharing_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreensharingSettingsRequest _$ScreensharingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => ScreensharingSettingsRequest(
  accessRequestEnabled: json['access_request_enabled'] as bool?,
  enabled: json['enabled'] as bool?,
  targetResolution: json['target_resolution'] == null
      ? null
      : TargetResolution.fromJson(
          json['target_resolution'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ScreensharingSettingsRequestToJson(
  ScreensharingSettingsRequest instance,
) => <String, dynamic>{
  'access_request_enabled': instance.accessRequestEnabled,
  'enabled': instance.enabled,
  'target_resolution': instance.targetResolution,
};
