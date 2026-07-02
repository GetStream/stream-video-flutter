// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_session_participant_stats_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCallSessionParticipantStatsDetailsResponse
_$GetCallSessionParticipantStatsDetailsResponseFromJson(
  Map<String, dynamic> json,
) => GetCallSessionParticipantStatsDetailsResponse(
  callId: json['call_id'] as String,
  callSessionId: json['call_session_id'] as String,
  callType: json['call_type'] as String,
  duration: json['duration'] as String,
  publisher: json['publisher'] == null
      ? null
      : ParticipantSeriesPublisherStats.fromJson(
          json['publisher'] as Map<String, dynamic>,
        ),
  subscriber: json['subscriber'] == null
      ? null
      : ParticipantSeriesSubscriberStats.fromJson(
          json['subscriber'] as Map<String, dynamic>,
        ),
  timeframe: json['timeframe'] == null
      ? null
      : ParticipantSeriesTimeframe.fromJson(
          json['timeframe'] as Map<String, dynamic>,
        ),
  user: json['user'] == null
      ? null
      : ParticipantSeriesUserStats.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
  userId: json['user_id'] as String,
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$GetCallSessionParticipantStatsDetailsResponseToJson(
  GetCallSessionParticipantStatsDetailsResponse instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'call_session_id': instance.callSessionId,
  'call_type': instance.callType,
  'duration': instance.duration,
  'publisher': instance.publisher?.toJson(),
  'subscriber': instance.subscriber?.toJson(),
  'timeframe': instance.timeframe?.toJson(),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};
