// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinRequest _$PinRequestFromJson(Map<String, dynamic> json) => PinRequest(
  sessionId: json['session_id'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$PinRequestToJson(PinRequest instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'user_id': instance.userId,
    };
