// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedStatsResponse _$GroupedStatsResponseFromJson(
  Map<String, dynamic> json,
) => GroupedStatsResponse(
  name: json['name'] as String,
  unique: (json['unique'] as num).toInt(),
);

Map<String, dynamic> _$GroupedStatsResponseToJson(
  GroupedStatsResponse instance,
) => <String, dynamic>{'name': instance.name, 'unique': instance.unique};
