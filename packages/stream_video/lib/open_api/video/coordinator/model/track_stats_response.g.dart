// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackStatsResponse _$TrackStatsResponseFromJson(Map<String, dynamic> json) =>
    TrackStatsResponse(
      durationSeconds: (json['duration_seconds'] as num).toInt(),
      trackType: json['track_type'] as String,
    );

Map<String, dynamic> _$TrackStatsResponseToJson(TrackStatsResponse instance) =>
    <String, dynamic>{
      'duration_seconds': instance.durationSeconds,
      'track_type': instance.trackType,
    };
