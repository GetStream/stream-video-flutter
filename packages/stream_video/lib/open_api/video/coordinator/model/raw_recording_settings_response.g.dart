// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_recording_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawRecordingSettingsResponse _$RawRecordingSettingsResponseFromJson(
  Map<String, dynamic> json,
) => RawRecordingSettingsResponse(
  audioOnly: json['audio_only'] as bool?,
  mode: RawRecordingSettingsResponseMode.fromJson(json['mode'] as String),
);

Map<String, dynamic> _$RawRecordingSettingsResponseToJson(
  RawRecordingSettingsResponse instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': instance.mode.toJson(),
};
