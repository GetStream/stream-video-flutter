// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_transcription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartTranscriptionRequest _$StartTranscriptionRequestFromJson(
  Map<String, dynamic> json,
) => StartTranscriptionRequest(
  enableClosedCaptions: json['enable_closed_captions'] as bool?,
  language: json['language'] as TranscriptionLanguage?,
  transcriptionExternalStorage:
      json['transcription_external_storage'] as String?,
);

Map<String, dynamic> _$StartTranscriptionRequestToJson(
  StartTranscriptionRequest instance,
) => <String, dynamic>{
  'enable_closed_captions': instance.enableClosedCaptions,
  'language': instance.language,
  'transcription_external_storage': instance.transcriptionExternalStorage,
};
