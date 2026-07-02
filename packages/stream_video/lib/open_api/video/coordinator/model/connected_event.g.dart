// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedEvent _$ConnectedEventFromJson(Map<String, dynamic> json) =>
    ConnectedEvent(
      connectionId: json['connection_id'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      me: OwnUserResponse.fromJson(json['me'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ConnectedEventToJson(ConnectedEvent instance) =>
    <String, dynamic>{
      'connection_id': instance.connectionId,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'me': instance.me.toJson(),
      'type': instance.type,
    };
