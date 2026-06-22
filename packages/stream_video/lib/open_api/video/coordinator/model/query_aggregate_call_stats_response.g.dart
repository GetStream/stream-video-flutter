// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_aggregate_call_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryAggregateCallStatsResponse _$QueryAggregateCallStatsResponseFromJson(
  Map<String, dynamic> json,
) => QueryAggregateCallStatsResponse(
  callDurationReport: json['call_duration_report'] == null
      ? null
      : CallDurationReportResponse.fromJson(
          json['call_duration_report'] as Map<String, dynamic>,
        ),
  callParticipantCountReport: json['call_participant_count_report'] == null
      ? null
      : CallParticipantCountReportResponse.fromJson(
          json['call_participant_count_report'] as Map<String, dynamic>,
        ),
  callsPerDayReport: json['calls_per_day_report'] == null
      ? null
      : CallsPerDayReportResponse.fromJson(
          json['calls_per_day_report'] as Map<String, dynamic>,
        ),
  duration: json['duration'] as String,
  networkMetricsReport: json['network_metrics_report'] == null
      ? null
      : NetworkMetricsReportResponse.fromJson(
          json['network_metrics_report'] as Map<String, dynamic>,
        ),
  qualityScoreReport: json['quality_score_report'] == null
      ? null
      : QualityScoreReportResponse.fromJson(
          json['quality_score_report'] as Map<String, dynamic>,
        ),
  sdkUsageReport: json['sdk_usage_report'] == null
      ? null
      : SDKUsageReportResponse.fromJson(
          json['sdk_usage_report'] as Map<String, dynamic>,
        ),
  userFeedbackReport: json['user_feedback_report'] == null
      ? null
      : UserFeedbackReportResponse.fromJson(
          json['user_feedback_report'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QueryAggregateCallStatsResponseToJson(
  QueryAggregateCallStatsResponse instance,
) => <String, dynamic>{
  'call_duration_report': instance.callDurationReport,
  'call_participant_count_report': instance.callParticipantCountReport,
  'calls_per_day_report': instance.callsPerDayReport,
  'duration': instance.duration,
  'network_metrics_report': instance.networkMetricsReport,
  'quality_score_report': instance.qualityScoreReport,
  'sdk_usage_report': instance.sdkUsageReport,
  'user_feedback_report': instance.userFeedbackReport,
};
