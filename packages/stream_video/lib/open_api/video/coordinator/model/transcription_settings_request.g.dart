// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptionSettingsRequest _$TranscriptionSettingsRequestFromJson(
  Map<String, dynamic> json,
) => TranscriptionSettingsRequest(
  closedCaptionMode: json['closed_caption_mode'] as FeatureActivationMode?,
  language: json['language'] as TranscriptionLanguage?,
  mode: json['mode'] as FeatureActivationMode?,
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

Map<String, dynamic> _$TranscriptionSettingsRequestToJson(
  TranscriptionSettingsRequest instance,
) => <String, dynamic>{
  'closed_caption_mode': instance.closedCaptionMode,
  'language': instance.language,
  'mode': instance.mode,
  'speech_segment_config': instance.speechSegmentConfig?.toJson(),
  'translation': instance.translation?.toJson(),
};
