// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallReportResponse _$CallReportResponseFromJson(Map<String, dynamic> json) =>
    CallReportResponse(
      endedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['ended_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      score: (json['score'] as num).toDouble(),
      startedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['started_at'],
        const EpochDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$CallReportResponseToJson(CallReportResponse instance) =>
    <String, dynamic>{
      'ended_at': _$JsonConverterToJson<Object, DateTime>(
        instance.endedAt,
        const EpochDateTimeConverter().toJson,
      ),
      'score': instance.score,
      'started_at': _$JsonConverterToJson<Object, DateTime>(
        instance.startedAt,
        const EpochDateTimeConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
