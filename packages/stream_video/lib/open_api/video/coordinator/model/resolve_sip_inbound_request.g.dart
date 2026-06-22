// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_sip_inbound_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveSipInboundRequest _$ResolveSipInboundRequestFromJson(
  Map<String, dynamic> json,
) => ResolveSipInboundRequest(
  challenge: json['challenge'] == null
      ? null
      : SIPChallengeRequest.fromJson(json['challenge'] as Map<String, dynamic>),
  routingNumber: json['routing_number'] as String?,
  sipCallerNumber: json['sip_caller_number'] as String,
  sipHeaders: (json['sip_headers'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  sipTrunkNumber: json['sip_trunk_number'] as String,
  trunkId: json['trunk_id'] as String?,
);

Map<String, dynamic> _$ResolveSipInboundRequestToJson(
  ResolveSipInboundRequest instance,
) => <String, dynamic>{
  'challenge': instance.challenge,
  'routing_number': instance.routingNumber,
  'sip_caller_number': instance.sipCallerNumber,
  'sip_headers': instance.sipHeaders,
  'sip_trunk_number': instance.sipTrunkNumber,
  'trunk_id': instance.trunkId,
};
