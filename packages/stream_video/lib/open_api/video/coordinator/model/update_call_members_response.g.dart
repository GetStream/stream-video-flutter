// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCallMembersResponse _$UpdateCallMembersResponseFromJson(
  Map<String, dynamic> json,
) => UpdateCallMembersResponse(
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateCallMembersResponseToJson(
  UpdateCallMembersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'members': instance.members,
};
