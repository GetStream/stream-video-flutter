// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_metrics_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetworkMetricsReportResponse {
  double? get averageConnectionTime;
  double? get averageJitter;
  double? get averageLatency;
  double? get averageTimeToReconnect;

  /// Create a copy of NetworkMetricsReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetworkMetricsReportResponseCopyWith<NetworkMetricsReportResponse>
  get copyWith =>
      _$NetworkMetricsReportResponseCopyWithImpl<NetworkMetricsReportResponse>(
        this as NetworkMetricsReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetworkMetricsReportResponse &&
            (identical(other.averageConnectionTime, averageConnectionTime) ||
                other.averageConnectionTime == averageConnectionTime) &&
            (identical(other.averageJitter, averageJitter) ||
                other.averageJitter == averageJitter) &&
            (identical(other.averageLatency, averageLatency) ||
                other.averageLatency == averageLatency) &&
            (identical(other.averageTimeToReconnect, averageTimeToReconnect) ||
                other.averageTimeToReconnect == averageTimeToReconnect));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageConnectionTime,
    averageJitter,
    averageLatency,
    averageTimeToReconnect,
  );

  @override
  String toString() {
    return 'NetworkMetricsReportResponse(averageConnectionTime: $averageConnectionTime, averageJitter: $averageJitter, averageLatency: $averageLatency, averageTimeToReconnect: $averageTimeToReconnect)';
  }
}

/// @nodoc
abstract mixin class $NetworkMetricsReportResponseCopyWith<$Res> {
  factory $NetworkMetricsReportResponseCopyWith(
    NetworkMetricsReportResponse value,
    $Res Function(NetworkMetricsReportResponse) _then,
  ) = _$NetworkMetricsReportResponseCopyWithImpl;
  @useResult
  $Res call({
    double? averageConnectionTime,
    double? averageJitter,
    double? averageLatency,
    double? averageTimeToReconnect,
  });
}

/// @nodoc
class _$NetworkMetricsReportResponseCopyWithImpl<$Res>
    implements $NetworkMetricsReportResponseCopyWith<$Res> {
  _$NetworkMetricsReportResponseCopyWithImpl(this._self, this._then);

  final NetworkMetricsReportResponse _self;
  final $Res Function(NetworkMetricsReportResponse) _then;

  /// Create a copy of NetworkMetricsReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageConnectionTime = freezed,
    Object? averageJitter = freezed,
    Object? averageLatency = freezed,
    Object? averageTimeToReconnect = freezed,
  }) {
    return _then(
      NetworkMetricsReportResponse(
        averageConnectionTime: freezed == averageConnectionTime
            ? _self.averageConnectionTime
            : averageConnectionTime // ignore: cast_nullable_to_non_nullable
                  as double?,
        averageJitter: freezed == averageJitter
            ? _self.averageJitter
            : averageJitter // ignore: cast_nullable_to_non_nullable
                  as double?,
        averageLatency: freezed == averageLatency
            ? _self.averageLatency
            : averageLatency // ignore: cast_nullable_to_non_nullable
                  as double?,
        averageTimeToReconnect: freezed == averageTimeToReconnect
            ? _self.averageTimeToReconnect
            : averageTimeToReconnect // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
