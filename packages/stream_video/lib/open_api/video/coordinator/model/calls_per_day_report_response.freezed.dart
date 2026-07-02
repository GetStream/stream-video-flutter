// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calls_per_day_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallsPerDayReportResponse {
  List<DailyAggregateCallsPerDayReportResponse> get daily;

  /// Create a copy of CallsPerDayReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallsPerDayReportResponseCopyWith<CallsPerDayReportResponse> get copyWith =>
      _$CallsPerDayReportResponseCopyWithImpl<CallsPerDayReportResponse>(
        this as CallsPerDayReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallsPerDayReportResponse &&
            const DeepCollectionEquality().equals(other.daily, daily));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(daily));

  @override
  String toString() {
    return 'CallsPerDayReportResponse(daily: $daily)';
  }
}

/// @nodoc
abstract mixin class $CallsPerDayReportResponseCopyWith<$Res> {
  factory $CallsPerDayReportResponseCopyWith(
    CallsPerDayReportResponse value,
    $Res Function(CallsPerDayReportResponse) _then,
  ) = _$CallsPerDayReportResponseCopyWithImpl;
  @useResult
  $Res call({List<DailyAggregateCallsPerDayReportResponse> daily});
}

/// @nodoc
class _$CallsPerDayReportResponseCopyWithImpl<$Res>
    implements $CallsPerDayReportResponseCopyWith<$Res> {
  _$CallsPerDayReportResponseCopyWithImpl(this._self, this._then);

  final CallsPerDayReportResponse _self;
  final $Res Function(CallsPerDayReportResponse) _then;

  /// Create a copy of CallsPerDayReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      CallsPerDayReportResponse(
        daily: null == daily
            ? _self.daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyAggregateCallsPerDayReportResponse>,
      ),
    );
  }
}
