// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptionSettingsRequest _$TranscriptionSettingsRequestFromJson(
  Map<String, dynamic> json,
) => TranscriptionSettingsRequest(
  closedCaptionMode: $enumDecodeNullable(
    _$TranscriptionSettingsRequestClosedCaptionModeEnumMap,
    json['closed_caption_mode'],
    unknownValue: TranscriptionSettingsRequestClosedCaptionMode.unknown,
  ),
  language: $enumDecodeNullable(
    _$TranscriptionSettingsRequestLanguageEnumMap,
    json['language'],
    unknownValue: TranscriptionSettingsRequestLanguage.unknown,
  ),
  mode: $enumDecodeNullable(
    _$TranscriptionSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: TranscriptionSettingsRequestMode.unknown,
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

Map<String, dynamic> _$TranscriptionSettingsRequestToJson(
  TranscriptionSettingsRequest instance,
) => <String, dynamic>{
  'closed_caption_mode':
      _$TranscriptionSettingsRequestClosedCaptionModeEnumMap[instance
          .closedCaptionMode],
  'language': _$TranscriptionSettingsRequestLanguageEnumMap[instance.language],
  'mode': _$TranscriptionSettingsRequestModeEnumMap[instance.mode],
  'speech_segment_config': instance.speechSegmentConfig,
  'translation': instance.translation,
};

const _$TranscriptionSettingsRequestClosedCaptionModeEnumMap = {
  TranscriptionSettingsRequestClosedCaptionMode.autoOn: 'auto-on',
  TranscriptionSettingsRequestClosedCaptionMode.available: 'available',
  TranscriptionSettingsRequestClosedCaptionMode.disabled: 'disabled',
  TranscriptionSettingsRequestClosedCaptionMode.unknown: '_unknown',
};

const _$TranscriptionSettingsRequestLanguageEnumMap = {
  TranscriptionSettingsRequestLanguage.ar: 'ar',
  TranscriptionSettingsRequestLanguage.auto: 'auto',
  TranscriptionSettingsRequestLanguage.bg: 'bg',
  TranscriptionSettingsRequestLanguage.ca: 'ca',
  TranscriptionSettingsRequestLanguage.cs: 'cs',
  TranscriptionSettingsRequestLanguage.da: 'da',
  TranscriptionSettingsRequestLanguage.de: 'de',
  TranscriptionSettingsRequestLanguage.el: 'el',
  TranscriptionSettingsRequestLanguage.en: 'en',
  TranscriptionSettingsRequestLanguage.es: 'es',
  TranscriptionSettingsRequestLanguage.et: 'et',
  TranscriptionSettingsRequestLanguage.fi: 'fi',
  TranscriptionSettingsRequestLanguage.fr: 'fr',
  TranscriptionSettingsRequestLanguage.he: 'he',
  TranscriptionSettingsRequestLanguage.hi: 'hi',
  TranscriptionSettingsRequestLanguage.hr: 'hr',
  TranscriptionSettingsRequestLanguage.hu: 'hu',
  TranscriptionSettingsRequestLanguage.id: 'id',
  TranscriptionSettingsRequestLanguage.it: 'it',
  TranscriptionSettingsRequestLanguage.ja: 'ja',
  TranscriptionSettingsRequestLanguage.ko: 'ko',
  TranscriptionSettingsRequestLanguage.ms: 'ms',
  TranscriptionSettingsRequestLanguage.nl: 'nl',
  TranscriptionSettingsRequestLanguage.no: 'no',
  TranscriptionSettingsRequestLanguage.pl: 'pl',
  TranscriptionSettingsRequestLanguage.pt: 'pt',
  TranscriptionSettingsRequestLanguage.ro: 'ro',
  TranscriptionSettingsRequestLanguage.ru: 'ru',
  TranscriptionSettingsRequestLanguage.sk: 'sk',
  TranscriptionSettingsRequestLanguage.sl: 'sl',
  TranscriptionSettingsRequestLanguage.sv: 'sv',
  TranscriptionSettingsRequestLanguage.ta: 'ta',
  TranscriptionSettingsRequestLanguage.th: 'th',
  TranscriptionSettingsRequestLanguage.tl: 'tl',
  TranscriptionSettingsRequestLanguage.tr: 'tr',
  TranscriptionSettingsRequestLanguage.uk: 'uk',
  TranscriptionSettingsRequestLanguage.zh: 'zh',
  TranscriptionSettingsRequestLanguage.unknown: '_unknown',
};

const _$TranscriptionSettingsRequestModeEnumMap = {
  TranscriptionSettingsRequestMode.autoOn: 'auto-on',
  TranscriptionSettingsRequestMode.available: 'available',
  TranscriptionSettingsRequestMode.disabled: 'disabled',
  TranscriptionSettingsRequestMode.unknown: '_unknown',
};
