// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListRule _$BlockListRuleFromJson(Map<String, dynamic> json) =>
    BlockListRule(
      action: $enumDecode(
        _$BlockListRuleActionEnumMap,
        json['action'],
        unknownValue: BlockListRuleAction.unknown,
      ),
      name: json['name'] as String,
      team: json['team'] as String,
    );

Map<String, dynamic> _$BlockListRuleToJson(BlockListRule instance) =>
    <String, dynamic>{
      'action': _$BlockListRuleActionEnumMap[instance.action]!,
      'name': instance.name,
      'team': instance.team,
    };

const _$BlockListRuleActionEnumMap = {
  BlockListRuleAction.bounce: 'bounce',
  BlockListRuleAction.bounceFlag: 'bounce_flag',
  BlockListRuleAction.bounceRemove: 'bounce_remove',
  BlockListRuleAction.flag: 'flag',
  BlockListRuleAction.mask: 'mask',
  BlockListRuleAction.maskFlag: 'mask_flag',
  BlockListRuleAction.remove: 'remove',
  BlockListRuleAction.shadow: 'shadow',
  BlockListRuleAction.unknown: '_unknown',
};
