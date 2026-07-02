// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodConfig _$FloodConfigFromJson(Map<String, dynamic> json) => FloodConfig(
  identical_: json['identical_'] == null
      ? null
      : FloodIdenticalConfig.fromJson(
          json['identical_'] as Map<String, dynamic>,
        ),
  similar: json['similar'] == null
      ? null
      : FloodSimilarConfig.fromJson(json['similar'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FloodConfigToJson(FloodConfig instance) =>
    <String, dynamic>{
      'identical_': instance.identical_?.toJson(),
      'similar': instance.similar?.toJson(),
    };
