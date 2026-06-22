// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptionSettingsResponse _$TranscriptionSettingsResponseFromJson(
  Map<String, dynamic> json,
) => TranscriptionSettingsResponse(
  closedCaptionMode: $enumDecode(
    _$TranscriptionSettingsResponseClosedCaptionModeEnumMap,
    json['closed_caption_mode'],
    unknownValue: TranscriptionSettingsResponseClosedCaptionMode.unknown,
  ),
  language: $enumDecode(
    _$TranscriptionSettingsResponseLanguageEnumMap,
    json['language'],
    unknownValue: TranscriptionSettingsResponseLanguage.unknown,
  ),
  mode: $enumDecode(
    _$TranscriptionSettingsResponseModeEnumMap,
    json['mode'],
    unknownValue: TranscriptionSettingsResponseMode.unknown,
  ),
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
  'closed_caption_mode':
      _$TranscriptionSettingsResponseClosedCaptionModeEnumMap[instance
          .closedCaptionMode]!,
  'language':
      _$TranscriptionSettingsResponseLanguageEnumMap[instance.language]!,
  'mode': _$TranscriptionSettingsResponseModeEnumMap[instance.mode]!,
  'speech_segment_config': instance.speechSegmentConfig,
  'translation': instance.translation,
};

const _$TranscriptionSettingsResponseClosedCaptionModeEnumMap = {
  TranscriptionSettingsResponseClosedCaptionMode.autoOn: 'auto-on',
  TranscriptionSettingsResponseClosedCaptionMode.available: 'available',
  TranscriptionSettingsResponseClosedCaptionMode.disabled: 'disabled',
  TranscriptionSettingsResponseClosedCaptionMode.unknown: '_unknown',
};

const _$TranscriptionSettingsResponseLanguageEnumMap = {
  TranscriptionSettingsResponseLanguage.ar: 'ar',
  TranscriptionSettingsResponseLanguage.auto: 'auto',
  TranscriptionSettingsResponseLanguage.bg: 'bg',
  TranscriptionSettingsResponseLanguage.ca: 'ca',
  TranscriptionSettingsResponseLanguage.cs: 'cs',
  TranscriptionSettingsResponseLanguage.da: 'da',
  TranscriptionSettingsResponseLanguage.de: 'de',
  TranscriptionSettingsResponseLanguage.el: 'el',
  TranscriptionSettingsResponseLanguage.en: 'en',
  TranscriptionSettingsResponseLanguage.es: 'es',
  TranscriptionSettingsResponseLanguage.et: 'et',
  TranscriptionSettingsResponseLanguage.fi: 'fi',
  TranscriptionSettingsResponseLanguage.fr: 'fr',
  TranscriptionSettingsResponseLanguage.he: 'he',
  TranscriptionSettingsResponseLanguage.hi: 'hi',
  TranscriptionSettingsResponseLanguage.hr: 'hr',
  TranscriptionSettingsResponseLanguage.hu: 'hu',
  TranscriptionSettingsResponseLanguage.id: 'id',
  TranscriptionSettingsResponseLanguage.it: 'it',
  TranscriptionSettingsResponseLanguage.ja: 'ja',
  TranscriptionSettingsResponseLanguage.ko: 'ko',
  TranscriptionSettingsResponseLanguage.ms: 'ms',
  TranscriptionSettingsResponseLanguage.nl: 'nl',
  TranscriptionSettingsResponseLanguage.no: 'no',
  TranscriptionSettingsResponseLanguage.pl: 'pl',
  TranscriptionSettingsResponseLanguage.pt: 'pt',
  TranscriptionSettingsResponseLanguage.ro: 'ro',
  TranscriptionSettingsResponseLanguage.ru: 'ru',
  TranscriptionSettingsResponseLanguage.sk: 'sk',
  TranscriptionSettingsResponseLanguage.sl: 'sl',
  TranscriptionSettingsResponseLanguage.sv: 'sv',
  TranscriptionSettingsResponseLanguage.ta: 'ta',
  TranscriptionSettingsResponseLanguage.th: 'th',
  TranscriptionSettingsResponseLanguage.tl: 'tl',
  TranscriptionSettingsResponseLanguage.tr: 'tr',
  TranscriptionSettingsResponseLanguage.uk: 'uk',
  TranscriptionSettingsResponseLanguage.zh: 'zh',
  TranscriptionSettingsResponseLanguage.unknown: '_unknown',
};

const _$TranscriptionSettingsResponseModeEnumMap = {
  TranscriptionSettingsResponseMode.autoOn: 'auto-on',
  TranscriptionSettingsResponseMode.available: 'available',
  TranscriptionSettingsResponseMode.disabled: 'disabled',
  TranscriptionSettingsResponseMode.unknown: '_unknown',
};
