// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_transcription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartTranscriptionRequest _$StartTranscriptionRequestFromJson(
  Map<String, dynamic> json,
) => StartTranscriptionRequest(
  enableClosedCaptions: json['enable_closed_captions'] as bool?,
  language: $enumDecodeNullable(
    _$StartTranscriptionRequestLanguageEnumMap,
    json['language'],
    unknownValue: StartTranscriptionRequestLanguage.unknown,
  ),
  transcriptionExternalStorage:
      json['transcription_external_storage'] as String?,
);

Map<String, dynamic> _$StartTranscriptionRequestToJson(
  StartTranscriptionRequest instance,
) => <String, dynamic>{
  'enable_closed_captions': instance.enableClosedCaptions,
  'language': _$StartTranscriptionRequestLanguageEnumMap[instance.language],
  'transcription_external_storage': instance.transcriptionExternalStorage,
};

const _$StartTranscriptionRequestLanguageEnumMap = {
  StartTranscriptionRequestLanguage.ar: 'ar',
  StartTranscriptionRequestLanguage.auto: 'auto',
  StartTranscriptionRequestLanguage.bg: 'bg',
  StartTranscriptionRequestLanguage.ca: 'ca',
  StartTranscriptionRequestLanguage.cs: 'cs',
  StartTranscriptionRequestLanguage.da: 'da',
  StartTranscriptionRequestLanguage.de: 'de',
  StartTranscriptionRequestLanguage.el: 'el',
  StartTranscriptionRequestLanguage.en: 'en',
  StartTranscriptionRequestLanguage.es: 'es',
  StartTranscriptionRequestLanguage.et: 'et',
  StartTranscriptionRequestLanguage.fi: 'fi',
  StartTranscriptionRequestLanguage.fr: 'fr',
  StartTranscriptionRequestLanguage.he: 'he',
  StartTranscriptionRequestLanguage.hi: 'hi',
  StartTranscriptionRequestLanguage.hr: 'hr',
  StartTranscriptionRequestLanguage.hu: 'hu',
  StartTranscriptionRequestLanguage.id: 'id',
  StartTranscriptionRequestLanguage.it: 'it',
  StartTranscriptionRequestLanguage.ja: 'ja',
  StartTranscriptionRequestLanguage.ko: 'ko',
  StartTranscriptionRequestLanguage.ms: 'ms',
  StartTranscriptionRequestLanguage.nl: 'nl',
  StartTranscriptionRequestLanguage.no: 'no',
  StartTranscriptionRequestLanguage.pl: 'pl',
  StartTranscriptionRequestLanguage.pt: 'pt',
  StartTranscriptionRequestLanguage.ro: 'ro',
  StartTranscriptionRequestLanguage.ru: 'ru',
  StartTranscriptionRequestLanguage.sk: 'sk',
  StartTranscriptionRequestLanguage.sl: 'sl',
  StartTranscriptionRequestLanguage.sv: 'sv',
  StartTranscriptionRequestLanguage.ta: 'ta',
  StartTranscriptionRequestLanguage.th: 'th',
  StartTranscriptionRequestLanguage.tl: 'tl',
  StartTranscriptionRequestLanguage.tr: 'tr',
  StartTranscriptionRequestLanguage.uk: 'uk',
  StartTranscriptionRequestLanguage.zh: 'zh',
  StartTranscriptionRequestLanguage.unknown: '_unknown',
};
