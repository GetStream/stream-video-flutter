// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Command _$CommandFromJson(Map<String, dynamic> json) => Command(
  args: json['args'] as String,
  createdAt: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  description: json['description'] as String,
  name: json['name'] as String,
  set: json['set'] as String,
  updatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['updated_at'],
    const EpochDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
  'args': instance.args,
  'created_at': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAt,
    const EpochDateTimeConverter().toJson,
  ),
  'description': instance.description,
  'name': instance.name,
  'set': instance.set,
  'updated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.updatedAt,
    const EpochDateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
