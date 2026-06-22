// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRRule _$OCRRuleFromJson(Map<String, dynamic> json) => OCRRule(
  action: $enumDecode(
    _$OCRRuleActionEnumMap,
    json['action'],
    unknownValue: OCRRuleAction.unknown,
  ),
  label: json['label'] as String,
);

Map<String, dynamic> _$OCRRuleToJson(OCRRule instance) => <String, dynamic>{
  'action': _$OCRRuleActionEnumMap[instance.action]!,
  'label': instance.label,
};

const _$OCRRuleActionEnumMap = {
  OCRRuleAction.bounce: 'bounce',
  OCRRuleAction.bounceFlag: 'bounce_flag',
  OCRRuleAction.bounceRemove: 'bounce_remove',
  OCRRuleAction.flag: 'flag',
  OCRRuleAction.remove: 'remove',
  OCRRuleAction.shadow: 'shadow',
  OCRRuleAction.unknown: '_unknown',
};
