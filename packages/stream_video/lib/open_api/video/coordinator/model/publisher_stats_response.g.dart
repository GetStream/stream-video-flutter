// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublisherStatsResponse _$PublisherStatsResponseFromJson(
  Map<String, dynamic> json,
) => PublisherStatsResponse(
  byTrack: (json['by_track'] as List<dynamic>?)
      ?.map((e) => TrackStatsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  unique: (json['unique'] as num).toInt(),
);

Map<String, dynamic> _$PublisherStatsResponseToJson(
  PublisherStatsResponse instance,
) => <String, dynamic>{
  'by_track': instance.byTrack,
  'total': instance.total,
  'unique': instance.unique,
};
