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
  mode: FrameRecordingSettingsRequestMode.fromJson(json['mode'] as String),
  quality: json['quality'] == null
      ? null
      : FrameRecordingSettingsRequestQuality.fromJson(
          json['quality'] as String,
        ),
);

Map<String, dynamic> _$FrameRecordingSettingsRequestToJson(
  FrameRecordingSettingsRequest instance,
) => <String, dynamic>{
  'capture_interval_in_seconds': instance.captureIntervalInSeconds,
  'mode': instance.mode.toJson(),
  'quality': instance.quality?.toJson(),
};
