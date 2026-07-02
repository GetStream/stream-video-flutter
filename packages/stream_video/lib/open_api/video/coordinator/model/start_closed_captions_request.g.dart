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
  language: $enumDecodeNullable(
    _$StartClosedCaptionsRequestLanguageEnumMap,
    json['language'],
    unknownValue: StartClosedCaptionsRequestLanguage.unknown,
  ),
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
  'language': _$StartClosedCaptionsRequestLanguageEnumMap[instance.language],
  'speech_segment_config': instance.speechSegmentConfig?.toJson(),
};

const _$StartClosedCaptionsRequestLanguageEnumMap = {
  StartClosedCaptionsRequestLanguage.ar: 'ar',
  StartClosedCaptionsRequestLanguage.auto: 'auto',
  StartClosedCaptionsRequestLanguage.bg: 'bg',
  StartClosedCaptionsRequestLanguage.ca: 'ca',
  StartClosedCaptionsRequestLanguage.cs: 'cs',
  StartClosedCaptionsRequestLanguage.da: 'da',
  StartClosedCaptionsRequestLanguage.de: 'de',
  StartClosedCaptionsRequestLanguage.el: 'el',
  StartClosedCaptionsRequestLanguage.en: 'en',
  StartClosedCaptionsRequestLanguage.es: 'es',
  StartClosedCaptionsRequestLanguage.et: 'et',
  StartClosedCaptionsRequestLanguage.fi: 'fi',
  StartClosedCaptionsRequestLanguage.fr: 'fr',
  StartClosedCaptionsRequestLanguage.he: 'he',
  StartClosedCaptionsRequestLanguage.hi: 'hi',
  StartClosedCaptionsRequestLanguage.hr: 'hr',
  StartClosedCaptionsRequestLanguage.hu: 'hu',
  StartClosedCaptionsRequestLanguage.id: 'id',
  StartClosedCaptionsRequestLanguage.it: 'it',
  StartClosedCaptionsRequestLanguage.ja: 'ja',
  StartClosedCaptionsRequestLanguage.ko: 'ko',
  StartClosedCaptionsRequestLanguage.ms: 'ms',
  StartClosedCaptionsRequestLanguage.nl: 'nl',
  StartClosedCaptionsRequestLanguage.no: 'no',
  StartClosedCaptionsRequestLanguage.pl: 'pl',
  StartClosedCaptionsRequestLanguage.pt: 'pt',
  StartClosedCaptionsRequestLanguage.ro: 'ro',
  StartClosedCaptionsRequestLanguage.ru: 'ru',
  StartClosedCaptionsRequestLanguage.sk: 'sk',
  StartClosedCaptionsRequestLanguage.sl: 'sl',
  StartClosedCaptionsRequestLanguage.sv: 'sv',
  StartClosedCaptionsRequestLanguage.ta: 'ta',
  StartClosedCaptionsRequestLanguage.th: 'th',
  StartClosedCaptionsRequestLanguage.tl: 'tl',
  StartClosedCaptionsRequestLanguage.tr: 'tr',
  StartClosedCaptionsRequestLanguage.uk: 'uk',
  StartClosedCaptionsRequestLanguage.zh: 'zh',
  StartClosedCaptionsRequestLanguage.unknown: '_unknown',
};
