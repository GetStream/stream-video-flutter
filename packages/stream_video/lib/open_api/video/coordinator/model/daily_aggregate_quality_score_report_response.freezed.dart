// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_aggregate_quality_score_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyAggregateQualityScoreReportResponse {
  String get date;
  QualityScoreReport get report;

  /// Create a copy of DailyAggregateQualityScoreReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyAggregateQualityScoreReportResponseCopyWith<
    DailyAggregateQualityScoreReportResponse
  >
  get copyWith =>
      _$DailyAggregateQualityScoreReportResponseCopyWithImpl<
        DailyAggregateQualityScoreReportResponse
      >(this as DailyAggregateQualityScoreReportResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyAggregateQualityScoreReportResponse &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.report, report) || other.report == report));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, report);

  @override
  String toString() {
    return 'DailyAggregateQualityScoreReportResponse(date: $date, report: $report)';
  }
}

/// @nodoc
abstract mixin class $DailyAggregateQualityScoreReportResponseCopyWith<$Res> {
  factory $DailyAggregateQualityScoreReportResponseCopyWith(
    DailyAggregateQualityScoreReportResponse value,
    $Res Function(DailyAggregateQualityScoreReportResponse) _then,
  ) = _$DailyAggregateQualityScoreReportResponseCopyWithImpl;
  @useResult
  $Res call({String date, QualityScoreReport report});
}

/// @nodoc
class _$DailyAggregateQualityScoreReportResponseCopyWithImpl<$Res>
    implements $DailyAggregateQualityScoreReportResponseCopyWith<$Res> {
  _$DailyAggregateQualityScoreReportResponseCopyWithImpl(
    this._self,
    this._then,
  );

  final DailyAggregateQualityScoreReportResponse _self;
  final $Res Function(DailyAggregateQualityScoreReportResponse) _then;

  /// Create a copy of DailyAggregateQualityScoreReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? report = null}) {
    return _then(
      DailyAggregateQualityScoreReportResponse(
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        report: null == report
            ? _self.report
            : report // ignore: cast_nullable_to_non_nullable
                  as QualityScoreReport,
      ),
    );
  }
}
