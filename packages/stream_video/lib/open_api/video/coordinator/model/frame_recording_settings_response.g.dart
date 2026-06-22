// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_recording_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameRecordingSettingsResponse _$FrameRecordingSettingsResponseFromJson(
  Map<String, dynamic> json,
) => FrameRecordingSettingsResponse(
  captureIntervalInSeconds: (json['capture_interval_in_seconds'] as num)
      .toInt(),
  mode: $enumDecode(
    _$FrameRecordingSettingsResponseModeEnumMap,
    json['mode'],
    unknownValue: FrameRecordingSettingsResponseMode.unknown,
  ),
  quality: json['quality'] as String?,
);

Map<String, dynamic> _$FrameRecordingSettingsResponseToJson(
  FrameRecordingSettingsResponse instance,
) => <String, dynamic>{
  'capture_interval_in_seconds': instance.captureIntervalInSeconds,
  'mode': _$FrameRecordingSettingsResponseModeEnumMap[instance.mode]!,
  'quality': instance.quality,
};

const _$FrameRecordingSettingsResponseModeEnumMap = {
  FrameRecordingSettingsResponseMode.autoOn: 'auto-on',
  FrameRecordingSettingsResponseMode.available: 'available',
  FrameRecordingSettingsResponseMode.disabled: 'disabled',
  FrameRecordingSettingsResponseMode.unknown: '_unknown',
};
