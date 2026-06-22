// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsParticipant _$CallStatsParticipantFromJson(
  Map<String, dynamic> json,
) => CallStatsParticipant(
  latestActivityAt: _$JsonConverterFromJson<Object, DateTime>(
    json['latest_activity_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  name: json['name'] as String?,
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  sessions:
      (json['sessions'] as List<dynamic>?)
          ?.map(
            (e) =>
                CallStatsParticipantSession.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallStatsParticipantToJson(
  CallStatsParticipant instance,
) => <String, dynamic>{
  'latest_activity_at': _$JsonConverterToJson<Object, DateTime>(
    instance.latestActivityAt,
    const EpochDateTimeConverter().toJson,
  ),
  'name': instance.name,
  'roles': instance.roles,
  'sessions': instance.sessions,
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
