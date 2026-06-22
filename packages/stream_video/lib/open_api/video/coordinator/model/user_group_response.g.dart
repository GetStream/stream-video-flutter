// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroupResponse _$UserGroupResponseFromJson(Map<String, dynamic> json) =>
    UserGroupResponse(
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: json['created_by'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String,
      teamId: json['team_id'] as String?,
      updatedAt: const EpochDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
    );

Map<String, dynamic> _$UserGroupResponseToJson(UserGroupResponse instance) =>
    <String, dynamic>{
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy,
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
      'team_id': instance.teamId,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
    };
