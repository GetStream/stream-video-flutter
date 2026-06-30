// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_duration_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallDurationReport {
  List<ReportByHistogramBucket> get histogram;

  /// Create a copy of CallDurationReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallDurationReportCopyWith<CallDurationReport> get copyWith =>
      _$CallDurationReportCopyWithImpl<CallDurationReport>(
        this as CallDurationReport,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallDurationReport &&
            const DeepCollectionEquality().equals(other.histogram, histogram));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(histogram));

  @override
  String toString() {
    return 'CallDurationReport(histogram: $histogram)';
  }
}

/// @nodoc
abstract mixin class $CallDurationReportCopyWith<$Res> {
  factory $CallDurationReportCopyWith(
    CallDurationReport value,
    $Res Function(CallDurationReport) _then,
  ) = _$CallDurationReportCopyWithImpl;
  @useResult
  $Res call({List<ReportByHistogramBucket> histogram});
}

/// @nodoc
class _$CallDurationReportCopyWithImpl<$Res>
    implements $CallDurationReportCopyWith<$Res> {
  _$CallDurationReportCopyWithImpl(this._self, this._then);

  final CallDurationReport _self;
  final $Res Function(CallDurationReport) _then;

  /// Create a copy of CallDurationReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? histogram = null}) {
    return _then(
      CallDurationReport(
        histogram: null == histogram
            ? _self.histogram
            : histogram // ignore: cast_nullable_to_non_nullable
                  as List<ReportByHistogramBucket>,
      ),
    );
  }
}
