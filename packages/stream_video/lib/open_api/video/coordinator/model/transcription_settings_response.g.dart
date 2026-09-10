// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptionSettingsResponse _$TranscriptionSettingsResponseFromJson(
  Map<String, dynamic> json,
) => TranscriptionSettingsResponse(
  closedCaptionMode: TranscriptionSettingsResponseClosedCaptionMode.fromJson(
    json['closed_caption_mode'] as String,
  ),
  language: TranscriptionSettingsResponseLanguage.fromJson(
    json['language'] as String,
  ),
  mode: TranscriptionSettingsResponseMode.fromJson(json['mode'] as String),
  speechSegmentConfig: json['speech_segment_config'] == null
      ? null
      : SpeechSegmentConfig.fromJson(
          json['speech_segment_config'] as Map<String, dynamic>,
        ),
  translation: json['translation'] == null
      ? null
      : TranslationSettings.fromJson(
          json['translation'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TranscriptionSettingsResponseToJson(
  TranscriptionSettingsResponse instance,
) => <String, dynamic>{
  'closed_caption_mode': instance.closedCaptionMode.toJson(),
  'language': instance.language.toJson(),
  'mode': instance.mode.toJson(),
  'speech_segment_config': instance.speechSegmentConfig?.toJson(),
  'translation': instance.translation?.toJson(),
};
