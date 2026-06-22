// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdatedEvent _$AppUpdatedEventFromJson(Map<String, dynamic> json) =>
    AppUpdatedEvent(
      app: AppEventResponse.fromJson(json['app'] as Map<String, dynamic>),
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$AppUpdatedEventToJson(AppUpdatedEvent instance) =>
    <String, dynamic>{
      'app': instance.app,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'type': instance.type,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
