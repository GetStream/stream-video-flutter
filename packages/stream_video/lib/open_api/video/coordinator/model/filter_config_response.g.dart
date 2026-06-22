// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterConfigResponse _$FilterConfigResponseFromJson(
  Map<String, dynamic> json,
) => FilterConfigResponse(
  aiTextLabels: (json['ai_text_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  configKeys: (json['config_keys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  filterableCustomKeys: (json['filterable_custom_keys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  llmLabels: (json['llm_labels'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FilterConfigResponseToJson(
  FilterConfigResponse instance,
) => <String, dynamic>{
  'ai_text_labels': instance.aiTextLabels,
  'config_keys': instance.configKeys,
  'filterable_custom_keys': instance.filterableCustomKeys,
  'llm_labels': instance.llmLabels,
};
