// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_publisher_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSeriesPublisherStats {
  Map<String, List<List<double>>>? get global;
  Map<String, MetricDescriptor>? get globalMeta;
  List<String>? get globalMetricsOrder;
  Map<String, List<MetricThreshold>>? get globalThresholds;
  Map<String, List<ParticipantSeriesTrackMetrics>>? get tracks;

  /// Create a copy of ParticipantSeriesPublisherStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantSeriesPublisherStatsCopyWith<ParticipantSeriesPublisherStats>
  get copyWith =>
      _$ParticipantSeriesPublisherStatsCopyWithImpl<
        ParticipantSeriesPublisherStats
      >(this as ParticipantSeriesPublisherStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantSeriesPublisherStats &&
            const DeepCollectionEquality().equals(other.global, global) &&
            const DeepCollectionEquality().equals(
              other.globalMeta,
              globalMeta,
            ) &&
            const DeepCollectionEquality().equals(
              other.globalMetricsOrder,
              globalMetricsOrder,
            ) &&
            const DeepCollectionEquality().equals(
              other.globalThresholds,
              globalThresholds,
            ) &&
            const DeepCollectionEquality().equals(other.tracks, tracks));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(global),
    const DeepCollectionEquality().hash(globalMeta),
    const DeepCollectionEquality().hash(globalMetricsOrder),
    const DeepCollectionEquality().hash(globalThresholds),
    const DeepCollectionEquality().hash(tracks),
  );

  @override
  String toString() {
    return 'ParticipantSeriesPublisherStats(global: $global, globalMeta: $globalMeta, globalMetricsOrder: $globalMetricsOrder, globalThresholds: $globalThresholds, tracks: $tracks)';
  }
}

/// @nodoc
abstract mixin class $ParticipantSeriesPublisherStatsCopyWith<$Res> {
  factory $ParticipantSeriesPublisherStatsCopyWith(
    ParticipantSeriesPublisherStats value,
    $Res Function(ParticipantSeriesPublisherStats) _then,
  ) = _$ParticipantSeriesPublisherStatsCopyWithImpl;
  @useResult
  $Res call({
    Map<String, List<List<double>>>? global,
    Map<String, MetricDescriptor>? globalMeta,
    List<String>? globalMetricsOrder,
    Map<String, List<MetricThreshold>>? globalThresholds,
    Map<String, List<ParticipantSeriesTrackMetrics>>? tracks,
  });
}

/// @nodoc
class _$ParticipantSeriesPublisherStatsCopyWithImpl<$Res>
    implements $ParticipantSeriesPublisherStatsCopyWith<$Res> {
  _$ParticipantSeriesPublisherStatsCopyWithImpl(this._self, this._then);

  final ParticipantSeriesPublisherStats _self;
  final $Res Function(ParticipantSeriesPublisherStats) _then;

  /// Create a copy of ParticipantSeriesPublisherStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? global = freezed,
    Object? globalMeta = freezed,
    Object? globalMetricsOrder = freezed,
    Object? globalThresholds = freezed,
    Object? tracks = freezed,
  }) {
    return _then(
      ParticipantSeriesPublisherStats(
        global: freezed == global
            ? _self.global
            : global // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<List<double>>>?,
        globalMeta: freezed == globalMeta
            ? _self.globalMeta
            : globalMeta // ignore: cast_nullable_to_non_nullable
                  as Map<String, MetricDescriptor>?,
        globalMetricsOrder: freezed == globalMetricsOrder
            ? _self.globalMetricsOrder
            : globalMetricsOrder // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        globalThresholds: freezed == globalThresholds
            ? _self.globalThresholds
            : globalThresholds // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<MetricThreshold>>?,
        tracks: freezed == tracks
            ? _self.tracks
            : tracks // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<ParticipantSeriesTrackMetrics>>?,
      ),
    );
  }
}
