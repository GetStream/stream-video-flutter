// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPSettingsRequest _$RTMPSettingsRequestFromJson(Map<String, dynamic> json) =>
    RTMPSettingsRequest(
      enabled: json['enabled'] as bool?,
      quality: $enumDecodeNullable(
        _$RTMPSettingsRequestQualityEnumMap,
        json['quality'],
        unknownValue: RTMPSettingsRequestQuality.unknown,
      ),
    );

Map<String, dynamic> _$RTMPSettingsRequestToJson(
  RTMPSettingsRequest instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'quality': _$RTMPSettingsRequestQualityEnumMap[instance.quality],
};

const _$RTMPSettingsRequestQualityEnumMap = {
  RTMPSettingsRequestQuality.n1080p: '1080p',
  RTMPSettingsRequestQuality.n1440p: '1440p',
  RTMPSettingsRequestQuality.n360p: '360p',
  RTMPSettingsRequestQuality.n480p: '480p',
  RTMPSettingsRequestQuality.n720p: '720p',
  RTMPSettingsRequestQuality.portrait1080x1920: 'portrait-1080x1920',
  RTMPSettingsRequestQuality.portrait1440x2560: 'portrait-1440x2560',
  RTMPSettingsRequestQuality.portrait360x640: 'portrait-360x640',
  RTMPSettingsRequestQuality.portrait480x854: 'portrait-480x854',
  RTMPSettingsRequestQuality.portrait720x1280: 'portrait-720x1280',
  RTMPSettingsRequestQuality.unknown: '_unknown',
};
