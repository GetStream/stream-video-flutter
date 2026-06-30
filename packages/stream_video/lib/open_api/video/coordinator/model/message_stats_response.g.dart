// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageStatsResponse _$MessageStatsResponseFromJson(
  Map<String, dynamic> json,
) => MessageStatsResponse(
  countOverTime: (json['count_over_time'] as List<dynamic>?)
      ?.map((e) => CountByMinuteResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MessageStatsResponseToJson(
  MessageStatsResponse instance,
) => <String, dynamic>{
  'count_over_time': instance.countOverTime?.map((e) => e.toJson()).toList(),
};
