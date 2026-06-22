// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_updated_permission_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallMemberUpdatedPermissionEvent _$CallMemberUpdatedPermissionEventFromJson(
  Map<String, dynamic> json,
) => CallMemberUpdatedPermissionEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  capabilitiesByRole: _capabilitiesByRoleFromJson(
    json['capabilities_by_role'] as Map<String, dynamic>,
  ),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberUpdatedPermissionEventToJson(
  CallMemberUpdatedPermissionEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'capabilities_by_role': instance.capabilitiesByRole,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members,
  'type': instance.type,
};
