// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_sip_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveSipAuthRequest _$ResolveSipAuthRequestFromJson(
  Map<String, dynamic> json,
) => ResolveSipAuthRequest(
  fromHost: json['from_host'] as String?,
  sipCallerNumber: json['sip_caller_number'] as String,
  sipTrunkNumber: json['sip_trunk_number'] as String,
  sourceIp: json['source_ip'] as String?,
);

Map<String, dynamic> _$ResolveSipAuthRequestToJson(
  ResolveSipAuthRequest instance,
) => <String, dynamic>{
  'from_host': instance.fromHost,
  'sip_caller_number': instance.sipCallerNumber,
  'sip_trunk_number': instance.sipTrunkNumber,
  'source_ip': instance.sourceIp,
};
