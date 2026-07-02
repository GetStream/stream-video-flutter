// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_members_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallMembersRequest _$QueryCallMembersRequestFromJson(
  Map<String, dynamic> json,
) => QueryCallMembersRequest(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  id: json['id'] as String,
  limit: (json['limit'] as num?)?.toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  sort: (json['sort'] as List<dynamic>?)
      ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$QueryCallMembersRequestToJson(
  QueryCallMembersRequest instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'id': instance.id,
  'limit': instance.limit,
  'next': instance.next,
  'prev': instance.prev,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'type': instance.type,
};
