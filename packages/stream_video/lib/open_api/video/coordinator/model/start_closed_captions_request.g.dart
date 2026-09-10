// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_closed_captions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartClosedCaptionsRequest _$StartClosedCaptionsRequestFromJson(
  Map<String, dynamic> json,
) => StartClosedCaptionsRequest(
  enableTranscription: json['enable_transcription'] as bool?,
  externalStorage: json['external_storage'] as String?,
  language: json['language'] == null
      ? null
      : StartClosedCaptionsRequestLanguage.fromJson(json['language'] as String),
  speechSegmentConfig: json['speech_segment_config'] == null
      ? null
      : SpeechSegmentConfig.fromJson(
          json['speech_segment_config'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StartClosedCaptionsRequestToJson(
  StartClosedCaptionsRequest instance,
) => <String, dynamic>{
  'enable_transcription': instance.enableTranscription,
  'external_storage': instance.externalStorage,
  'language': instance.language?.toJson(),
  'speech_segment_config': instance.speechSegmentConfig?.toJson(),
};
