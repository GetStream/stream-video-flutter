// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRecording _$CallRecordingFromJson(Map<String, dynamic> json) =>
    CallRecording(
      endTime: const StreamDateTimeConverter().fromJson(
        json['end_time'] as Object,
      ),
      filename: json['filename'] as String,
      recordingType: json['recording_type'] as String,
      sessionId: json['session_id'] as String,
      startTime: const StreamDateTimeConverter().fromJson(
        json['start_time'] as Object,
      ),
      url: json['url'] as String,
    );

Map<String, dynamic> _$CallRecordingToJson(CallRecording instance) =>
    <String, dynamic>{
      'end_time': const StreamDateTimeConverter().toJson(instance.endTime),
      'filename': instance.filename,
      'recording_type': instance.recordingType,
      'session_id': instance.sessionId,
      'start_time': const StreamDateTimeConverter().toJson(instance.startTime),
      'url': instance.url,
    };
