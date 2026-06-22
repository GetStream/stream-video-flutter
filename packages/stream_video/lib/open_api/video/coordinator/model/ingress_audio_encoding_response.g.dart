// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_audio_encoding_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressAudioEncodingResponse _$IngressAudioEncodingResponseFromJson(
  Map<String, dynamic> json,
) => IngressAudioEncodingResponse(
  bitrate: (json['bitrate'] as num).toInt(),
  channels: (json['channels'] as num).toInt(),
  enableDtx: json['enable_dtx'] as bool,
);

Map<String, dynamic> _$IngressAudioEncodingResponseToJson(
  IngressAudioEncodingResponse instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate,
  'channels': instance.channels,
  'enable_dtx': instance.enableDtx,
};
