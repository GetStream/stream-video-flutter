// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLocationResponse _$SharedLocationResponseFromJson(
  Map<String, dynamic> json,
) => SharedLocationResponse(
  channel: json['channel'] == null
      ? null
      : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelCid: json['channel_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdByDeviceId: json['created_by_device_id'] as String,
  duration: json['duration'] as String,
  endAt: _$JsonConverterFromJson<Object, DateTime>(
    json['end_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  updatedAt: const EpochDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$SharedLocationResponseToJson(
  SharedLocationResponse instance,
) => <String, dynamic>{
  'channel': instance.channel,
  'channel_cid': instance.channelCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'created_by_device_id': instance.createdByDeviceId,
  'duration': instance.duration,
  'end_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endAt,
    const EpochDateTimeConverter().toJson,
  ),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'message': instance.message,
  'message_id': instance.messageId,
  'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
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
