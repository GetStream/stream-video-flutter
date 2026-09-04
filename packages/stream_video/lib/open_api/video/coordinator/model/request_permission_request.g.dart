// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_permission_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPermissionRequest _$RequestPermissionRequestFromJson(
  Map<String, dynamic> json,
) => RequestPermissionRequest(
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => RequestPermissionRequestPermissions.fromJson(e as String))
      .toList(),
);

Map<String, dynamic> _$RequestPermissionRequestToJson(
  RequestPermissionRequest instance,
) => <String, dynamic>{
  'permissions': instance.permissions.map((e) => e.toJson()).toList(),
};
