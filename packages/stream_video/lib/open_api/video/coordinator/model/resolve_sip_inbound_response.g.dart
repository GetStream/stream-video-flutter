// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_sip_inbound_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveSipInboundResponse _$ResolveSipInboundResponseFromJson(
  Map<String, dynamic> json,
) => ResolveSipInboundResponse(
  credentials: SipInboundCredentials.fromJson(
    json['credentials'] as Map<String, dynamic>,
  ),
  duration: json['duration'] as String,
  sipRoutingRule: json['sip_routing_rule'] == null
      ? null
      : SIPInboundRoutingRuleResponse.fromJson(
          json['sip_routing_rule'] as Map<String, dynamic>,
        ),
  sipTrunk: json['sip_trunk'] == null
      ? null
      : SIPTrunkResponse.fromJson(json['sip_trunk'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResolveSipInboundResponseToJson(
  ResolveSipInboundResponse instance,
) => <String, dynamic>{
  'credentials': instance.credentials.toJson(),
  'duration': instance.duration,
  'sip_routing_rule': instance.sipRoutingRule?.toJson(),
  'sip_trunk': instance.sipTrunk?.toJson(),
};
