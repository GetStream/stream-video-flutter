// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSettingsRequest _$RecordSettingsRequestFromJson(
  Map<String, dynamic> json,
) => RecordSettingsRequest(
  audioOnly: json['audio_only'] as bool?,
  mode: RecordSettingsRequestMode.fromJson(json['mode'] as String),
  quality: json['quality'] == null
      ? null
      : RecordSettingsRequestQuality.fromJson(json['quality'] as String),
);

Map<String, dynamic> _$RecordSettingsRequestToJson(
  RecordSettingsRequest instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': instance.mode.toJson(),
  'quality': instance.quality?.toJson(),
};
