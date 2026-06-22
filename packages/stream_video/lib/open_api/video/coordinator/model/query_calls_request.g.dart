// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_calls_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallsRequest _$QueryCallsRequestFromJson(Map<String, dynamic> json) =>
    QueryCallsRequest(
      filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
      limit: (json['limit'] as num?)?.toInt(),
      next: json['next'] as String?,
      prev: json['prev'] as String?,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      watch: json['watch'] as bool?,
    );

Map<String, dynamic> _$QueryCallsRequestToJson(QueryCallsRequest instance) =>
    <String, dynamic>{
      'filter_conditions': instance.filterConditions,
      'limit': instance.limit,
      'next': instance.next,
      'prev': instance.prev,
      'sort': instance.sort,
      'watch': instance.watch,
    };
