// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_builder_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleBuilderAction _$RuleBuilderActionFromJson(Map<String, dynamic> json) =>
    RuleBuilderAction(
      banOptions: json['ban_options'] == null
          ? null
          : BanOptions.fromJson(json['ban_options'] as Map<String, dynamic>),
      callOptions: json['call_options'] == null
          ? null
          : CallActionOptions.fromJson(
              json['call_options'] as Map<String, dynamic>,
            ),
      flagUserOptions: json['flag_user_options'] == null
          ? null
          : FlagUserOptions.fromJson(
              json['flag_user_options'] as Map<String, dynamic>,
            ),
      skipInbox: json['skip_inbox'] as bool?,
      type: $enumDecodeNullable(
        _$RuleBuilderActionTypeEnumMap,
        json['type'],
        unknownValue: RuleBuilderActionType.unknown,
      ),
    );

Map<String, dynamic> _$RuleBuilderActionToJson(RuleBuilderAction instance) =>
    <String, dynamic>{
      'ban_options': instance.banOptions,
      'call_options': instance.callOptions,
      'flag_user_options': instance.flagUserOptions,
      'skip_inbox': instance.skipInbox,
      'type': _$RuleBuilderActionTypeEnumMap[instance.type],
    };

const _$RuleBuilderActionTypeEnumMap = {
  RuleBuilderActionType.banUser: 'ban_user',
  RuleBuilderActionType.blockContent: 'block_content',
  RuleBuilderActionType.blur: 'blur',
  RuleBuilderActionType.bounceContent: 'bounce_content',
  RuleBuilderActionType.bounceFlagContent: 'bounce_flag_content',
  RuleBuilderActionType.bounceRemoveContent: 'bounce_remove_content',
  RuleBuilderActionType.callBlur: 'call_blur',
  RuleBuilderActionType.callWarning: 'call_warning',
  RuleBuilderActionType.endCall: 'end_call',
  RuleBuilderActionType.flagContent: 'flag_content',
  RuleBuilderActionType.flagUser: 'flag_user',
  RuleBuilderActionType.kickUser: 'kick_user',
  RuleBuilderActionType.muteAudio: 'mute_audio',
  RuleBuilderActionType.muteVideo: 'mute_video',
  RuleBuilderActionType.shadowContent: 'shadow_content',
  RuleBuilderActionType.warning: 'warning',
  RuleBuilderActionType.webhookOnly: 'webhook_only',
  RuleBuilderActionType.unknown: '_unknown',
};
