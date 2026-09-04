// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_state_response_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStateResponseFields _$CallStateResponseFieldsFromJson(
  Map<String, dynamic> json,
) => CallStateResponseFields(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
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

Map<String, dynamic> _$CallStateResponseFieldsToJson(
  CallStateResponseFields instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'membership': instance.membership?.toJson(),
  'own_capabilities': instance.ownCapabilities.map((e) => e.toJson()).toList(),
};
