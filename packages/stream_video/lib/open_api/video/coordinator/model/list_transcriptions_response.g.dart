// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transcriptions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTranscriptionsResponse _$ListTranscriptionsResponseFromJson(
  Map<String, dynamic> json,
) => ListTranscriptionsResponse(
  duration: json['duration'] as String,
  transcriptions:
      (json['transcriptions'] as List<dynamic>?)
          ?.map((e) => CallTranscription.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ListTranscriptionsResponseToJson(
  ListTranscriptionsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'transcriptions': instance.transcriptions.map((e) => e.toJson()).toList(),
};
