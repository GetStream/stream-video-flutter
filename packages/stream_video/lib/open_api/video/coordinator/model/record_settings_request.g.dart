// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSettingsRequest _$RecordSettingsRequestFromJson(
  Map<String, dynamic> json,
) => RecordSettingsRequest(
  audioOnly: json['audio_only'] as bool?,
  mode: json['mode'] as FeatureActivationMode,
  quality: json['quality'] as RecordSettingsRequestQuality?,
);

Map<String, dynamic> _$RecordSettingsRequestToJson(
  RecordSettingsRequest instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': instance.mode,
  'quality': instance.quality,
};
