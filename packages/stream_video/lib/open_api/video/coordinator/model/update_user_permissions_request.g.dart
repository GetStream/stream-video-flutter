// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_permissions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserPermissionsRequest _$UpdateUserPermissionsRequestFromJson(
  Map<String, dynamic> json,
) => UpdateUserPermissionsRequest(
  grantPermissions: (json['grant_permissions'] as List<dynamic>?)
      ?.map((e) => e as UpdateUserPermissionsRequestGrantPermissions)
      .toList(),
  revokePermissions: (json['revoke_permissions'] as List<dynamic>?)
      ?.map((e) => e as UpdateUserPermissionsRequestRevokePermissions)
      .toList(),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$UpdateUserPermissionsRequestToJson(
  UpdateUserPermissionsRequest instance,
) => <String, dynamic>{
  'grant_permissions': instance.grantPermissions,
  'revoke_permissions': instance.revokePermissions,
  'user_id': instance.userId,
};
