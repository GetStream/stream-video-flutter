// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMRule _$LLMRuleFromJson(Map<String, dynamic> json) => LLMRule(
  action: $enumDecode(
    _$LLMRuleActionEnumMap,
    json['action'],
    unknownValue: LLMRuleAction.unknown,
  ),
  description: json['description'] as String,
  label: json['label'] as String,
  severityRules:
      (json['severity_rules'] as List<dynamic>?)
          ?.map(
            (e) => BodyguardSeverityRule.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$LLMRuleToJson(LLMRule instance) => <String, dynamic>{
  'action': _$LLMRuleActionEnumMap[instance.action]!,
  'description': instance.description,
  'label': instance.label,
  'severity_rules': instance.severityRules,
};

const _$LLMRuleActionEnumMap = {
  LLMRuleAction.bounce: 'bounce',
  LLMRuleAction.bounceFlag: 'bounce_flag',
  LLMRuleAction.bounceRemove: 'bounce_remove',
  LLMRuleAction.flag: 'flag',
  LLMRuleAction.keep: 'keep',
  LLMRuleAction.remove: 'remove',
  LLMRuleAction.shadow: 'shadow',
  LLMRuleAction.unknown: '_unknown',
};
