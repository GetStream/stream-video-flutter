// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_audio_encoding_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressAudioEncodingOptionsRequest _$IngressAudioEncodingOptionsRequestFromJson(
  Map<String, dynamic> json,
) => IngressAudioEncodingOptionsRequest(
  bitrate: (json['bitrate'] as num).toInt(),
  channels: $enumDecode(
    _$IngressAudioEncodingOptionsRequestChannelsEnumMap,
    json['channels'],
    unknownValue: IngressAudioEncodingOptionsRequestChannels.unknown,
  ),
  enableDtx: json['enable_dtx'] as bool?,
);

Map<String, dynamic> _$IngressAudioEncodingOptionsRequestToJson(
  IngressAudioEncodingOptionsRequest instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate,
  'channels':
      _$IngressAudioEncodingOptionsRequestChannelsEnumMap[instance.channels]!,
  'enable_dtx': instance.enableDtx,
};

const _$IngressAudioEncodingOptionsRequestChannelsEnumMap = {
  IngressAudioEncodingOptionsRequestChannels.n1: '1',
  IngressAudioEncodingOptionsRequestChannels.n2: '2',
  IngressAudioEncodingOptionsRequestChannels.unknown: '_unknown',
};
