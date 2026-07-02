// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferencesInput _$ChatPreferencesInputFromJson(
  Map<String, dynamic> json,
) => ChatPreferencesInput(
  channelMentions: $enumDecodeNullable(
    _$ChatPreferencesInputChannelMentionsEnumMap,
    json['channel_mentions'],
    unknownValue: ChatPreferencesInputChannelMentions.unknown,
  ),
  defaultPreference: $enumDecodeNullable(
    _$ChatPreferencesInputDefaultPreferenceEnumMap,
    json['default_preference'],
    unknownValue: ChatPreferencesInputDefaultPreference.unknown,
  ),
  directMentions: $enumDecodeNullable(
    _$ChatPreferencesInputDirectMentionsEnumMap,
    json['direct_mentions'],
    unknownValue: ChatPreferencesInputDirectMentions.unknown,
  ),
  groupMentions: $enumDecodeNullable(
    _$ChatPreferencesInputGroupMentionsEnumMap,
    json['group_mentions'],
    unknownValue: ChatPreferencesInputGroupMentions.unknown,
  ),
  hereMentions: $enumDecodeNullable(
    _$ChatPreferencesInputHereMentionsEnumMap,
    json['here_mentions'],
    unknownValue: ChatPreferencesInputHereMentions.unknown,
  ),
  roleMentions: $enumDecodeNullable(
    _$ChatPreferencesInputRoleMentionsEnumMap,
    json['role_mentions'],
    unknownValue: ChatPreferencesInputRoleMentions.unknown,
  ),
  threadReplies: $enumDecodeNullable(
    _$ChatPreferencesInputThreadRepliesEnumMap,
    json['thread_replies'],
    unknownValue: ChatPreferencesInputThreadReplies.unknown,
  ),
);

Map<String, dynamic> _$ChatPreferencesInputToJson(
  ChatPreferencesInput instance,
) => <String, dynamic>{
  'channel_mentions':
      _$ChatPreferencesInputChannelMentionsEnumMap[instance.channelMentions],
  'default_preference':
      _$ChatPreferencesInputDefaultPreferenceEnumMap[instance
          .defaultPreference],
  'direct_mentions':
      _$ChatPreferencesInputDirectMentionsEnumMap[instance.directMentions],
  'group_mentions':
      _$ChatPreferencesInputGroupMentionsEnumMap[instance.groupMentions],
  'here_mentions':
      _$ChatPreferencesInputHereMentionsEnumMap[instance.hereMentions],
  'role_mentions':
      _$ChatPreferencesInputRoleMentionsEnumMap[instance.roleMentions],
  'thread_replies':
      _$ChatPreferencesInputThreadRepliesEnumMap[instance.threadReplies],
};

const _$ChatPreferencesInputChannelMentionsEnumMap = {
  ChatPreferencesInputChannelMentions.all: 'all',
  ChatPreferencesInputChannelMentions.none: 'none',
  ChatPreferencesInputChannelMentions.unknown: '_unknown',
};

const _$ChatPreferencesInputDefaultPreferenceEnumMap = {
  ChatPreferencesInputDefaultPreference.all: 'all',
  ChatPreferencesInputDefaultPreference.none: 'none',
  ChatPreferencesInputDefaultPreference.unknown: '_unknown',
};

const _$ChatPreferencesInputDirectMentionsEnumMap = {
  ChatPreferencesInputDirectMentions.all: 'all',
  ChatPreferencesInputDirectMentions.none: 'none',
  ChatPreferencesInputDirectMentions.unknown: '_unknown',
};

const _$ChatPreferencesInputGroupMentionsEnumMap = {
  ChatPreferencesInputGroupMentions.all: 'all',
  ChatPreferencesInputGroupMentions.none: 'none',
  ChatPreferencesInputGroupMentions.unknown: '_unknown',
};

const _$ChatPreferencesInputHereMentionsEnumMap = {
  ChatPreferencesInputHereMentions.all: 'all',
  ChatPreferencesInputHereMentions.none: 'none',
  ChatPreferencesInputHereMentions.unknown: '_unknown',
};

const _$ChatPreferencesInputRoleMentionsEnumMap = {
  ChatPreferencesInputRoleMentions.all: 'all',
  ChatPreferencesInputRoleMentions.none: 'none',
  ChatPreferencesInputRoleMentions.unknown: '_unknown',
};

const _$ChatPreferencesInputThreadRepliesEnumMap = {
  ChatPreferencesInputThreadReplies.all: 'all',
  ChatPreferencesInputThreadReplies.none: 'none',
  ChatPreferencesInputThreadReplies.unknown: '_unknown',
};
