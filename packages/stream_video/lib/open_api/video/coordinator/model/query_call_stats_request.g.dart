// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_stats_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallStatsRequest _$QueryCallStatsRequestFromJson(
  Map<String, dynamic> json,
) => QueryCallStatsRequest(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  limit: (json['limit'] as num?)?.toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  sort: (json['sort'] as List<dynamic>?)
      ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryCallStatsRequestToJson(
  QueryCallStatsRequest instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'limit': instance.limit,
  'next': instance.next,
  'prev': instance.prev,
  'sort': instance.sort,
};
