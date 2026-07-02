// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSettingsResponse _$RecordSettingsResponseFromJson(
  Map<String, dynamic> json,
) => RecordSettingsResponse(
  audioOnly: json['audio_only'] as bool,
  mode: json['mode'] as String,
  quality: json['quality'] as String,
);

Map<String, dynamic> _$RecordSettingsResponseToJson(
  RecordSettingsResponse instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': instance.mode,
  'quality': instance.quality,
};
