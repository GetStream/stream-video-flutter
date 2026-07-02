// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapLocation _$CallStatsMapLocationFromJson(
  Map<String, dynamic> json,
) => CallStatsMapLocation(
  count: (json['count'] as num).toInt(),
  liveCount: (json['live_count'] as num).toInt(),
  location: json['location'] == null
      ? null
      : CallStatsLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallStatsMapLocationToJson(
  CallStatsMapLocation instance,
) => <String, dynamic>{
  'count': instance.count,
  'live_count': instance.liveCount,
  'location': instance.location?.toJson(),
};
