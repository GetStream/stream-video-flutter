// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aws_rekognition_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AWSRekognitionRule _$AWSRekognitionRuleFromJson(Map<String, dynamic> json) =>
    AWSRekognitionRule(
      action: $enumDecode(
        _$AWSRekognitionRuleActionEnumMap,
        json['action'],
        unknownValue: AWSRekognitionRuleAction.unknown,
      ),
      label: json['label'] as String,
      minConfidence: (json['min_confidence'] as num).toDouble(),
      subclassifications: json['subclassifications'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AWSRekognitionRuleToJson(AWSRekognitionRule instance) =>
    <String, dynamic>{
      'action': _$AWSRekognitionRuleActionEnumMap[instance.action]!,
      'label': instance.label,
      'min_confidence': instance.minConfidence,
      'subclassifications': instance.subclassifications,
    };

const _$AWSRekognitionRuleActionEnumMap = {
  AWSRekognitionRuleAction.bounce: 'bounce',
  AWSRekognitionRuleAction.bounceFlag: 'bounce_flag',
  AWSRekognitionRuleAction.bounceRemove: 'bounce_remove',
  AWSRekognitionRuleAction.flag: 'flag',
  AWSRekognitionRuleAction.remove: 'remove',
  AWSRekognitionRuleAction.shadow: 'shadow',
  AWSRekognitionRuleAction.unknown: '_unknown',
};
