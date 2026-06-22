// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionRequestEvent _$PermissionRequestEventFromJson(
  Map<String, dynamic> json,
) => PermissionRequestEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PermissionRequestEventToJson(
  PermissionRequestEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'permissions': instance.permissions,
  'type': instance.type,
  'user': instance.user,
};
