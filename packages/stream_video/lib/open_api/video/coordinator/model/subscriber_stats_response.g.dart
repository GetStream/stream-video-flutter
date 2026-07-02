// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriber_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriberStatsResponse _$SubscriberStatsResponseFromJson(
  Map<String, dynamic> json,
) => SubscriberStatsResponse(
  total: (json['total'] as num).toInt(),
  totalSubscribedDurationSeconds:
      (json['total_subscribed_duration_seconds'] as num).toInt(),
  unique: (json['unique'] as num).toInt(),
);

Map<String, dynamic> _$SubscriberStatsResponseToJson(
  SubscriberStatsResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'total_subscribed_duration_seconds': instance.totalSubscribedDurationSeconds,
  'unique': instance.unique,
};
