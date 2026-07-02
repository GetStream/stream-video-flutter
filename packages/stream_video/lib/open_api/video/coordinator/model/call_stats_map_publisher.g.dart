// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_publisher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapPublisher _$CallStatsMapPublisherFromJson(
  Map<String, dynamic> json,
) => CallStatsMapPublisher(
  isLive: json['is_live'] as bool,
  location: json['location'] == null
      ? null
      : CallStatsLocation.fromJson(json['location'] as Map<String, dynamic>),
  name: json['name'] as String?,
  publishedTracks: PublishedTrackFlags.fromJson(
    json['published_tracks'] as Map<String, dynamic>,
  ),
  publisherType: json['publisher_type'] as String?,
  userId: json['user_id'] as String,
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$CallStatsMapPublisherToJson(
  CallStatsMapPublisher instance,
) => <String, dynamic>{
  'is_live': instance.isLive,
  'location': instance.location?.toJson(),
  'name': instance.name,
  'published_tracks': instance.publishedTracks.toJson(),
  'publisher_type': instance.publisherType,
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};
