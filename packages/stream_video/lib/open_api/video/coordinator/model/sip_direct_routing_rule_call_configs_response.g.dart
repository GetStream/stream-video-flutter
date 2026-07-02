// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_direct_routing_rule_call_configs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPDirectRoutingRuleCallConfigsResponse
_$SIPDirectRoutingRuleCallConfigsResponseFromJson(Map<String, dynamic> json) =>
    SIPDirectRoutingRuleCallConfigsResponse(
      callId: json['call_id'] as String,
      callType: json['call_type'] as String,
    );

Map<String, dynamic> _$SIPDirectRoutingRuleCallConfigsResponseToJson(
  SIPDirectRoutingRuleCallConfigsResponse instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'call_type': instance.callType,
};
