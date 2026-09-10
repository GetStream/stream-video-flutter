// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_participants_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallParticipantsResponse _$QueryCallParticipantsResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallParticipantsResponse(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  membership: json['membership'] == null
      ? null
      : MemberResponse.fromJson(json['membership'] as Map<String, dynamic>),
  ownCapabilities: (json['own_capabilities'] as List<dynamic>)
      .map((e) => OwnCapability.fromJson(e as String))
      .toList(),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => CallParticipantResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalParticipants: (json['total_participants'] as num).toInt(),
);

Map<String, dynamic> _$QueryCallParticipantsResponseToJson(
  QueryCallParticipantsResponse instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
  'membership': instance.membership?.toJson(),
  'own_capabilities': instance.ownCapabilities.map((e) => e.toJson()).toList(),
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'total_participants': instance.totalParticipants,
};
