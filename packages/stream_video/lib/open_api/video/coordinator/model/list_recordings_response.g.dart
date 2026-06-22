// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_recordings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRecordingsResponse _$ListRecordingsResponseFromJson(
  Map<String, dynamic> json,
) => ListRecordingsResponse(
  duration: json['duration'] as String,
  recordings:
      (json['recordings'] as List<dynamic>?)
          ?.map((e) => CallRecording.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ListRecordingsResponseToJson(
  ListRecordingsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'recordings': instance.recordings,
};
