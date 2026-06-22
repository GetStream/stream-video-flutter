// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_calls_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallsResponse _$QueryCallsResponseFromJson(Map<String, dynamic> json) =>
    QueryCallsResponse(
      calls: (json['calls'] as List<dynamic>)
          .map(
            (e) => CallStateResponseFields.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      duration: json['duration'] as String,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );

Map<String, dynamic> _$QueryCallsResponseToJson(QueryCallsResponse instance) =>
    <String, dynamic>{
      'calls': instance.calls,
      'duration': instance.duration,
      'next': instance.next,
      'prev': instance.prev,
    };
