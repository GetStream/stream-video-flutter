// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unpin_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnpinRequest _$UnpinRequestFromJson(Map<String, dynamic> json) => UnpinRequest(
  sessionId: json['session_id'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$UnpinRequestToJson(UnpinRequest instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'user_id': instance.userId,
    };
