// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poor_by_cause.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoorByCause _$PoorByCauseFromJson(Map<String, dynamic> json) => PoorByCause(
  delivery: (json['delivery'] as num).toInt(),
  edge: (json['edge'] as num).toInt(),
  isolatedLocal: (json['isolated_local'] as num).toInt(),
  source: (json['source'] as num).toInt(),
  unattributed: (json['unattributed'] as num).toInt(),
);

Map<String, dynamic> _$PoorByCauseToJson(PoorByCause instance) =>
    <String, dynamic>{
      'delivery': instance.delivery,
      'edge': instance.edge,
      'isolated_local': instance.isolatedLocal,
      'source': instance.source,
      'unattributed': instance.unattributed,
    };
