// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_session_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSessionDetails _$ParticipantSessionDetailsFromJson(
  Map<String, dynamic> json,
) => ParticipantSessionDetails(
  durationInSeconds: (json['duration_in_seconds'] as num?)?.toInt(),
  joinedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['joined_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  leftAt: _$JsonConverterFromJson<Object, DateTime>(
    json['left_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  publisherType: json['publisher_type'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  userId: json['user_id'] as String,
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$ParticipantSessionDetailsToJson(
  ParticipantSessionDetails instance,
) => <String, dynamic>{
  'duration_in_seconds': instance.durationInSeconds,
  'joined_at': _$JsonConverterToJson<Object, DateTime>(
    instance.joinedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'left_at': _$JsonConverterToJson<Object, DateTime>(
    instance.leftAt,
    const EpochDateTimeConverter().toJson,
  ),
  'publisher_type': instance.publisherType,
  'roles': instance.roles,
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
