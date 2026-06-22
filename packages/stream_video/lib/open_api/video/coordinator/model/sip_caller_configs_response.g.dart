// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_caller_configs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPCallerConfigsResponse _$SIPCallerConfigsResponseFromJson(
  Map<String, dynamic> json,
) => SIPCallerConfigsResponse(
  customData: json['custom_data'] as Map<String, dynamic>? ?? {},
  id: json['id'] as String,
);

Map<String, dynamic> _$SIPCallerConfigsResponseToJson(
  SIPCallerConfigsResponse instance,
) => <String, dynamic>{'custom_data': instance.customData, 'id': instance.id};
