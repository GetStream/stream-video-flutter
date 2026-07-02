// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_report_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsReportSummaryResponse _$CallStatsReportSummaryResponseFromJson(
  Map<String, dynamic> json,
) => CallStatsReportSummaryResponse(
  callCid: json['call_cid'] as String,
  callDurationSeconds: (json['call_duration_seconds'] as num).toInt(),
  callSessionId: json['call_session_id'] as String,
  callStatus: json['call_status'] as String,
  createdAt: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  firstStatsTime: const EpochDateTimeConverter().fromJson(
    json['first_stats_time'] as Object,
  ),
  minUserRating: (json['min_user_rating'] as num?)?.toInt(),
  qualityScore: (json['quality_score'] as num?)?.toInt(),
);

Map<String, dynamic> _$CallStatsReportSummaryResponseToJson(
  CallStatsReportSummaryResponse instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'call_duration_seconds': instance.callDurationSeconds,
  'call_session_id': instance.callSessionId,
  'call_status': instance.callStatus,
  'created_at': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAt,
    const EpochDateTimeConverter().toJson,
  ),
  'first_stats_time': const EpochDateTimeConverter().toJson(
    instance.firstStatsTime,
  ),
  'min_user_rating': instance.minUserRating,
  'quality_score': instance.qualityScore,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
