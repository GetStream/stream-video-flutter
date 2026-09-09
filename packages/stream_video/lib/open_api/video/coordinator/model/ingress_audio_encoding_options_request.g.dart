// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_audio_encoding_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressAudioEncodingOptionsRequest _$IngressAudioEncodingOptionsRequestFromJson(
  Map<String, dynamic> json,
) => IngressAudioEncodingOptionsRequest(
  bitrate: (json['bitrate'] as num).toInt(),
  channels: IngressAudioEncodingOptionsRequestChannels.fromJson(
    json['channels'] as String,
  ),
  enableDtx: json['enable_dtx'] as bool?,
);

Map<String, dynamic> _$IngressAudioEncodingOptionsRequestToJson(
  IngressAudioEncodingOptionsRequest instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate,
  'channels': instance.channels.toJson(),
  'enable_dtx': instance.enableDtx,
};
