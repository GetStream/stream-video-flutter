// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_reaction_over_time_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoReactionOverTimeResponse _$VideoReactionOverTimeResponseFromJson(
  Map<String, dynamic> json,
) => VideoReactionOverTimeResponse(
  byMinute: (json['by_minute'] as List<dynamic>?)
      ?.map((e) => CountByMinuteResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VideoReactionOverTimeResponseToJson(
  VideoReactionOverTimeResponse instance,
) => <String, dynamic>{
  'by_minute': instance.byMinute?.map((e) => e.toJson()).toList(),
};
