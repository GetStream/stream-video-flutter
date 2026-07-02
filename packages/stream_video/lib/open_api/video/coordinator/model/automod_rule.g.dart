// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodRule _$AutomodRuleFromJson(Map<String, dynamic> json) => AutomodRule(
  action: $enumDecode(
    _$AutomodRuleActionEnumMap,
    json['action'],
    unknownValue: AutomodRuleAction.unknown,
  ),
  label: json['label'] as String,
  threshold: (json['threshold'] as num).toDouble(),
);

Map<String, dynamic> _$AutomodRuleToJson(AutomodRule instance) =>
    <String, dynamic>{
      'action': _$AutomodRuleActionEnumMap[instance.action]!,
      'label': instance.label,
      'threshold': instance.threshold,
    };

const _$AutomodRuleActionEnumMap = {
  AutomodRuleAction.bounce: 'bounce',
  AutomodRuleAction.bounceFlag: 'bounce_flag',
  AutomodRuleAction.bounceRemove: 'bounce_remove',
  AutomodRuleAction.flag: 'flag',
  AutomodRuleAction.remove: 'remove',
  AutomodRuleAction.shadow: 'shadow',
  AutomodRuleAction.unknown: '_unknown',
};
