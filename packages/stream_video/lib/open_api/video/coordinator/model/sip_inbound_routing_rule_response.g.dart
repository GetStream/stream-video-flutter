// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_inbound_routing_rule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPInboundRoutingRuleResponse _$SIPInboundRoutingRuleResponseFromJson(
  Map<String, dynamic> json,
) => SIPInboundRoutingRuleResponse(
  callConfigs: json['call_configs'] == null
      ? null
      : SIPCallConfigsResponse.fromJson(
          json['call_configs'] as Map<String, dynamic>,
        ),
  calledNumbers: (json['called_numbers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  callerConfigs: json['caller_configs'] == null
      ? null
      : SIPCallerConfigsResponse.fromJson(
          json['caller_configs'] as Map<String, dynamic>,
        ),
  callerNumbers: (json['caller_numbers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  directRoutingConfigs: json['direct_routing_configs'] == null
      ? null
      : SIPDirectRoutingRuleCallConfigsResponse.fromJson(
          json['direct_routing_configs'] as Map<String, dynamic>,
        ),
  duration: json['duration'] as String,
  id: json['id'] as String,
  name: json['name'] as String,
  pinProtectionConfigs: json['pin_protection_configs'] == null
      ? null
      : SIPPinProtectionConfigsResponse.fromJson(
          json['pin_protection_configs'] as Map<String, dynamic>,
        ),
  pinRoutingConfigs: json['pin_routing_configs'] == null
      ? null
      : SIPInboundRoutingRulePinConfigsResponse.fromJson(
          json['pin_routing_configs'] as Map<String, dynamic>,
        ),
  trunkIds: (json['trunk_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  updatedAt: const EpochDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$SIPInboundRoutingRuleResponseToJson(
  SIPInboundRoutingRuleResponse instance,
) => <String, dynamic>{
  'call_configs': instance.callConfigs,
  'called_numbers': instance.calledNumbers,
  'caller_configs': instance.callerConfigs,
  'caller_numbers': instance.callerNumbers,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'direct_routing_configs': instance.directRoutingConfigs,
  'duration': instance.duration,
  'id': instance.id,
  'name': instance.name,
  'pin_protection_configs': instance.pinProtectionConfigs,
  'pin_routing_configs': instance.pinRoutingConfigs,
  'trunk_ids': instance.trunkIds,
  'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
};
