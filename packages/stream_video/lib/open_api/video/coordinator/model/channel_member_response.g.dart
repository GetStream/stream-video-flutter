// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMemberResponse _$ChannelMemberResponseFromJson(
  Map<String, dynamic> json,
) => ChannelMemberResponse(
  archivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['archived_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  banExpires: _$JsonConverterFromJson<Object, DateTime>(
    json['ban_expires'],
    const EpochDateTimeConverter().fromJson,
  ),
  banned: json['banned'] as bool,
  channelRole: json['channel_role'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>? ?? {},
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  deletedMessages: (json['deleted_messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  inviteAcceptedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['invite_accepted_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  inviteRejectedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['invite_rejected_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  invited: json['invited'] as bool?,
  isModerator: json['is_moderator'] as bool?,
  notificationsMuted: json['notifications_muted'] as bool,
  pinnedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['pinned_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  role: json['role'] as String?,
  shadowBanned: json['shadow_banned'] as bool,
  status: json['status'] as String?,
  updatedAt: const EpochDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$ChannelMemberResponseToJson(
  ChannelMemberResponse instance,
) => <String, dynamic>{
  'archived_at': _$JsonConverterToJson<Object, DateTime>(
    instance.archivedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'ban_expires': _$JsonConverterToJson<Object, DateTime>(
    instance.banExpires,
    const EpochDateTimeConverter().toJson,
  ),
  'banned': instance.banned,
  'channel_role': instance.channelRole,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'deleted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.deletedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'deleted_messages': instance.deletedMessages,
  'invite_accepted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.inviteAcceptedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'invite_rejected_at': _$JsonConverterToJson<Object, DateTime>(
    instance.inviteRejectedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'invited': instance.invited,
  'is_moderator': instance.isModerator,
  'notifications_muted': instance.notificationsMuted,
  'pinned_at': _$JsonConverterToJson<Object, DateTime>(
    instance.pinnedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'role': instance.role,
  'shadow_banned': instance.shadowBanned,
  'status': instance.status,
  'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user,
  'user_id': instance.userId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
