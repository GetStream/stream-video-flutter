// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_video_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendVideoReactionResponse _$SendVideoReactionResponseFromJson(
  Map<String, dynamic> json,
) => SendVideoReactionResponse(
  duration: json['duration'] as String,
  reaction: VideoReactionResponse.fromJson(
    json['reaction'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SendVideoReactionResponseToJson(
  SendVideoReactionResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'reaction': instance.reaction,
};
