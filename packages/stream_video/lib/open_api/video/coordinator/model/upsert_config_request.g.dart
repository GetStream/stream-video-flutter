// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertConfigRequest _$UpsertConfigRequestFromJson(
  Map<String, dynamic> json,
) => UpsertConfigRequest(
  aiImageConfig: json['ai_image_config'] == null
      ? null
      : AIImageConfig.fromJson(json['ai_image_config'] as Map<String, dynamic>),
  aiTextConfig: json['ai_text_config'] == null
      ? null
      : AITextConfig.fromJson(json['ai_text_config'] as Map<String, dynamic>),
  aiVideoConfig: json['ai_video_config'] == null
      ? null
      : AIVideoConfig.fromJson(json['ai_video_config'] as Map<String, dynamic>),
  async: json['async'] as bool?,
  automodPlatformCircumventionConfig:
      json['automod_platform_circumvention_config'] == null
      ? null
      : AutomodPlatformCircumventionConfig.fromJson(
          json['automod_platform_circumvention_config'] as Map<String, dynamic>,
        ),
  automodSemanticFiltersConfig: json['automod_semantic_filters_config'] == null
      ? null
      : AutomodSemanticFiltersConfig.fromJson(
          json['automod_semantic_filters_config'] as Map<String, dynamic>,
        ),
  automodToxicityConfig: json['automod_toxicity_config'] == null
      ? null
      : AutomodToxicityConfig.fromJson(
          json['automod_toxicity_config'] as Map<String, dynamic>,
        ),
  awsRekognitionConfig: json['aws_rekognition_config'] == null
      ? null
      : AIImageConfig.fromJson(
          json['aws_rekognition_config'] as Map<String, dynamic>,
        ),
  blockListConfig: json['block_list_config'] == null
      ? null
      : BlockListConfig.fromJson(
          json['block_list_config'] as Map<String, dynamic>,
        ),
  bodyguardConfig: json['bodyguard_config'] == null
      ? null
      : AITextConfig.fromJson(json['bodyguard_config'] as Map<String, dynamic>),
  floodConfig: json['flood_config'] == null
      ? null
      : FloodConfig.fromJson(json['flood_config'] as Map<String, dynamic>),
  googleVisionConfig: json['google_vision_config'] == null
      ? null
      : GoogleVisionConfig.fromJson(
          json['google_vision_config'] as Map<String, dynamic>,
        ),
  key: json['key'] as String,
  llmConfig: json['llm_config'] == null
      ? null
      : LLMConfig.fromJson(json['llm_config'] as Map<String, dynamic>),
  ruleBuilderConfig: json['rule_builder_config'] == null
      ? null
      : RuleBuilderConfig.fromJson(
          json['rule_builder_config'] as Map<String, dynamic>,
        ),
  team: json['team'] as String?,
  velocityFilterConfig: json['velocity_filter_config'] == null
      ? null
      : VelocityFilterConfig.fromJson(
          json['velocity_filter_config'] as Map<String, dynamic>,
        ),
  videoCallRuleConfig: json['video_call_rule_config'] == null
      ? null
      : VideoCallRuleConfig.fromJson(
          json['video_call_rule_config'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UpsertConfigRequestToJson(
  UpsertConfigRequest instance,
) => <String, dynamic>{
  'ai_image_config': instance.aiImageConfig,
  'ai_text_config': instance.aiTextConfig,
  'ai_video_config': instance.aiVideoConfig,
  'async': instance.async,
  'automod_platform_circumvention_config':
      instance.automodPlatformCircumventionConfig,
  'automod_semantic_filters_config': instance.automodSemanticFiltersConfig,
  'automod_toxicity_config': instance.automodToxicityConfig,
  'aws_rekognition_config': instance.awsRekognitionConfig,
  'block_list_config': instance.blockListConfig,
  'bodyguard_config': instance.bodyguardConfig,
  'flood_config': instance.floodConfig,
  'google_vision_config': instance.googleVisionConfig,
  'key': instance.key,
  'llm_config': instance.llmConfig,
  'rule_builder_config': instance.ruleBuilderConfig,
  'team': instance.team,
  'velocity_filter_config': instance.velocityFilterConfig,
  'video_call_rule_config': instance.videoCallRuleConfig,
};
