// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_inbound_routing_rule_pin_configs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPInboundRoutingRulePinConfigsResponse
_$SIPInboundRoutingRulePinConfigsResponseFromJson(Map<String, dynamic> json) =>
    SIPInboundRoutingRulePinConfigsResponse(
      customWebhookUrl: json['custom_webhook_url'] as String?,
      pinFailedAttemptPrompt: json['pin_failed_attempt_prompt'] as String?,
      pinHangupPrompt: json['pin_hangup_prompt'] as String?,
      pinPrompt: json['pin_prompt'] as String?,
      pinSuccessPrompt: json['pin_success_prompt'] as String?,
    );

Map<String, dynamic> _$SIPInboundRoutingRulePinConfigsResponseToJson(
  SIPInboundRoutingRulePinConfigsResponse instance,
) => <String, dynamic>{
  'custom_webhook_url': instance.customWebhookUrl,
  'pin_failed_attempt_prompt': instance.pinFailedAttemptPrompt,
  'pin_hangup_prompt': instance.pinHangupPrompt,
  'pin_prompt': instance.pinPrompt,
  'pin_success_prompt': instance.pinSuccessPrompt,
};
