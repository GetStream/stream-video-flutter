// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_reaction_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsReactionGroupResponse _$FeedsReactionGroupResponseFromJson(
  Map<String, dynamic> json,
) => FeedsReactionGroupResponse(
  count: (json['count'] as num).toInt(),
  firstReactionAt: const EpochDateTimeConverter().fromJson(
    json['first_reaction_at'] as Object,
  ),
  lastReactionAt: const EpochDateTimeConverter().fromJson(
    json['last_reaction_at'] as Object,
  ),
);

Map<String, dynamic> _$FeedsReactionGroupResponseToJson(
  FeedsReactionGroupResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'first_reaction_at': const EpochDateTimeConverter().toJson(
    instance.firstReactionAt,
  ),
  'last_reaction_at': const EpochDateTimeConverter().toJson(
    instance.lastReactionAt,
  ),
};
