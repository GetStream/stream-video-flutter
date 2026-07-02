// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_count_over_time_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantCountOverTimeResponse _$ParticipantCountOverTimeResponseFromJson(
  Map<String, dynamic> json,
) => ParticipantCountOverTimeResponse(
  byMinute: (json['by_minute'] as List<dynamic>?)
      ?.map(
        (e) => ParticipantCountByMinuteResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ParticipantCountOverTimeResponseToJson(
  ParticipantCountOverTimeResponse instance,
) => <String, dynamic>{
  'by_minute': instance.byMinute?.map((e) => e.toJson()).toList(),
};
