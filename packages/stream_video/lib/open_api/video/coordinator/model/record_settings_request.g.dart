// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSettingsRequest _$RecordSettingsRequestFromJson(
  Map<String, dynamic> json,
) => RecordSettingsRequest(
  audioOnly: json['audio_only'] as bool?,
  mode: $enumDecode(
    _$RecordSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: RecordSettingsRequestMode.unknown,
  ),
  quality: $enumDecodeNullable(
    _$RecordSettingsRequestQualityEnumMap,
    json['quality'],
    unknownValue: RecordSettingsRequestQuality.unknown,
  ),
);

Map<String, dynamic> _$RecordSettingsRequestToJson(
  RecordSettingsRequest instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': _$RecordSettingsRequestModeEnumMap[instance.mode]!,
  'quality': _$RecordSettingsRequestQualityEnumMap[instance.quality],
};

const _$RecordSettingsRequestModeEnumMap = {
  RecordSettingsRequestMode.autoOn: 'auto-on',
  RecordSettingsRequestMode.available: 'available',
  RecordSettingsRequestMode.disabled: 'disabled',
  RecordSettingsRequestMode.unknown: '_unknown',
};

const _$RecordSettingsRequestQualityEnumMap = {
  RecordSettingsRequestQuality.n1080p: '1080p',
  RecordSettingsRequestQuality.n1440p: '1440p',
  RecordSettingsRequestQuality.n360p: '360p',
  RecordSettingsRequestQuality.n480p: '480p',
  RecordSettingsRequestQuality.n720p: '720p',
  RecordSettingsRequestQuality.portrait1080x1920: 'portrait-1080x1920',
  RecordSettingsRequestQuality.portrait1440x2560: 'portrait-1440x2560',
  RecordSettingsRequestQuality.portrait360x640: 'portrait-360x640',
  RecordSettingsRequestQuality.portrait480x854: 'portrait-480x854',
  RecordSettingsRequestQuality.portrait720x1280: 'portrait-720x1280',
  RecordSettingsRequestQuality.unknown: '_unknown',
};
