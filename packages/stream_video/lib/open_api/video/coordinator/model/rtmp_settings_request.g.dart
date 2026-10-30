// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPSettingsRequest _$RTMPSettingsRequestFromJson(Map<String, dynamic> json) =>
    RTMPSettingsRequest(
      enabled: json['enabled'] as bool?,
      quality: json['quality'] as RTMPSettingsRequestQuality?,
    );

Map<String, dynamic> _$RTMPSettingsRequestToJson(
  RTMPSettingsRequest instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'quality': instance.quality,
};
