// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_subscriber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapSubscriber _$CallStatsMapSubscriberFromJson(
  Map<String, dynamic> json,
) => CallStatsMapSubscriber(
  isLive: json['is_live'] as bool,
  location: json['location'] == null
      ? null
      : CallStatsLocation.fromJson(json['location'] as Map<String, dynamic>),
  name: json['name'] as String?,
  userId: json['user_id'] as String,
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$CallStatsMapSubscriberToJson(
  CallStatsMapSubscriber instance,
) => <String, dynamic>{
  'is_live': instance.isLive,
  'location': instance.location?.toJson(),
  'name': instance.name,
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};
