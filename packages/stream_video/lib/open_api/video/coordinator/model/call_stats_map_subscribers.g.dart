// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_subscribers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapSubscribers _$CallStatsMapSubscribersFromJson(
  Map<String, dynamic> json,
) => CallStatsMapSubscribers(
  locations:
      (json['locations'] as List<dynamic>?)
          ?.map((e) => CallStatsMapLocation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  participants: (json['participants'] as List<dynamic>?)
      ?.map((e) => CallStatsMapSubscriber.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CallStatsMapSubscribersToJson(
  CallStatsMapSubscribers instance,
) => <String, dynamic>{
  'locations': instance.locations,
  'participants': instance.participants,
};
