// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_permissions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserPermissionsRequest _$UpdateUserPermissionsRequestFromJson(
  Map<String, dynamic> json,
) => UpdateUserPermissionsRequest(
  grantPermissions: (json['grant_permissions'] as List<dynamic>?)
      ?.map(
        (e) =>
            UpdateUserPermissionsRequestGrantPermissions.fromJson(e as String),
      )
      .toList(),
  revokePermissions: (json['revoke_permissions'] as List<dynamic>?)
      ?.map(
        (e) =>
            UpdateUserPermissionsRequestRevokePermissions.fromJson(e as String),
      )
      .toList(),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$UpdateUserPermissionsRequestToJson(
  UpdateUserPermissionsRequest instance,
) => <String, dynamic>{
  'grant_permissions': instance.grantPermissions
      ?.map((e) => e.toJson())
      .toList(),
  'revoke_permissions': instance.revokePermissions
      ?.map((e) => e.toJson())
      .toList(),
  'user_id': instance.userId,
};
