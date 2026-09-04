// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_bands.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreBands _$ScoreBandsFromJson(Map<String, dynamic> json) => ScoreBands(
  good: (json['good'] as num?)?.toDouble(),
  ok: (json['ok'] as num?)?.toDouble(),
  poor: (json['poor'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ScoreBandsToJson(ScoreBands instance) =>
    <String, dynamic>{
      'good': instance.good,
      'ok': instance.ok,
      'poor': instance.poor,
    };
