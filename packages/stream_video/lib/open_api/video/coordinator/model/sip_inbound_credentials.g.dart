// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_inbound_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipInboundCredentials _$SipInboundCredentialsFromJson(
  Map<String, dynamic> json,
) => SipInboundCredentials(
  apiKey: json['api_key'] as String,
  callCustomData: json['call_custom_data'] as Map<String, dynamic>,
  callId: json['call_id'] as String,
  callType: json['call_type'] as String,
  token: json['token'] as String,
  userCustomData: json['user_custom_data'] as Map<String, dynamic>,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$SipInboundCredentialsToJson(
  SipInboundCredentials instance,
) => <String, dynamic>{
  'api_key': instance.apiKey,
  'call_custom_data': instance.callCustomData,
  'call_id': instance.callId,
  'call_type': instance.callType,
  'token': instance.token,
  'user_custom_data': instance.userCustomData,
  'user_id': instance.userId,
};
