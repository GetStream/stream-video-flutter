// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_action_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanActionRequestPayload _$BanActionRequestPayloadFromJson(
  Map<String, dynamic> json,
) => BanActionRequestPayload(
  banFromFutureChannels: json['ban_from_future_channels'] as bool?,
  channelBanOnly: json['channel_ban_only'] as bool?,
  channelCid: json['channel_cid'] as String?,
  deleteMessages: $enumDecodeNullable(
    _$BanActionRequestPayloadDeleteMessagesEnumMap,
    json['delete_messages'],
    unknownValue: BanActionRequestPayloadDeleteMessages.unknown,
  ),
  ipBan: json['ip_ban'] as bool?,
  reason: json['reason'] as String?,
  shadow: json['shadow'] as bool?,
  targetUserId: json['target_user_id'] as String?,
  timeout: (json['timeout'] as num?)?.toInt(),
);

Map<String, dynamic> _$BanActionRequestPayloadToJson(
  BanActionRequestPayload instance,
) => <String, dynamic>{
  'ban_from_future_channels': instance.banFromFutureChannels,
  'channel_ban_only': instance.channelBanOnly,
  'channel_cid': instance.channelCid,
  'delete_messages':
      _$BanActionRequestPayloadDeleteMessagesEnumMap[instance.deleteMessages],
  'ip_ban': instance.ipBan,
  'reason': instance.reason,
  'shadow': instance.shadow,
  'target_user_id': instance.targetUserId,
  'timeout': instance.timeout,
};

const _$BanActionRequestPayloadDeleteMessagesEnumMap = {
  BanActionRequestPayloadDeleteMessages.hard: 'hard',
  BanActionRequestPayloadDeleteMessages.pruning: 'pruning',
  BanActionRequestPayloadDeleteMessages.soft: 'soft',
  BanActionRequestPayloadDeleteMessages.unknown: '_unknown',
};
