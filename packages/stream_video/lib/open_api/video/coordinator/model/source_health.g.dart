// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceHealth _$SourceHealthFromJson(Map<String, dynamic> json) => SourceHealth(
  coHostPeak: (json['co_host_peak'] as num).toInt(),
  deadAirS: (json['dead_air_s'] as num).toInt(),
  interruptions: (json['interruptions'] as List<dynamic>)
      .map((e) => SourceInterruption.fromJson(e as Map<String, dynamic>))
      .toList(),
  publisherSessions: (json['publisher_sessions'] as List<dynamic>)
      .map((e) => PublisherSession.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SourceHealthToJson(SourceHealth instance) =>
    <String, dynamic>{
      'co_host_peak': instance.coHostPeak,
      'dead_air_s': instance.deadAirS,
      'interruptions': instance.interruptions.map((e) => e.toJson()).toList(),
      'publisher_sessions': instance.publisherSessions
          .map((e) => e.toJson())
          .toList(),
    };
