// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListResponse _$BlockListResponseFromJson(Map<String, dynamic> json) =>
    BlockListResponse(
      createdAt: _$JsonConverterFromJson<Object, DateTime>(
        json['created_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      id: json['id'] as String?,
      isLeetCheckEnabled: json['is_leet_check_enabled'] as bool,
      isPluralCheckEnabled: json['is_plural_check_enabled'] as bool,
      name: json['name'] as String,
      team: json['team'] as String?,
      type: json['type'] as String,
      updatedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['updated_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BlockListResponseToJson(BlockListResponse instance) =>
    <String, dynamic>{
      'created_at': _$JsonConverterToJson<Object, DateTime>(
        instance.createdAt,
        const EpochDateTimeConverter().toJson,
      ),
      'id': instance.id,
      'is_leet_check_enabled': instance.isLeetCheckEnabled,
      'is_plural_check_enabled': instance.isPluralCheckEnabled,
      'name': instance.name,
      'team': instance.team,
      'type': instance.type,
      'updated_at': _$JsonConverterToJson<Object, DateTime>(
        instance.updatedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'words': instance.words,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
