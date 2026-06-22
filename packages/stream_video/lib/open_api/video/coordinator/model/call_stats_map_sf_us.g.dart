// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_map_sf_us.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsMapSFUs _$CallStatsMapSFUsFromJson(Map<String, dynamic> json) =>
    CallStatsMapSFUs(
      locations:
          (json['locations'] as List<dynamic>?)
              ?.map(
                (e) => SFULocationResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$CallStatsMapSFUsToJson(CallStatsMapSFUs instance) =>
    <String, dynamic>{'locations': instance.locations};
