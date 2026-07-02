// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_error_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionErrorEvent _$ConnectionErrorEventFromJson(
  Map<String, dynamic> json,
) => ConnectionErrorEvent(
  connectionId: json['connection_id'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ConnectionErrorEventToJson(
  ConnectionErrorEvent instance,
) => <String, dynamic>{
  'connection_id': instance.connectionId,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
