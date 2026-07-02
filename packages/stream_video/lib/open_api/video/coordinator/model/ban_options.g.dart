// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanOptions _$BanOptionsFromJson(Map<String, dynamic> json) => BanOptions(
  deleteMessages: $enumDecodeNullable(
    _$BanOptionsDeleteMessagesEnumMap,
    json['delete_messages'],
    unknownValue: BanOptionsDeleteMessages.unknown,
  ),
  duration: (json['duration'] as num?)?.toInt(),
  ipBan: json['ip_ban'] as bool?,
  reason: json['reason'] as String?,
  shadowBan: json['shadow_ban'] as bool?,
);

Map<String, dynamic> _$BanOptionsToJson(
  BanOptions instance,
) => <String, dynamic>{
  'delete_messages': _$BanOptionsDeleteMessagesEnumMap[instance.deleteMessages],
  'duration': instance.duration,
  'ip_ban': instance.ipBan,
  'reason': instance.reason,
  'shadow_ban': instance.shadowBan,
};

const _$BanOptionsDeleteMessagesEnumMap = {
  BanOptionsDeleteMessages.hard: 'hard',
  BanOptionsDeleteMessages.pruning: 'pruning',
  BanOptionsDeleteMessages.soft: 'soft',
  BanOptionsDeleteMessages.unknown: '_unknown',
};
