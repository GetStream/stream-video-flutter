// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_pin_protection_configs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPPinProtectionConfigsResponse _$SIPPinProtectionConfigsResponseFromJson(
  Map<String, dynamic> json,
) => SIPPinProtectionConfigsResponse(
  defaultPin: json['default_pin'] as String?,
  enabled: json['enabled'] as bool,
  maxAttempts: (json['max_attempts'] as num?)?.toInt(),
  requiredPinDigits: (json['required_pin_digits'] as num?)?.toInt(),
);

Map<String, dynamic> _$SIPPinProtectionConfigsResponseToJson(
  SIPPinProtectionConfigsResponse instance,
) => <String, dynamic>{
  'default_pin': instance.defaultPin,
  'enabled': instance.enabled,
  'max_attempts': instance.maxAttempts,
  'required_pin_digits': instance.requiredPinDigits,
};
