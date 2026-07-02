// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsPreferences _$FeedsPreferencesFromJson(Map<String, dynamic> json) =>
    FeedsPreferences(
      comment: $enumDecodeNullable(
        _$FeedsPreferencesCommentEnumMap,
        json['comment'],
        unknownValue: FeedsPreferencesComment.unknown,
      ),
      commentMention: $enumDecodeNullable(
        _$FeedsPreferencesCommentMentionEnumMap,
        json['comment_mention'],
        unknownValue: FeedsPreferencesCommentMention.unknown,
      ),
      commentReaction: $enumDecodeNullable(
        _$FeedsPreferencesCommentReactionEnumMap,
        json['comment_reaction'],
        unknownValue: FeedsPreferencesCommentReaction.unknown,
      ),
      commentReply: $enumDecodeNullable(
        _$FeedsPreferencesCommentReplyEnumMap,
        json['comment_reply'],
        unknownValue: FeedsPreferencesCommentReply.unknown,
      ),
      customActivityTypes:
          (json['custom_activity_types'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
      follow: $enumDecodeNullable(
        _$FeedsPreferencesFollowEnumMap,
        json['follow'],
        unknownValue: FeedsPreferencesFollow.unknown,
      ),
      mention: $enumDecodeNullable(
        _$FeedsPreferencesMentionEnumMap,
        json['mention'],
        unknownValue: FeedsPreferencesMention.unknown,
      ),
      reaction: $enumDecodeNullable(
        _$FeedsPreferencesReactionEnumMap,
        json['reaction'],
        unknownValue: FeedsPreferencesReaction.unknown,
      ),
    );

Map<String, dynamic> _$FeedsPreferencesToJson(
  FeedsPreferences instance,
) => <String, dynamic>{
  'comment': _$FeedsPreferencesCommentEnumMap[instance.comment],
  'comment_mention':
      _$FeedsPreferencesCommentMentionEnumMap[instance.commentMention],
  'comment_reaction':
      _$FeedsPreferencesCommentReactionEnumMap[instance.commentReaction],
  'comment_reply': _$FeedsPreferencesCommentReplyEnumMap[instance.commentReply],
  'custom_activity_types': instance.customActivityTypes,
  'follow': _$FeedsPreferencesFollowEnumMap[instance.follow],
  'mention': _$FeedsPreferencesMentionEnumMap[instance.mention],
  'reaction': _$FeedsPreferencesReactionEnumMap[instance.reaction],
};

const _$FeedsPreferencesCommentEnumMap = {
  FeedsPreferencesComment.all: 'all',
  FeedsPreferencesComment.none: 'none',
  FeedsPreferencesComment.unknown: '_unknown',
};

const _$FeedsPreferencesCommentMentionEnumMap = {
  FeedsPreferencesCommentMention.all: 'all',
  FeedsPreferencesCommentMention.none: 'none',
  FeedsPreferencesCommentMention.unknown: '_unknown',
};

const _$FeedsPreferencesCommentReactionEnumMap = {
  FeedsPreferencesCommentReaction.all: 'all',
  FeedsPreferencesCommentReaction.none: 'none',
  FeedsPreferencesCommentReaction.unknown: '_unknown',
};

const _$FeedsPreferencesCommentReplyEnumMap = {
  FeedsPreferencesCommentReply.all: 'all',
  FeedsPreferencesCommentReply.none: 'none',
  FeedsPreferencesCommentReply.unknown: '_unknown',
};

const _$FeedsPreferencesFollowEnumMap = {
  FeedsPreferencesFollow.all: 'all',
  FeedsPreferencesFollow.none: 'none',
  FeedsPreferencesFollow.unknown: '_unknown',
};

const _$FeedsPreferencesMentionEnumMap = {
  FeedsPreferencesMention.all: 'all',
  FeedsPreferencesMention.none: 'none',
  FeedsPreferencesMention.unknown: '_unknown',
};

const _$FeedsPreferencesReactionEnumMap = {
  FeedsPreferencesReaction.all: 'all',
  FeedsPreferencesReaction.none: 'none',
  FeedsPreferencesReaction.unknown: '_unknown',
};
