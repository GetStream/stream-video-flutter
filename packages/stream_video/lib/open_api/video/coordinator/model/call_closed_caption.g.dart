// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_caption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallClosedCaption _$CallClosedCaptionFromJson(Map<String, dynamic> json) =>
    CallClosedCaption(
      endTime: const EpochDateTimeConverter().fromJson(
        json['end_time'] as Object,
      ),
      id: json['id'] as String,
      language: json['language'] as String,
      service: json['service'] as String?,
      speakerId: json['speaker_id'] as String,
      startTime: const EpochDateTimeConverter().fromJson(
        json['start_time'] as Object,
      ),
      text: json['text'] as String,
      translated: json['translated'] as bool,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallClosedCaptionToJson(CallClosedCaption instance) =>
    <String, dynamic>{
      'end_time': const EpochDateTimeConverter().toJson(instance.endTime),
      'id': instance.id,
      'language': instance.language,
      'service': instance.service,
      'speaker_id': instance.speakerId,
      'start_time': const EpochDateTimeConverter().toJson(instance.startTime),
      'text': instance.text,
      'translated': instance.translated,
      'user': instance.user.toJson(),
    };
