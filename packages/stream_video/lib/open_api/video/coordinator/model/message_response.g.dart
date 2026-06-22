// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponse _$MessageResponseFromJson(
  Map<String, dynamic> json,
) => MessageResponse(
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  cid: json['cid'] as String,
  command: json['command'] as String?,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>? ?? {},
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  deletedForMe: json['deleted_for_me'] as bool?,
  deletedReplyCount: (json['deleted_reply_count'] as num).toInt(),
  draft: json['draft'] == null
      ? null
      : DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
  html: json['html'] as String,
  i18n: (json['i18n'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  id: json['id'] as String,
  imageLabels: (json['image_labels'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  latestReactions:
      (json['latest_reactions'] as List<dynamic>?)
          ?.map((e) => ReactionResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  member: json['member'] == null
      ? null
      : ChannelMemberResponse.fromJson(json['member'] as Map<String, dynamic>),
  mentionedChannel: json['mentioned_channel'] as bool,
  mentionedGroupIds: (json['mentioned_group_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  mentionedGroups: (json['mentioned_groups'] as List<dynamic>?)
      ?.map((e) => UserGroupResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  mentionedHere: json['mentioned_here'] as bool,
  mentionedRoles: (json['mentioned_roles'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  mentionedUsers:
      (json['mentioned_users'] as List<dynamic>?)
          ?.map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  messageTextUpdatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['message_text_updated_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  mml: json['mml'] as String?,
  moderation: json['moderation'] == null
      ? null
      : ModerationV2Response.fromJson(
          json['moderation'] as Map<String, dynamic>,
        ),
  ownReactions:
      (json['own_reactions'] as List<dynamic>?)
          ?.map((e) => ReactionResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  parentId: json['parent_id'] as String?,
  pinExpires: _$JsonConverterFromJson<Object, DateTime>(
    json['pin_expires'],
    const EpochDateTimeConverter().fromJson,
  ),
  pinned: json['pinned'] as bool,
  pinnedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['pinned_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  pinnedBy: json['pinned_by'] == null
      ? null
      : UserResponse.fromJson(json['pinned_by'] as Map<String, dynamic>),
  poll: json['poll'] == null
      ? null
      : PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  pollId: json['poll_id'] as String?,
  quotedMessage: json['quoted_message'] == null
      ? null
      : MessageResponse.fromJson(
          json['quoted_message'] as Map<String, dynamic>,
        ),
  quotedMessageId: json['quoted_message_id'] as String?,
  reactionCounts:
      (json['reaction_counts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      {},
  reactionGroups: (json['reaction_groups'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, ReactionGroupResponse.fromJson(e as Map<String, dynamic>)),
  ),
  reactionScores:
      (json['reaction_scores'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      {},
  reminder: json['reminder'] == null
      ? null
      : ReminderResponseData.fromJson(json['reminder'] as Map<String, dynamic>),
  replyCount: (json['reply_count'] as num).toInt(),
  restrictedVisibility:
      (json['restricted_visibility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  shadowed: json['shadowed'] as bool,
  sharedLocation: json['shared_location'] == null
      ? null
      : SharedLocationResponseData.fromJson(
          json['shared_location'] as Map<String, dynamic>,
        ),
  showInChannel: json['show_in_channel'] as bool?,
  silent: json['silent'] as bool,
  text: json['text'] as String,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
  updatedAt: const EpochDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'cid': instance.cid,
      'command': instance.command,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'deleted_for_me': instance.deletedForMe,
      'deleted_reply_count': instance.deletedReplyCount,
      'draft': instance.draft,
      'html': instance.html,
      'i18n': instance.i18n,
      'id': instance.id,
      'image_labels': instance.imageLabels,
      'latest_reactions': instance.latestReactions,
      'member': instance.member,
      'mentioned_channel': instance.mentionedChannel,
      'mentioned_group_ids': instance.mentionedGroupIds,
      'mentioned_groups': instance.mentionedGroups,
      'mentioned_here': instance.mentionedHere,
      'mentioned_roles': instance.mentionedRoles,
      'mentioned_users': instance.mentionedUsers,
      'message_text_updated_at': _$JsonConverterToJson<Object, DateTime>(
        instance.messageTextUpdatedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'mml': instance.mml,
      'moderation': instance.moderation,
      'own_reactions': instance.ownReactions,
      'parent_id': instance.parentId,
      'pin_expires': _$JsonConverterToJson<Object, DateTime>(
        instance.pinExpires,
        const EpochDateTimeConverter().toJson,
      ),
      'pinned': instance.pinned,
      'pinned_at': _$JsonConverterToJson<Object, DateTime>(
        instance.pinnedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'pinned_by': instance.pinnedBy,
      'poll': instance.poll,
      'poll_id': instance.pollId,
      'quoted_message': instance.quotedMessage,
      'quoted_message_id': instance.quotedMessageId,
      'reaction_counts': instance.reactionCounts,
      'reaction_groups': instance.reactionGroups,
      'reaction_scores': instance.reactionScores,
      'reminder': instance.reminder,
      'reply_count': instance.replyCount,
      'restricted_visibility': instance.restrictedVisibility,
      'shadowed': instance.shadowed,
      'shared_location': instance.sharedLocation,
      'show_in_channel': instance.showInChannel,
      'silent': instance.silent,
      'text': instance.text,
      'thread_participants': instance.threadParticipants,
      'type': instance.type,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
      'user': instance.user,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
