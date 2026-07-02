// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_warning_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionWarningResponse _$SessionWarningResponseFromJson(
  Map<String, dynamic> json,
) => SessionWarningResponse(
  code: json['code'] as String,
  time: _$JsonConverterFromJson<Object, DateTime>(
    json['time'],
    const EpochDateTimeConverter().fromJson,
  ),
  warning: json['warning'] as String,
);

Map<String, dynamic> _$SessionWarningResponseToJson(
  SessionWarningResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'time': _$JsonConverterToJson<Object, DateTime>(
    instance.time,
    const EpochDateTimeConverter().toJson,
  ),
  'warning': instance.warning,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
