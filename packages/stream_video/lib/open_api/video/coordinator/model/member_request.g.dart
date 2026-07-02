// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRequest _$MemberRequestFromJson(Map<String, dynamic> json) =>
    MemberRequest(
      custom: json['custom'] as Map<String, dynamic>?,
      role: json['role'] as String?,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$MemberRequestToJson(MemberRequest instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'role': instance.role,
      'user_id': instance.userId,
    };
