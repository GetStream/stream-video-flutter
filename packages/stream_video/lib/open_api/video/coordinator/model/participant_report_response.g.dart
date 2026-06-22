// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantReportResponse _$ParticipantReportResponseFromJson(
  Map<String, dynamic> json,
) => ParticipantReportResponse(
  byBrowser: (json['by_browser'] as List<dynamic>?)
      ?.map((e) => GroupedStatsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  byCountry: (json['by_country'] as List<dynamic>?)
      ?.map((e) => GroupedStatsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  byDevice: (json['by_device'] as List<dynamic>?)
      ?.map((e) => GroupedStatsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  byOperatingSystem: (json['by_operating_system'] as List<dynamic>?)
      ?.map((e) => GroupedStatsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  countOverTime: json['count_over_time'] == null
      ? null
      : ParticipantCountOverTimeResponse.fromJson(
          json['count_over_time'] as Map<String, dynamic>,
        ),
  maxConcurrent: (json['max_concurrent'] as num?)?.toInt(),
  publishers: json['publishers'] == null
      ? null
      : PublisherStatsResponse.fromJson(
          json['publishers'] as Map<String, dynamic>,
        ),
  subscribers: json['subscribers'] == null
      ? null
      : SubscriberStatsResponse.fromJson(
          json['subscribers'] as Map<String, dynamic>,
        ),
  sum: (json['sum'] as num).toInt(),
  unique: (json['unique'] as num).toInt(),
);

Map<String, dynamic> _$ParticipantReportResponseToJson(
  ParticipantReportResponse instance,
) => <String, dynamic>{
  'by_browser': instance.byBrowser,
  'by_country': instance.byCountry,
  'by_device': instance.byDevice,
  'by_operating_system': instance.byOperatingSystem,
  'count_over_time': instance.countOverTime,
  'max_concurrent': instance.maxConcurrent,
  'publishers': instance.publishers,
  'subscribers': instance.subscribers,
  'sum': instance.sum,
  'unique': instance.unique,
};
