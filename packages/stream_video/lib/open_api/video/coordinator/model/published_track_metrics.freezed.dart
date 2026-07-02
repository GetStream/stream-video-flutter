// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'published_track_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublishedTrackMetrics {
  MetricTimeSeries? get bitrate;
  String? get codec;
  MetricTimeSeries? get framerate;
  ResolutionMetricsTimeSeries? get resolution;
  String? get trackId;
  String? get trackType;
  List<SessionWarningResponse>? get warnings;

  /// Create a copy of PublishedTrackMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PublishedTrackMetricsCopyWith<PublishedTrackMetrics> get copyWith =>
      _$PublishedTrackMetricsCopyWithImpl<PublishedTrackMetrics>(
        this as PublishedTrackMetrics,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PublishedTrackMetrics &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate) &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.framerate, framerate) ||
                other.framerate == framerate) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.trackType, trackType) ||
                other.trackType == trackType) &&
            const DeepCollectionEquality().equals(other.warnings, warnings));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bitrate,
    codec,
    framerate,
    resolution,
    trackId,
    trackType,
    const DeepCollectionEquality().hash(warnings),
  );

  @override
  String toString() {
    return 'PublishedTrackMetrics(bitrate: $bitrate, codec: $codec, framerate: $framerate, resolution: $resolution, trackId: $trackId, trackType: $trackType, warnings: $warnings)';
  }
}

/// @nodoc
abstract mixin class $PublishedTrackMetricsCopyWith<$Res> {
  factory $PublishedTrackMetricsCopyWith(
    PublishedTrackMetrics value,
    $Res Function(PublishedTrackMetrics) _then,
  ) = _$PublishedTrackMetricsCopyWithImpl;
  @useResult
  $Res call({
    MetricTimeSeries? bitrate,
    String? codec,
    MetricTimeSeries? framerate,
    ResolutionMetricsTimeSeries? resolution,
    String? trackId,
    String? trackType,
    List<SessionWarningResponse>? warnings,
  });
}

/// @nodoc
class _$PublishedTrackMetricsCopyWithImpl<$Res>
    implements $PublishedTrackMetricsCopyWith<$Res> {
  _$PublishedTrackMetricsCopyWithImpl(this._self, this._then);

  final PublishedTrackMetrics _self;
  final $Res Function(PublishedTrackMetrics) _then;

  /// Create a copy of PublishedTrackMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitrate = freezed,
    Object? codec = freezed,
    Object? framerate = freezed,
    Object? resolution = freezed,
    Object? trackId = freezed,
    Object? trackType = freezed,
    Object? warnings = freezed,
  }) {
    return _then(
      PublishedTrackMetrics(
        bitrate: freezed == bitrate
            ? _self.bitrate
            : bitrate // ignore: cast_nullable_to_non_nullable
                  as MetricTimeSeries?,
        codec: freezed == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as String?,
        framerate: freezed == framerate
            ? _self.framerate
            : framerate // ignore: cast_nullable_to_non_nullable
                  as MetricTimeSeries?,
        resolution: freezed == resolution
            ? _self.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as ResolutionMetricsTimeSeries?,
        trackId: freezed == trackId
            ? _self.trackId
            : trackId // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackType: freezed == trackType
            ? _self.trackType
            : trackType // ignore: cast_nullable_to_non_nullable
                  as String?,
        warnings: freezed == warnings
            ? _self.warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as List<SessionWarningResponse>?,
      ),
    );
  }
}
