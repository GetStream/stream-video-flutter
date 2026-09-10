// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poor_tail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoorTail _$PoorTailFromJson(Map<String, dynamic> json) => PoorTail(
  healthyPct: (json['healthy_pct'] as num?)?.toDouble(),
  healthyViewers: (json['healthy_viewers'] as num).toInt(),
  note: json['note'] as String,
  poorByCause: PoorByCause.fromJson(
    json['poor_by_cause'] as Map<String, dynamic>,
  ),
  poorTotal: (json['poor_total'] as num).toInt(),
  supporting: Supporting.fromJson(json['supporting'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PoorTailToJson(PoorTail instance) => <String, dynamic>{
  'healthy_pct': instance.healthyPct,
  'healthy_viewers': instance.healthyViewers,
  'note': instance.note,
  'poor_by_cause': instance.poorByCause.toJson(),
  'poor_total': instance.poorTotal,
  'supporting': instance.supporting.toJson(),
};
