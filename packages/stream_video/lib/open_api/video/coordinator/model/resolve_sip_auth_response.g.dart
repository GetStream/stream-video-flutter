// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_sip_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveSipAuthResponse _$ResolveSipAuthResponseFromJson(
  Map<String, dynamic> json,
) => ResolveSipAuthResponse(
  authResult: json['auth_result'] as String,
  duration: json['duration'] as String,
  password: json['password'] as String?,
  trunkId: json['trunk_id'] as String?,
  username: json['username'] as String?,
);

Map<String, dynamic> _$ResolveSipAuthResponseToJson(
  ResolveSipAuthResponse instance,
) => <String, dynamic>{
  'auth_result': instance.authResult,
  'duration': instance.duration,
  'password': instance.password,
  'trunk_id': instance.trunkId,
  'username': instance.username,
};
