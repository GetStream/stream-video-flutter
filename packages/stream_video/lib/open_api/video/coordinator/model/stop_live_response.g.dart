// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_live_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopLiveResponse _$StopLiveResponseFromJson(Map<String, dynamic> json) =>
    StopLiveResponse(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$StopLiveResponseToJson(StopLiveResponse instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'duration': instance.duration,
    };
