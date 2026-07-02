// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_semantic_filters_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodSemanticFiltersRule _$AutomodSemanticFiltersRuleFromJson(
  Map<String, dynamic> json,
) => AutomodSemanticFiltersRule(
  action: $enumDecode(
    _$AutomodSemanticFiltersRuleActionEnumMap,
    json['action'],
    unknownValue: AutomodSemanticFiltersRuleAction.unknown,
  ),
  name: json['name'] as String,
  threshold: (json['threshold'] as num).toDouble(),
);

Map<String, dynamic> _$AutomodSemanticFiltersRuleToJson(
  AutomodSemanticFiltersRule instance,
) => <String, dynamic>{
  'action': _$AutomodSemanticFiltersRuleActionEnumMap[instance.action]!,
  'name': instance.name,
  'threshold': instance.threshold,
};

const _$AutomodSemanticFiltersRuleActionEnumMap = {
  AutomodSemanticFiltersRuleAction.bounce: 'bounce',
  AutomodSemanticFiltersRuleAction.bounceFlag: 'bounce_flag',
  AutomodSemanticFiltersRuleAction.bounceRemove: 'bounce_remove',
  AutomodSemanticFiltersRuleAction.flag: 'flag',
  AutomodSemanticFiltersRuleAction.remove: 'remove',
  AutomodSemanticFiltersRuleAction.shadow: 'shadow',
  AutomodSemanticFiltersRuleAction.unknown: '_unknown',
};
