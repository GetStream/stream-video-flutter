// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_or_create_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrCreateCallResponse _$GetOrCreateCallResponseFromJson(
  Map<String, dynamic> json,
) => GetOrCreateCallResponse(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  created: json['created'] as bool,
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
);

Map<String, dynamic> _$GetOrCreateCallResponseToJson(
  GetOrCreateCallResponse instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'created': instance.created,
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
  'membership': instance.membership?.toJson(),
  'own_capabilities': instance.ownCapabilities.map((e) => e.toJson()).toList(),
};
