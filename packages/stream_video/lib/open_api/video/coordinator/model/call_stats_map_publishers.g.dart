// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_publishers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapPublishers _$CallStatsMapPublishersFromJson(
  Map<String, dynamic> json,
) => CallStatsMapPublishers(
  publishers: (json['publishers'] as List<dynamic>)
      .map((e) => CallStatsMapPublisher.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CallStatsMapPublishersToJson(
  CallStatsMapPublishers instance,
) => <String, dynamic>{'publishers': instance.publishers};
