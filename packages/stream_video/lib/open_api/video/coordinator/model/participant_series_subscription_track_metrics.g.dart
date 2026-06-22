// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_subscription_track_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesSubscriptionTrackMetrics
_$ParticipantSeriesSubscriptionTrackMetricsFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesSubscriptionTrackMetrics(
  publisherName: json['publisher_name'] as String?,
  publisherUserId: json['publisher_user_id'] as String,
  publisherUserSessionId: json['publisher_user_session_id'] as String?,
  tracks: (json['tracks'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map(
            (e) => ParticipantSeriesTrackMetrics.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$ParticipantSeriesSubscriptionTrackMetricsToJson(
  ParticipantSeriesSubscriptionTrackMetrics instance,
) => <String, dynamic>{
  'publisher_name': instance.publisherName,
  'publisher_user_id': instance.publisherUserId,
  'publisher_user_session_id': instance.publisherUserSessionId,
  'tracks': instance.tracks,
};
