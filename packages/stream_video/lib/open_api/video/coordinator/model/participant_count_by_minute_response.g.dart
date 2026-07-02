// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_count_by_minute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantCountByMinuteResponse _$ParticipantCountByMinuteResponseFromJson(
  Map<String, dynamic> json,
) => ParticipantCountByMinuteResponse(
  first: (json['first'] as num).toInt(),
  last: (json['last'] as num).toInt(),
  max: (json['max'] as num).toInt(),
  min: (json['min'] as num).toInt(),
  startTs: const EpochDateTimeConverter().fromJson(json['start_ts'] as Object),
);

Map<String, dynamic> _$ParticipantCountByMinuteResponseToJson(
  ParticipantCountByMinuteResponse instance,
) => <String, dynamic>{
  'first': instance.first,
  'last': instance.last,
  'max': instance.max,
  'min': instance.min,
  'start_ts': const EpochDateTimeConverter().toJson(instance.startTs),
};
