// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardRule _$BodyguardRuleFromJson(Map<String, dynamic> json) =>
    BodyguardRule(
      action: $enumDecode(
        _$BodyguardRuleActionEnumMap,
        json['action'],
        unknownValue: BodyguardRuleAction.unknown,
      ),
      label: json['label'] as String,
      severityRules:
          (json['severity_rules'] as List<dynamic>?)
              ?.map(
                (e) =>
                    BodyguardSeverityRule.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$BodyguardRuleToJson(BodyguardRule instance) =>
    <String, dynamic>{
      'action': _$BodyguardRuleActionEnumMap[instance.action]!,
      'label': instance.label,
      'severity_rules': instance.severityRules.map((e) => e.toJson()).toList(),
    };

const _$BodyguardRuleActionEnumMap = {
  BodyguardRuleAction.bounce: 'bounce',
  BodyguardRuleAction.bounceFlag: 'bounce_flag',
  BodyguardRuleAction.bounceRemove: 'bounce_remove',
  BodyguardRuleAction.flag: 'flag',
  BodyguardRuleAction.keep: 'keep',
  BodyguardRuleAction.mask: 'mask',
  BodyguardRuleAction.maskFlag: 'mask_flag',
  BodyguardRuleAction.remove: 'remove',
  BodyguardRuleAction.shadow: 'shadow',
  BodyguardRuleAction.unknown: '_unknown',
};
