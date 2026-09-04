// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_interruption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceInterruption _$SourceInterruptionFromJson(Map<String, dynamic> json) =>
    SourceInterruption(
      atOffsetMin: (json['at_offset_min'] as num).toDouble(),
      deadAirS: (json['dead_air_s'] as num).toInt(),
      kind: json['kind'] as String,
      seamless: json['seamless'] as bool?,
    );

Map<String, dynamic> _$SourceInterruptionToJson(SourceInterruption instance) =>
    <String, dynamic>{
      'at_offset_min': instance.atOffsetMin,
      'dead_air_s': instance.deadAirS,
      'kind': instance.kind,
      'seamless': instance.seamless,
    };
