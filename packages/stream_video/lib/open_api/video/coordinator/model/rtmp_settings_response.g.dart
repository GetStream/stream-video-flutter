// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPSettingsResponse _$RTMPSettingsResponseFromJson(
  Map<String, dynamic> json,
) => RTMPSettingsResponse(
  enabled: json['enabled'] as bool,
  quality: json['quality'] as String,
);

Map<String, dynamic> _$RTMPSettingsResponseToJson(
  RTMPSettingsResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'quality': instance.quality,
};
