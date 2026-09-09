// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_activity_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatActivityStatsResponse _$ChatActivityStatsResponseFromJson(
  Map<String, dynamic> json,
) => ChatActivityStatsResponse(
  messages: json['Messages'] == null
      ? null
      : MessageStatsResponse.fromJson(json['Messages'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatActivityStatsResponseToJson(
  ChatActivityStatsResponse instance,
) => <String, dynamic>{'Messages': instance.messages?.toJson()};
