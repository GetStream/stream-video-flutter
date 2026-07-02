// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolution_metrics_time_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResolutionMetricsTimeSeries {
  MetricTimeSeries? get height;
  MetricTimeSeries? get width;

  /// Create a copy of ResolutionMetricsTimeSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResolutionMetricsTimeSeriesCopyWith<ResolutionMetricsTimeSeries>
  get copyWith =>
      _$ResolutionMetricsTimeSeriesCopyWithImpl<ResolutionMetricsTimeSeries>(
        this as ResolutionMetricsTimeSeries,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResolutionMetricsTimeSeries &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(runtimeType, height, width);

  @override
  String toString() {
    return 'ResolutionMetricsTimeSeries(height: $height, width: $width)';
  }
}

/// @nodoc
abstract mixin class $ResolutionMetricsTimeSeriesCopyWith<$Res> {
  factory $ResolutionMetricsTimeSeriesCopyWith(
    ResolutionMetricsTimeSeries value,
    $Res Function(ResolutionMetricsTimeSeries) _then,
  ) = _$ResolutionMetricsTimeSeriesCopyWithImpl;
  @useResult
  $Res call({MetricTimeSeries? height, MetricTimeSeries? width});
}

/// @nodoc
class _$ResolutionMetricsTimeSeriesCopyWithImpl<$Res>
    implements $ResolutionMetricsTimeSeriesCopyWith<$Res> {
  _$ResolutionMetricsTimeSeriesCopyWithImpl(this._self, this._then);

  final ResolutionMetricsTimeSeries _self;
  final $Res Function(ResolutionMetricsTimeSeries) _then;

  /// Create a copy of ResolutionMetricsTimeSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? height = freezed, Object? width = freezed}) {
    return _then(
      ResolutionMetricsTimeSeries(
        height: freezed == height
            ? _self.height
            : height // ignore: cast_nullable_to_non_nullable
                  as MetricTimeSeries?,
        width: freezed == width
            ? _self.width
            : width // ignore: cast_nullable_to_non_nullable
                  as MetricTimeSeries?,
      ),
    );
  }
}
