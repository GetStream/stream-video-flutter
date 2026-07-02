// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RingSettingsRequest _$RingSettingsRequestFromJson(Map<String, dynamic> json) =>
    RingSettingsRequest(
      autoCancelTimeoutMs: (json['auto_cancel_timeout_ms'] as num).toInt(),
      incomingCallTimeoutMs: (json['incoming_call_timeout_ms'] as num).toInt(),
      missedCallTimeoutMs: (json['missed_call_timeout_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RingSettingsRequestToJson(
  RingSettingsRequest instance,
) => <String, dynamic>{
  'auto_cancel_timeout_ms': instance.autoCancelTimeoutMs,
  'incoming_call_timeout_ms': instance.incomingCallTimeoutMs,
  'missed_call_timeout_ms': instance.missedCallTimeoutMs,
};
