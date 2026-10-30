// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutSettingsRequest _$LayoutSettingsRequestFromJson(
  Map<String, dynamic> json,
) => LayoutSettingsRequest(
  detectOrientation: json['detect_orientation'] as bool?,
  externalAppUrl: json['external_app_url'] as String?,
  externalCssUrl: json['external_css_url'] as String?,
  name: json['name'] as LayoutName,
  options: json['options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LayoutSettingsRequestToJson(
  LayoutSettingsRequest instance,
) => <String, dynamic>{
  'detect_orientation': instance.detectOrientation,
  'external_app_url': instance.externalAppUrl,
  'external_css_url': instance.externalCssUrl,
  'name': instance.name,
  'options': instance.options,
};
