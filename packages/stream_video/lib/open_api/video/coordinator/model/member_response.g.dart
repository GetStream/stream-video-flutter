// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberResponse _$MemberResponseFromJson(Map<String, dynamic> json) =>
    MemberResponse(
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>? ?? {},
      deletedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['deleted_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      role: json['role'] as String?,
      updatedAt: const EpochDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$MemberResponseToJson(MemberResponse instance) =>
    <String, dynamic>{
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'role': instance.role,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
      'user': instance.user,
      'user_id': instance.userId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
