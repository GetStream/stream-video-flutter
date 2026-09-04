// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joins.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Joins _$JoinsFromJson(Map<String, dynamic> json) => Joins(
  disconnectReasons: Map<String, int>.from(json['disconnect_reasons'] as Map),
  failureStages: Map<String, int>.from(json['failure_stages'] as Map),
  joinAttempts: (json['join_attempts'] as num?)?.toInt(),
  joinSuccessRate: (json['join_success_rate'] as num?)?.toDouble(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$JoinsToJson(Joins instance) => <String, dynamic>{
  'disconnect_reasons': instance.disconnectReasons,
  'failure_stages': instance.failureStages,
  'join_attempts': instance.joinAttempts,
  'join_success_rate': instance.joinSuccessRate,
  'reason': instance.reason,
};
