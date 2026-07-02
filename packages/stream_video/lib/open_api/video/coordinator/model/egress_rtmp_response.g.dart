// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_rtmp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EgressRTMPResponse _$EgressRTMPResponseFromJson(Map<String, dynamic> json) =>
    EgressRTMPResponse(
      name: json['name'] as String,
      startedAt: const EpochDateTimeConverter().fromJson(
        json['started_at'] as Object,
      ),
      streamKey: json['stream_key'] as String?,
      streamUrl: json['stream_url'] as String?,
    );

Map<String, dynamic> _$EgressRTMPResponseToJson(EgressRTMPResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'started_at': const EpochDateTimeConverter().toJson(instance.startedAt),
      'stream_key': instance.streamKey,
      'stream_url': instance.streamUrl,
    };
