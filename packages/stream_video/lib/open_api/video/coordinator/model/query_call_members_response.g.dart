// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallMembersResponse _$QueryCallMembersResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallMembersResponse(
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$QueryCallMembersResponseToJson(
  QueryCallMembersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'members': instance.members,
  'next': instance.next,
  'prev': instance.prev,
};
