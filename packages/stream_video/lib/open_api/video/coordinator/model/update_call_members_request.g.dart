// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_members_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCallMembersRequest _$UpdateCallMembersRequestFromJson(
  Map<String, dynamic> json,
) => UpdateCallMembersRequest(
  removeMembers: (json['remove_members'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  updateMembers: (json['update_members'] as List<dynamic>?)
      ?.map((e) => MemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateCallMembersRequestToJson(
  UpdateCallMembersRequest instance,
) => <String, dynamic>{
  'remove_members': instance.removeMembers,
  'update_members': instance.updateMembers,
};
