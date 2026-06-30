// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calls_per_day_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallsPerDayReport {
  int get count;

  /// Create a copy of CallsPerDayReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallsPerDayReportCopyWith<CallsPerDayReport> get copyWith =>
      _$CallsPerDayReportCopyWithImpl<CallsPerDayReport>(
        this as CallsPerDayReport,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallsPerDayReport &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'CallsPerDayReport(count: $count)';
  }
}

/// @nodoc
abstract mixin class $CallsPerDayReportCopyWith<$Res> {
  factory $CallsPerDayReportCopyWith(
    CallsPerDayReport value,
    $Res Function(CallsPerDayReport) _then,
  ) = _$CallsPerDayReportCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$CallsPerDayReportCopyWithImpl<$Res>
    implements $CallsPerDayReportCopyWith<$Res> {
  _$CallsPerDayReportCopyWithImpl(this._self, this._then);

  final CallsPerDayReport _self;
  final $Res Function(CallsPerDayReport) _then;

  /// Create a copy of CallsPerDayReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      CallsPerDayReport(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
