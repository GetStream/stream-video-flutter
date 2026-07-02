// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_video_reaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendVideoReactionRequest _$SendVideoReactionRequestFromJson(
  Map<String, dynamic> json,
) => SendVideoReactionRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  emojiCode: json['emoji_code'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$SendVideoReactionRequestToJson(
  SendVideoReactionRequest instance,
) => <String, dynamic>{
  'custom': instance.custom,
  'emoji_code': instance.emojiCode,
  'type': instance.type,
};
