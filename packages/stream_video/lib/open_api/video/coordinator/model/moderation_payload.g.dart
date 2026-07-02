// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationPayload _$ModerationPayloadFromJson(
  Map<String, dynamic> json,
) => ModerationPayload(
  custom: json['custom'] as Map<String, dynamic>?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  texts: (json['texts'] as List<dynamic>?)?.map((e) => e as String).toList(),
  videos: (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ModerationPayloadToJson(ModerationPayload instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'images': instance.images,
      'texts': instance.texts,
      'videos': instance.videos,
    };
