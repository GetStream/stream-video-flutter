// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_severity_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardSeverityRule _$BodyguardSeverityRuleFromJson(
  Map<String, dynamic> json,
) => BodyguardSeverityRule(
  action: $enumDecode(
    _$BodyguardSeverityRuleActionEnumMap,
    json['action'],
    unknownValue: BodyguardSeverityRuleAction.unknown,
  ),
  severity: $enumDecode(
    _$BodyguardSeverityRuleSeverityEnumMap,
    json['severity'],
    unknownValue: BodyguardSeverityRuleSeverity.unknown,
  ),
);

Map<String, dynamic> _$BodyguardSeverityRuleToJson(
  BodyguardSeverityRule instance,
) => <String, dynamic>{
  'action': _$BodyguardSeverityRuleActionEnumMap[instance.action]!,
  'severity': _$BodyguardSeverityRuleSeverityEnumMap[instance.severity]!,
};

const _$BodyguardSeverityRuleActionEnumMap = {
  BodyguardSeverityRuleAction.bounce: 'bounce',
  BodyguardSeverityRuleAction.bounceFlag: 'bounce_flag',
  BodyguardSeverityRuleAction.bounceRemove: 'bounce_remove',
  BodyguardSeverityRuleAction.flag: 'flag',
  BodyguardSeverityRuleAction.keep: 'keep',
  BodyguardSeverityRuleAction.mask: 'mask',
  BodyguardSeverityRuleAction.remove: 'remove',
  BodyguardSeverityRuleAction.shadow: 'shadow',
  BodyguardSeverityRuleAction.unknown: '_unknown',
};

const _$BodyguardSeverityRuleSeverityEnumMap = {
  BodyguardSeverityRuleSeverity.critical: 'critical',
  BodyguardSeverityRuleSeverity.high: 'high',
  BodyguardSeverityRuleSeverity.low: 'low',
  BodyguardSeverityRuleSeverity.medium: 'medium',
  BodyguardSeverityRuleSeverity.unknown: '_unknown',
};
