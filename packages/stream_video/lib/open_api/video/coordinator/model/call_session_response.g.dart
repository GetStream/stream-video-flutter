// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionResponse _$CallSessionResponseFromJson(Map<String, dynamic> json) =>
    CallSessionResponse(
      acceptedBy: (json['accepted_by'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, const EpochDateTimeConverter().fromJson(e as Object)),
      ),
      anonymousParticipantCount: (json['anonymous_participant_count'] as num)
          .toInt(),
      endedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['ended_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      id: json['id'] as String,
      liveEndedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['live_ended_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      liveStartedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['live_started_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      missedBy: (json['missed_by'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, const EpochDateTimeConverter().fromJson(e as Object)),
      ),
      participants: (json['participants'] as List<dynamic>)
          .map(
            (e) => CallParticipantResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      participantsCountByRole: Map<String, int>.from(
        json['participants_count_by_role'] as Map,
      ),
      rejectedBy: (json['rejected_by'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, const EpochDateTimeConverter().fromJson(e as Object)),
      ),
      startedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['started_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      timerEndsAt: _$JsonConverterFromJson<Object, DateTime>(
        json['timer_ends_at'],
        const EpochDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$CallSessionResponseToJson(
  CallSessionResponse instance,
) => <String, dynamic>{
  'accepted_by': instance.acceptedBy.map(
    (k, e) => MapEntry(k, const EpochDateTimeConverter().toJson(e)),
  ),
  'anonymous_participant_count': instance.anonymousParticipantCount,
  'ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'id': instance.id,
  'live_ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.liveEndedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'live_started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.liveStartedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'missed_by': instance.missedBy.map(
    (k, e) => MapEntry(k, const EpochDateTimeConverter().toJson(e)),
  ),
  'participants': instance.participants,
  'participants_count_by_role': instance.participantsCountByRole,
  'rejected_by': instance.rejectedBy.map(
    (k, e) => MapEntry(k, const EpochDateTimeConverter().toJson(e)),
  ),
  'started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.startedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'timer_ends_at': _$JsonConverterToJson<Object, DateTime>(
    instance.timerEndsAt,
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
