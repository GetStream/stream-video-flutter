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
        (e) => $enumDecode(
          _$UpdateUserPermissionsRequestGrantPermissionsEnumMap,
          e,
          unknownValue: UpdateUserPermissionsRequestGrantPermissions.unknown,
        ),
      )
      .toList(),
  revokePermissions: (json['revoke_permissions'] as List<dynamic>?)
      ?.map(
        (e) => $enumDecode(
          _$UpdateUserPermissionsRequestRevokePermissionsEnumMap,
          e,
          unknownValue: UpdateUserPermissionsRequestRevokePermissions.unknown,
        ),
      )
      .toList(),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$UpdateUserPermissionsRequestToJson(
  UpdateUserPermissionsRequest instance,
) => <String, dynamic>{
  'grant_permissions': instance.grantPermissions
      ?.map((e) => _$UpdateUserPermissionsRequestGrantPermissionsEnumMap[e]!)
      .toList(),
  'revoke_permissions': instance.revokePermissions
      ?.map((e) => _$UpdateUserPermissionsRequestRevokePermissionsEnumMap[e]!)
      .toList(),
  'user_id': instance.userId,
};

const _$UpdateUserPermissionsRequestGrantPermissionsEnumMap = {
  UpdateUserPermissionsRequestGrantPermissions.screenshare: 'screenshare',
  UpdateUserPermissionsRequestGrantPermissions.sendAudio: 'send-audio',
  UpdateUserPermissionsRequestGrantPermissions.sendVideo: 'send-video',
  UpdateUserPermissionsRequestGrantPermissions.unknown: '_unknown',
};

const _$UpdateUserPermissionsRequestRevokePermissionsEnumMap = {
  UpdateUserPermissionsRequestRevokePermissions.screenshare: 'screenshare',
  UpdateUserPermissionsRequestRevokePermissions.sendAudio: 'send-audio',
  UpdateUserPermissionsRequestRevokePermissions.sendVideo: 'send-video',
  UpdateUserPermissionsRequestRevokePermissions.unknown: '_unknown',
};
