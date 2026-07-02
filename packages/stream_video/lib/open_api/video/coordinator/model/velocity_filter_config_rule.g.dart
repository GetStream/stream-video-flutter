// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'velocity_filter_config_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VelocityFilterConfigRule _$VelocityFilterConfigRuleFromJson(
  Map<String, dynamic> json,
) => VelocityFilterConfigRule(
  action: $enumDecode(
    _$VelocityFilterConfigRuleActionEnumMap,
    json['action'],
    unknownValue: VelocityFilterConfigRuleAction.unknown,
  ),
  banDuration: (json['ban_duration'] as num).toInt(),
  cascadingAction: $enumDecode(
    _$VelocityFilterConfigRuleCascadingActionEnumMap,
    json['cascading_action'],
    unknownValue: VelocityFilterConfigRuleCascadingAction.unknown,
  ),
  cascadingThreshold: (json['cascading_threshold'] as num).toInt(),
  checkMessageContext: json['check_message_context'] as bool,
  fastSpamThreshold: (json['fast_spam_threshold'] as num).toInt(),
  fastSpamTtl: (json['fast_spam_ttl'] as num).toInt(),
  ipBan: json['ip_ban'] as bool,
  probationPeriod: (json['probation_period'] as num).toInt(),
  shadowBan: json['shadow_ban'] as bool,
  slowSpamBanDuration: (json['slow_spam_ban_duration'] as num?)?.toInt(),
  slowSpamThreshold: (json['slow_spam_threshold'] as num).toInt(),
  slowSpamTtl: (json['slow_spam_ttl'] as num).toInt(),
  urlOnly: json['url_only'] as bool,
);

Map<String, dynamic> _$VelocityFilterConfigRuleToJson(
  VelocityFilterConfigRule instance,
) => <String, dynamic>{
  'action': _$VelocityFilterConfigRuleActionEnumMap[instance.action]!,
  'ban_duration': instance.banDuration,
  'cascading_action':
      _$VelocityFilterConfigRuleCascadingActionEnumMap[instance
          .cascadingAction]!,
  'cascading_threshold': instance.cascadingThreshold,
  'check_message_context': instance.checkMessageContext,
  'fast_spam_threshold': instance.fastSpamThreshold,
  'fast_spam_ttl': instance.fastSpamTtl,
  'ip_ban': instance.ipBan,
  'probation_period': instance.probationPeriod,
  'shadow_ban': instance.shadowBan,
  'slow_spam_ban_duration': instance.slowSpamBanDuration,
  'slow_spam_threshold': instance.slowSpamThreshold,
  'slow_spam_ttl': instance.slowSpamTtl,
  'url_only': instance.urlOnly,
};

const _$VelocityFilterConfigRuleActionEnumMap = {
  VelocityFilterConfigRuleAction.ban: 'ban',
  VelocityFilterConfigRuleAction.flag: 'flag',
  VelocityFilterConfigRuleAction.remove: 'remove',
  VelocityFilterConfigRuleAction.shadow: 'shadow',
  VelocityFilterConfigRuleAction.unknown: '_unknown',
};

const _$VelocityFilterConfigRuleCascadingActionEnumMap = {
  VelocityFilterConfigRuleCascadingAction.ban: 'ban',
  VelocityFilterConfigRuleCascadingAction.flag: 'flag',
  VelocityFilterConfigRuleCascadingAction.remove: 'remove',
  VelocityFilterConfigRuleCascadingAction.shadow: 'shadow',
  VelocityFilterConfigRuleCascadingAction.unknown: '_unknown',
};
