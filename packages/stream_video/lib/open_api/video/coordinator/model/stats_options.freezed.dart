// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatsOptions {
  bool get enableRtcStats;
  int get reportingIntervalMs;

  /// Create a copy of StatsOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatsOptionsCopyWith<StatsOptions> get copyWith =>
      _$StatsOptionsCopyWithImpl<StatsOptions>(
        this as StatsOptions,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatsOptions &&
            (identical(other.enableRtcStats, enableRtcStats) ||
                other.enableRtcStats == enableRtcStats) &&
            (identical(other.reportingIntervalMs, reportingIntervalMs) ||
                other.reportingIntervalMs == reportingIntervalMs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, enableRtcStats, reportingIntervalMs);

  @override
  String toString() {
    return 'StatsOptions(enableRtcStats: $enableRtcStats, reportingIntervalMs: $reportingIntervalMs)';
  }
}

/// @nodoc
abstract mixin class $StatsOptionsCopyWith<$Res> {
  factory $StatsOptionsCopyWith(
    StatsOptions value,
    $Res Function(StatsOptions) _then,
  ) = _$StatsOptionsCopyWithImpl;
  @useResult
  $Res call({bool enableRtcStats, int reportingIntervalMs});
}

/// @nodoc
class _$StatsOptionsCopyWithImpl<$Res> implements $StatsOptionsCopyWith<$Res> {
  _$StatsOptionsCopyWithImpl(this._self, this._then);

  final StatsOptions _self;
  final $Res Function(StatsOptions) _then;

  /// Create a copy of StatsOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableRtcStats = null,
    Object? reportingIntervalMs = null,
  }) {
    return _then(
      StatsOptions(
        enableRtcStats: null == enableRtcStats
            ? _self.enableRtcStats
            : enableRtcStats // ignore: cast_nullable_to_non_nullable
                  as bool,
        reportingIntervalMs: null == reportingIntervalMs
            ? _self.reportingIntervalMs
            : reportingIntervalMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
