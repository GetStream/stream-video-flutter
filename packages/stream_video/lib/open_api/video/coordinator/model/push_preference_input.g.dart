// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushPreferenceInput _$PushPreferenceInputFromJson(Map<String, dynamic> json) =>
    PushPreferenceInput(
      callLevel: $enumDecodeNullable(
        _$PushPreferenceInputCallLevelEnumMap,
        json['call_level'],
        unknownValue: PushPreferenceInputCallLevel.unknown,
      ),
      channelCid: json['channel_cid'] as String?,
      chatLevel: $enumDecodeNullable(
        _$PushPreferenceInputChatLevelEnumMap,
        json['chat_level'],
        unknownValue: PushPreferenceInputChatLevel.unknown,
      ),
      chatPreferences: json['chat_preferences'] == null
          ? null
          : ChatPreferencesInput.fromJson(
              json['chat_preferences'] as Map<String, dynamic>,
            ),
      disabledUntil: _$JsonConverterFromJson<Object, DateTime>(
        json['disabled_until'],
        const EpochDateTimeConverter().fromJson,
      ),
      feedsLevel: $enumDecodeNullable(
        _$PushPreferenceInputFeedsLevelEnumMap,
        json['feeds_level'],
        unknownValue: PushPreferenceInputFeedsLevel.unknown,
      ),
      feedsPreferences: json['feeds_preferences'] == null
          ? null
          : FeedsPreferences.fromJson(
              json['feeds_preferences'] as Map<String, dynamic>,
            ),
      removeDisable: json['remove_disable'] as bool?,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$PushPreferenceInputToJson(
  PushPreferenceInput instance,
) => <String, dynamic>{
  'call_level': _$PushPreferenceInputCallLevelEnumMap[instance.callLevel],
  'channel_cid': instance.channelCid,
  'chat_level': _$PushPreferenceInputChatLevelEnumMap[instance.chatLevel],
  'chat_preferences': instance.chatPreferences,
  'disabled_until': _$JsonConverterToJson<Object, DateTime>(
    instance.disabledUntil,
    const EpochDateTimeConverter().toJson,
  ),
  'feeds_level': _$PushPreferenceInputFeedsLevelEnumMap[instance.feedsLevel],
  'feeds_preferences': instance.feedsPreferences,
  'remove_disable': instance.removeDisable,
  'user_id': instance.userId,
};

const _$PushPreferenceInputCallLevelEnumMap = {
  PushPreferenceInputCallLevel.all: 'all',
  PushPreferenceInputCallLevel.default_: 'default',
  PushPreferenceInputCallLevel.none: 'none',
  PushPreferenceInputCallLevel.unknown: '_unknown',
};

const _$PushPreferenceInputChatLevelEnumMap = {
  PushPreferenceInputChatLevel.all: 'all',
  PushPreferenceInputChatLevel.allMentions: 'all_mentions',
  PushPreferenceInputChatLevel.default_: 'default',
  PushPreferenceInputChatLevel.directMentions: 'direct_mentions',
  PushPreferenceInputChatLevel.mentions: 'mentions',
  PushPreferenceInputChatLevel.none: 'none',
  PushPreferenceInputChatLevel.unknown: '_unknown',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$PushPreferenceInputFeedsLevelEnumMap = {
  PushPreferenceInputFeedsLevel.all: 'all',
  PushPreferenceInputFeedsLevel.default_: 'default',
  PushPreferenceInputFeedsLevel.none: 'none',
  PushPreferenceInputFeedsLevel.unknown: '_unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
