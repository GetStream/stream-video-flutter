// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_participant_session_metrics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCallParticipantSessionMetricsResponse
_$GetCallParticipantSessionMetricsResponseFromJson(Map<String, dynamic> json) =>
    GetCallParticipantSessionMetricsResponse(
      client: json['client'] == null
          ? null
          : SessionClient.fromJson(json['client'] as Map<String, dynamic>),
      duration: json['duration'] as String,
      isPublisher: json['is_publisher'] as bool?,
      isSubscriber: json['is_subscriber'] as bool?,
      joinedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['joined_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      publishedTracks: (json['published_tracks'] as List<dynamic>?)
          ?.map(
            (e) => PublishedTrackMetrics.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      publisherType: json['publisher_type'] as String?,
      userId: json['user_id'] as String?,
      userSessionId: json['user_session_id'] as String?,
    );

Map<String, dynamic> _$GetCallParticipantSessionMetricsResponseToJson(
  GetCallParticipantSessionMetricsResponse instance,
) => <String, dynamic>{
  'client': instance.client,
  'duration': instance.duration,
  'is_publisher': instance.isPublisher,
  'is_subscriber': instance.isSubscriber,
  'joined_at': _$JsonConverterToJson<Object, DateTime>(
    instance.joinedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'published_tracks': instance.publishedTracks,
  'publisher_type': instance.publisherType,
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
