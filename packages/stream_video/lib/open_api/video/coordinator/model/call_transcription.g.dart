// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTranscription _$CallTranscriptionFromJson(Map<String, dynamic> json) =>
    CallTranscription(
      endTime: const EpochDateTimeConverter().fromJson(
        json['end_time'] as Object,
      ),
      filename: json['filename'] as String,
      sessionId: json['session_id'] as String,
      startTime: const EpochDateTimeConverter().fromJson(
        json['start_time'] as Object,
      ),
      url: json['url'] as String,
    );

Map<String, dynamic> _$CallTranscriptionToJson(CallTranscription instance) =>
    <String, dynamic>{
      'end_time': const EpochDateTimeConverter().toJson(instance.endTime),
      'filename': instance.filename,
      'session_id': instance.sessionId,
      'start_time': const EpochDateTimeConverter().toJson(instance.startTime),
      'url': instance.url,
    };
