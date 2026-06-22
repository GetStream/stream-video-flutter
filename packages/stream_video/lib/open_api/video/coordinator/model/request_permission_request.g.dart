// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_permission_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPermissionRequest _$RequestPermissionRequestFromJson(
  Map<String, dynamic> json,
) => RequestPermissionRequest(
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map(
            (e) => $enumDecode(
              _$RequestPermissionRequestPermissionsEnumMap,
              e,
              unknownValue: RequestPermissionRequestPermissions.unknown,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$RequestPermissionRequestToJson(
  RequestPermissionRequest instance,
) => <String, dynamic>{
  'permissions': instance.permissions
      .map((e) => _$RequestPermissionRequestPermissionsEnumMap[e]!)
      .toList(),
};

const _$RequestPermissionRequestPermissionsEnumMap = {
  RequestPermissionRequestPermissions.screenshare: 'screenshare',
  RequestPermissionRequestPermissions.sendAudio: 'send-audio',
  RequestPermissionRequestPermissions.sendVideo: 'send-video',
  RequestPermissionRequestPermissions.unknown: '_unknown',
};
