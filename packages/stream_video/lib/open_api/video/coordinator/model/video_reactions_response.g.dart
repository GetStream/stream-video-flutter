// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_reactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoReactionsResponse _$VideoReactionsResponseFromJson(
  Map<String, dynamic> json,
) => VideoReactionsResponse(
  countOverTime: json['count_over_time'] == null
      ? null
      : VideoReactionOverTimeResponse.fromJson(
          json['count_over_time'] as Map<String, dynamic>,
        ),
  reaction: json['reaction'] as String,
);

Map<String, dynamic> _$VideoReactionsResponseToJson(
  VideoReactionsResponse instance,
) => <String, dynamic>{
  'count_over_time': instance.countOverTime,
  'reaction': instance.reaction,
};
