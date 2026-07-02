// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_recording_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameRecordingSettingsRequest _$FrameRecordingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => FrameRecordingSettingsRequest(
  captureIntervalInSeconds: (json['capture_interval_in_seconds'] as num)
      .toInt(),
  mode: $enumDecode(
    _$FrameRecordingSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: FrameRecordingSettingsRequestMode.unknown,
  ),
  quality: $enumDecodeNullable(
    _$FrameRecordingSettingsRequestQualityEnumMap,
    json['quality'],
    unknownValue: FrameRecordingSettingsRequestQuality.unknown,
  ),
);

Map<String, dynamic> _$FrameRecordingSettingsRequestToJson(
  FrameRecordingSettingsRequest instance,
) => <String, dynamic>{
  'capture_interval_in_seconds': instance.captureIntervalInSeconds,
  'mode': _$FrameRecordingSettingsRequestModeEnumMap[instance.mode]!,
  'quality': _$FrameRecordingSettingsRequestQualityEnumMap[instance.quality],
};

const _$FrameRecordingSettingsRequestModeEnumMap = {
  FrameRecordingSettingsRequestMode.autoOn: 'auto-on',
  FrameRecordingSettingsRequestMode.available: 'available',
  FrameRecordingSettingsRequestMode.disabled: 'disabled',
  FrameRecordingSettingsRequestMode.unknown: '_unknown',
};

const _$FrameRecordingSettingsRequestQualityEnumMap = {
  FrameRecordingSettingsRequestQuality.n1080p: '1080p',
  FrameRecordingSettingsRequestQuality.n1440p: '1440p',
  FrameRecordingSettingsRequestQuality.n360p: '360p',
  FrameRecordingSettingsRequestQuality.n480p: '480p',
  FrameRecordingSettingsRequestQuality.n720p: '720p',
  FrameRecordingSettingsRequestQuality.unknown: '_unknown',
};
