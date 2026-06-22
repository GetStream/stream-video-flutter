// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelResponse _$ChannelResponseFromJson(
  Map<String, dynamic> json,
) => ChannelResponse(
  autoTranslationEnabled: json['auto_translation_enabled'] as bool?,
  autoTranslationLanguage: json['auto_translation_language'] as String?,
  blocked: json['blocked'] as bool?,
  cid: json['cid'] as String,
  config: json['config'] == null
      ? null
      : ChannelConfigWithInfo.fromJson(json['config'] as Map<String, dynamic>),
  cooldown: (json['cooldown'] as num?)?.toInt(),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
  custom: json['custom'] as Map<String, dynamic>,
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  disabled: json['disabled'] as bool,
  filterTags: (json['filter_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  frozen: json['frozen'] as bool,
  hidden: json['hidden'] as bool?,
  hideMessagesBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['hide_messages_before'],
    const EpochDateTimeConverter().fromJson,
  ),
  id: json['id'] as String,
  lastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_message_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  memberCount: (json['member_count'] as num?)?.toInt(),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  messageCount: (json['message_count'] as num?)?.toInt(),
  muteExpiresAt: _$JsonConverterFromJson<Object, DateTime>(
    json['mute_expires_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  muted: json['muted'] as bool?,
  ownCapabilities: (json['own_capabilities'] as List<dynamic>?)
      ?.map(
        (e) => $enumDecode(
          _$ChannelOwnCapabilityEnumMap,
          e,
          unknownValue: ChannelOwnCapability.unknown,
        ),
      )
      .toList(),
  team: json['team'] as String?,
  truncatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['truncated_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  truncatedBy: json['truncated_by'] == null
      ? null
      : UserResponse.fromJson(json['truncated_by'] as Map<String, dynamic>),
  type: json['type'] as String,
  updatedAt: const EpochDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ChannelResponseToJson(ChannelResponse instance) =>
    <String, dynamic>{
      'auto_translation_enabled': instance.autoTranslationEnabled,
      'auto_translation_language': instance.autoTranslationLanguage,
      'blocked': instance.blocked,
      'cid': instance.cid,
      'config': instance.config,
      'cooldown': instance.cooldown,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy,
      'custom': instance.custom,
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'disabled': instance.disabled,
      'filter_tags': instance.filterTags,
      'frozen': instance.frozen,
      'hidden': instance.hidden,
      'hide_messages_before': _$JsonConverterToJson<Object, DateTime>(
        instance.hideMessagesBefore,
        const EpochDateTimeConverter().toJson,
      ),
      'id': instance.id,
      'last_message_at': _$JsonConverterToJson<Object, DateTime>(
        instance.lastMessageAt,
        const EpochDateTimeConverter().toJson,
      ),
      'member_count': instance.memberCount,
      'members': instance.members,
      'message_count': instance.messageCount,
      'mute_expires_at': _$JsonConverterToJson<Object, DateTime>(
        instance.muteExpiresAt,
        const EpochDateTimeConverter().toJson,
      ),
      'muted': instance.muted,
      'own_capabilities': instance.ownCapabilities
          ?.map((e) => _$ChannelOwnCapabilityEnumMap[e]!)
          .toList(),
      'team': instance.team,
      'truncated_at': _$JsonConverterToJson<Object, DateTime>(
        instance.truncatedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'truncated_by': instance.truncatedBy,
      'type': instance.type,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ChannelOwnCapabilityEnumMap = {
  ChannelOwnCapability.banChannelMembers: 'ban-channel-members',
  ChannelOwnCapability.castPollVote: 'cast-poll-vote',
  ChannelOwnCapability.connectEvents: 'connect-events',
  ChannelOwnCapability.createAttachment: 'create-attachment',
  ChannelOwnCapability.deleteAnyMessage: 'delete-any-message',
  ChannelOwnCapability.deleteChannel: 'delete-channel',
  ChannelOwnCapability.deleteOwnMessage: 'delete-own-message',
  ChannelOwnCapability.deliveryEvents: 'delivery-events',
  ChannelOwnCapability.flagMessage: 'flag-message',
  ChannelOwnCapability.freezeChannel: 'freeze-channel',
  ChannelOwnCapability.joinChannel: 'join-channel',
  ChannelOwnCapability.leaveChannel: 'leave-channel',
  ChannelOwnCapability.muteChannel: 'mute-channel',
  ChannelOwnCapability.notifyChannel: 'notify-channel',
  ChannelOwnCapability.notifyGroup: 'notify-group',
  ChannelOwnCapability.notifyHere: 'notify-here',
  ChannelOwnCapability.notifyRole: 'notify-role',
  ChannelOwnCapability.pinMessage: 'pin-message',
  ChannelOwnCapability.queryPollVotes: 'query-poll-votes',
  ChannelOwnCapability.quoteMessage: 'quote-message',
  ChannelOwnCapability.readEvents: 'read-events',
  ChannelOwnCapability.searchMessages: 'search-messages',
  ChannelOwnCapability.sendCustomEvents: 'send-custom-events',
  ChannelOwnCapability.sendLinks: 'send-links',
  ChannelOwnCapability.sendMessage: 'send-message',
  ChannelOwnCapability.sendPoll: 'send-poll',
  ChannelOwnCapability.sendReaction: 'send-reaction',
  ChannelOwnCapability.sendReply: 'send-reply',
  ChannelOwnCapability.sendRestrictedVisibilityMessage:
      'send-restricted-visibility-message',
  ChannelOwnCapability.sendTypingEvents: 'send-typing-events',
  ChannelOwnCapability.setChannelCooldown: 'set-channel-cooldown',
  ChannelOwnCapability.shareLocation: 'share-location',
  ChannelOwnCapability.skipSlowMode: 'skip-slow-mode',
  ChannelOwnCapability.slowMode: 'slow-mode',
  ChannelOwnCapability.typingEvents: 'typing-events',
  ChannelOwnCapability.updateAnyMessage: 'update-any-message',
  ChannelOwnCapability.updateChannel: 'update-channel',
  ChannelOwnCapability.updateChannelMembers: 'update-channel-members',
  ChannelOwnCapability.updateOwnMessage: 'update-own-message',
  ChannelOwnCapability.updateThread: 'update-thread',
  ChannelOwnCapability.uploadFile: 'upload-file',
  ChannelOwnCapability.unknown: '_unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
