// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_aggregate_calls_per_day_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyAggregateCallsPerDayReportResponse {
  String get date;
  CallsPerDayReport get report;

  /// Create a copy of DailyAggregateCallsPerDayReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyAggregateCallsPerDayReportResponseCopyWith<
    DailyAggregateCallsPerDayReportResponse
  >
  get copyWith =>
      _$DailyAggregateCallsPerDayReportResponseCopyWithImpl<
        DailyAggregateCallsPerDayReportResponse
      >(this as DailyAggregateCallsPerDayReportResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyAggregateCallsPerDayReportResponse &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.report, report) || other.report == report));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, report);

  @override
  String toString() {
    return 'DailyAggregateCallsPerDayReportResponse(date: $date, report: $report)';
  }
}

/// @nodoc
abstract mixin class $DailyAggregateCallsPerDayReportResponseCopyWith<$Res> {
  factory $DailyAggregateCallsPerDayReportResponseCopyWith(
    DailyAggregateCallsPerDayReportResponse value,
    $Res Function(DailyAggregateCallsPerDayReportResponse) _then,
  ) = _$DailyAggregateCallsPerDayReportResponseCopyWithImpl;
  @useResult
  $Res call({String date, CallsPerDayReport report});
}

/// @nodoc
class _$DailyAggregateCallsPerDayReportResponseCopyWithImpl<$Res>
    implements $DailyAggregateCallsPerDayReportResponseCopyWith<$Res> {
  _$DailyAggregateCallsPerDayReportResponseCopyWithImpl(this._self, this._then);

  final DailyAggregateCallsPerDayReportResponse _self;
  final $Res Function(DailyAggregateCallsPerDayReportResponse) _then;

  /// Create a copy of DailyAggregateCallsPerDayReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? report = null}) {
    return _then(
      DailyAggregateCallsPerDayReportResponse(
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        report: null == report
            ? _self.report
            : report // ignore: cast_nullable_to_non_nullable
                  as CallsPerDayReport,
      ),
    );
  }
}
