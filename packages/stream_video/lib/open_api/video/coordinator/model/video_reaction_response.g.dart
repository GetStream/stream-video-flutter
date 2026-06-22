// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoReactionResponse _$VideoReactionResponseFromJson(
  Map<String, dynamic> json,
) => VideoReactionResponse(
  custom: json['custom'] as Map<String, dynamic>?,
  emojiCode: json['emoji_code'] as String?,
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VideoReactionResponseToJson(
  VideoReactionResponse instance,
) => <String, dynamic>{
  'custom': instance.custom,
  'emoji_code': instance.emojiCode,
  'type': instance.type,
  'user': instance.user,
};
