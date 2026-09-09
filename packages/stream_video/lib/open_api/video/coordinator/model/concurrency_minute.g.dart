// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concurrency_minute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConcurrencyMinute _$ConcurrencyMinuteFromJson(Map<String, dynamic> json) =>
    ConcurrencyMinute(
      joins: (json['joins'] as num).toInt(),
      leaves: (json['leaves'] as num).toInt(),
      max: (json['max'] as num).toInt(),
      min: (json['min'] as num).toInt(),
      minute: json['minute'] as String,
    );

Map<String, dynamic> _$ConcurrencyMinuteToJson(ConcurrencyMinute instance) =>
    <String, dynamic>{
      'joins': instance.joins,
      'leaves': instance.leaves,
      'max': instance.max,
      'min': instance.min,
      'minute': instance.minute,
    };
