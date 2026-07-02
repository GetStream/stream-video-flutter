// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoLiveResponse _$GoLiveResponseFromJson(Map<String, dynamic> json) =>
    GoLiveResponse(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$GoLiveResponseToJson(GoLiveResponse instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'duration': instance.duration,
    };
