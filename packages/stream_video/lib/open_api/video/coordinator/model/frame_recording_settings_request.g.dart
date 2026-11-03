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
  mode: json['mode'] as FeatureActivationMode,
  quality: json['quality'] as FrameRecordingSettingsRequestQuality?,
);

Map<String, dynamic> _$FrameRecordingSettingsRequestToJson(
  FrameRecordingSettingsRequest instance,
) => <String, dynamic>{
  'capture_interval_in_seconds': instance.captureIntervalInSeconds,
  'mode': instance.mode,
  'quality': instance.quality,
};
