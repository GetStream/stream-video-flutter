// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_session_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallSessionStatsResponse _$QueryCallSessionStatsResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallSessionStatsResponse(
  callStats:
      (json['call_stats'] as List<dynamic>?)
          ?.map(
            (e) => CallStatsSessionResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$QueryCallSessionStatsResponseToJson(
  QueryCallSessionStatsResponse instance,
) => <String, dynamic>{
  'call_stats': instance.callStats,
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
};
