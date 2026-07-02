// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationSettings _$TranslationSettingsFromJson(Map<String, dynamic> json) =>
    TranslationSettings(
      enabled: json['enabled'] as bool?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map(
            (e) => $enumDecode(
              _$TranslationSettingsLanguagesEnumMap,
              e,
              unknownValue: TranslationSettingsLanguages.unknown,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$TranslationSettingsToJson(
  TranslationSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'languages': instance.languages
      ?.map((e) => _$TranslationSettingsLanguagesEnumMap[e]!)
      .toList(),
};

const _$TranslationSettingsLanguagesEnumMap = {
  TranslationSettingsLanguages.ar: 'ar',
  TranslationSettingsLanguages.ca: 'ca',
  TranslationSettingsLanguages.cs: 'cs',
  TranslationSettingsLanguages.da: 'da',
  TranslationSettingsLanguages.de: 'de',
  TranslationSettingsLanguages.el: 'el',
  TranslationSettingsLanguages.en: 'en',
  TranslationSettingsLanguages.es: 'es',
  TranslationSettingsLanguages.fi: 'fi',
  TranslationSettingsLanguages.fr: 'fr',
  TranslationSettingsLanguages.he: 'he',
  TranslationSettingsLanguages.hi: 'hi',
  TranslationSettingsLanguages.hr: 'hr',
  TranslationSettingsLanguages.hu: 'hu',
  TranslationSettingsLanguages.id: 'id',
  TranslationSettingsLanguages.it: 'it',
  TranslationSettingsLanguages.ja: 'ja',
  TranslationSettingsLanguages.ko: 'ko',
  TranslationSettingsLanguages.ms: 'ms',
  TranslationSettingsLanguages.nl: 'nl',
  TranslationSettingsLanguages.no: 'no',
  TranslationSettingsLanguages.pl: 'pl',
  TranslationSettingsLanguages.pt: 'pt',
  TranslationSettingsLanguages.ro: 'ro',
  TranslationSettingsLanguages.ru: 'ru',
  TranslationSettingsLanguages.sv: 'sv',
  TranslationSettingsLanguages.ta: 'ta',
  TranslationSettingsLanguages.th: 'th',
  TranslationSettingsLanguages.tl: 'tl',
  TranslationSettingsLanguages.tr: 'tr',
  TranslationSettingsLanguages.uk: 'uk',
  TranslationSettingsLanguages.zh: 'zh',
  TranslationSettingsLanguages.unknown: '_unknown',
};
