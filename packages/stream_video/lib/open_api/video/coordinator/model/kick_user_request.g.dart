// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kick_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KickUserRequest _$KickUserRequestFromJson(Map<String, dynamic> json) =>
    KickUserRequest(
      block: json['block'] as bool?,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$KickUserRequestToJson(KickUserRequest instance) =>
    <String, dynamic>{'block': instance.block, 'user_id': instance.userId};
