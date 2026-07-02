// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_segment_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeechSegmentConfig _$SpeechSegmentConfigFromJson(Map<String, dynamic> json) =>
    SpeechSegmentConfig(
      maxSpeechCaptionMs: (json['max_speech_caption_ms'] as num?)?.toInt(),
      silenceDurationMs: (json['silence_duration_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpeechSegmentConfigToJson(
  SpeechSegmentConfig instance,
) => <String, dynamic>{
  'max_speech_caption_ms': instance.maxSpeechCaptionMs,
  'silence_duration_ms': instance.silenceDurationMs,
};
