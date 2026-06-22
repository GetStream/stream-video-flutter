// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_ingress_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallIngressResponse _$CallIngressResponseFromJson(Map<String, dynamic> json) =>
    CallIngressResponse(
      rtmp: RTMPIngress.fromJson(json['rtmp'] as Map<String, dynamic>),
      srt: SRTIngress.fromJson(json['srt'] as Map<String, dynamic>),
      whip: WHIPIngress.fromJson(json['whip'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallIngressResponseToJson(
  CallIngressResponse instance,
) => <String, dynamic>{
  'rtmp': instance.rtmp,
  'srt': instance.srt,
  'whip': instance.whip,
};
