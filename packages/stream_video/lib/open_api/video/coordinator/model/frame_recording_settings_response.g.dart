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
  mode: FrameRecordingSettingsResponseMode.fromJson(json['mode'] as String),
  quality: json['quality'] as String?,
);

Map<String, dynamic> _$FrameRecordingSettingsResponseToJson(
  FrameRecordingSettingsResponse instance,
) => <String, dynamic>{
  'capture_interval_in_seconds': instance.captureIntervalInSeconds,
  'mode': instance.mode.toJson(),
  'quality': instance.quality,
};
