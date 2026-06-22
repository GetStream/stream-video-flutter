// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallParticipantResponse _$CallParticipantResponseFromJson(
  Map<String, dynamic> json,
) => CallParticipantResponse(
  joinedAt: const EpochDateTimeConverter().fromJson(
    json['joined_at'] as Object,
  ),
  role: json['role'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$CallParticipantResponseToJson(
  CallParticipantResponse instance,
) => <String, dynamic>{
  'joined_at': const EpochDateTimeConverter().toJson(instance.joinedAt),
  'role': instance.role,
  'user': instance.user,
  'user_session_id': instance.userSessionId,
};
