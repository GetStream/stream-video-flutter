// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationSettings _$TranslationSettingsFromJson(Map<String, dynamic> json) =>
    TranslationSettings(
      enabled: json['enabled'] as bool?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => TranslationSettingsLanguages.fromJson(e as String))
          .toList(),
    );

Map<String, dynamic> _$TranslationSettingsToJson(
  TranslationSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'languages': instance.languages?.map((e) => e.toJson()).toList(),
};
