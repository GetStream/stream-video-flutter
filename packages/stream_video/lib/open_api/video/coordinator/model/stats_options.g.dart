// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsOptions _$StatsOptionsFromJson(Map<String, dynamic> json) => StatsOptions(
  enableRtcStats: json['enable_rtc_stats'] as bool,
  reportingIntervalMs: (json['reporting_interval_ms'] as num).toInt(),
);

Map<String, dynamic> _$StatsOptionsToJson(StatsOptions instance) =>
    <String, dynamic>{
      'enable_rtc_stats': instance.enableRtcStats,
      'reporting_interval_ms': instance.reportingIntervalMs,
    };
