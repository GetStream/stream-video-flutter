// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absent_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbsentMetric {
  String get metric;
  String get reason;

  /// Create a copy of AbsentMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AbsentMetricCopyWith<AbsentMetric> get copyWith =>
      _$AbsentMetricCopyWithImpl<AbsentMetric>(
        this as AbsentMetric,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AbsentMetric &&
            (identical(other.metric, metric) || other.metric == metric) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, metric, reason);

  @override
  String toString() {
    return 'AbsentMetric(metric: $metric, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $AbsentMetricCopyWith<$Res> {
  factory $AbsentMetricCopyWith(
    AbsentMetric value,
    $Res Function(AbsentMetric) _then,
  ) = _$AbsentMetricCopyWithImpl;
  @useResult
  $Res call({String metric, String reason});
}

/// @nodoc
class _$AbsentMetricCopyWithImpl<$Res> implements $AbsentMetricCopyWith<$Res> {
  _$AbsentMetricCopyWithImpl(this._self, this._then);

  final AbsentMetric _self;
  final $Res Function(AbsentMetric) _then;

  /// Create a copy of AbsentMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? metric = null, Object? reason = null}) {
    return _then(
      AbsentMetric(
        metric: null == metric
            ? _self.metric
            : metric // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
