// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quality {
  Percentiles get connectionAvgJitterMs;
  Percentiles get connectionAvgLatencyMs;
  List<Incident> get interruptionIncidents;
  double? get p50QualityScore;
  double? get p5QualityScore;
  ScoreBands get scoreBandsByConnectionPct;
  ScoreBands get scoreBandsByWatchTimePct;
  String get viewerInterruptionNote;
  double? get viewerInterruptionRatePct;

  /// Create a copy of Quality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QualityCopyWith<Quality> get copyWith =>
      _$QualityCopyWithImpl<Quality>(this as Quality, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Quality &&
            (identical(other.connectionAvgJitterMs, connectionAvgJitterMs) ||
                other.connectionAvgJitterMs == connectionAvgJitterMs) &&
            (identical(other.connectionAvgLatencyMs, connectionAvgLatencyMs) ||
                other.connectionAvgLatencyMs == connectionAvgLatencyMs) &&
            const DeepCollectionEquality().equals(
              other.interruptionIncidents,
              interruptionIncidents,
            ) &&
            (identical(other.p50QualityScore, p50QualityScore) ||
                other.p50QualityScore == p50QualityScore) &&
            (identical(other.p5QualityScore, p5QualityScore) ||
                other.p5QualityScore == p5QualityScore) &&
            (identical(
                  other.scoreBandsByConnectionPct,
                  scoreBandsByConnectionPct,
                ) ||
                other.scoreBandsByConnectionPct == scoreBandsByConnectionPct) &&
            (identical(
                  other.scoreBandsByWatchTimePct,
                  scoreBandsByWatchTimePct,
                ) ||
                other.scoreBandsByWatchTimePct == scoreBandsByWatchTimePct) &&
            (identical(other.viewerInterruptionNote, viewerInterruptionNote) ||
                other.viewerInterruptionNote == viewerInterruptionNote) &&
            (identical(
                  other.viewerInterruptionRatePct,
                  viewerInterruptionRatePct,
                ) ||
                other.viewerInterruptionRatePct == viewerInterruptionRatePct));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    connectionAvgJitterMs,
    connectionAvgLatencyMs,
    const DeepCollectionEquality().hash(interruptionIncidents),
    p50QualityScore,
    p5QualityScore,
    scoreBandsByConnectionPct,
    scoreBandsByWatchTimePct,
    viewerInterruptionNote,
    viewerInterruptionRatePct,
  );

  @override
  String toString() {
    return 'Quality(connectionAvgJitterMs: $connectionAvgJitterMs, connectionAvgLatencyMs: $connectionAvgLatencyMs, interruptionIncidents: $interruptionIncidents, p50QualityScore: $p50QualityScore, p5QualityScore: $p5QualityScore, scoreBandsByConnectionPct: $scoreBandsByConnectionPct, scoreBandsByWatchTimePct: $scoreBandsByWatchTimePct, viewerInterruptionNote: $viewerInterruptionNote, viewerInterruptionRatePct: $viewerInterruptionRatePct)';
  }
}

/// @nodoc
abstract mixin class $QualityCopyWith<$Res> {
  factory $QualityCopyWith(Quality value, $Res Function(Quality) _then) =
      _$QualityCopyWithImpl;
  @useResult
  $Res call({
    Percentiles connectionAvgJitterMs,
    Percentiles connectionAvgLatencyMs,
    List<Incident> interruptionIncidents,
    double? p50QualityScore,
    double? p5QualityScore,
    ScoreBands scoreBandsByConnectionPct,
    ScoreBands scoreBandsByWatchTimePct,
    String viewerInterruptionNote,
    double? viewerInterruptionRatePct,
  });
}

/// @nodoc
class _$QualityCopyWithImpl<$Res> implements $QualityCopyWith<$Res> {
  _$QualityCopyWithImpl(this._self, this._then);

  final Quality _self;
  final $Res Function(Quality) _then;

  /// Create a copy of Quality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionAvgJitterMs = null,
    Object? connectionAvgLatencyMs = null,
    Object? interruptionIncidents = null,
    Object? p50QualityScore = freezed,
    Object? p5QualityScore = freezed,
    Object? scoreBandsByConnectionPct = null,
    Object? scoreBandsByWatchTimePct = null,
    Object? viewerInterruptionNote = null,
    Object? viewerInterruptionRatePct = freezed,
  }) {
    return _then(
      Quality(
        connectionAvgJitterMs: null == connectionAvgJitterMs
            ? _self.connectionAvgJitterMs
            : connectionAvgJitterMs // ignore: cast_nullable_to_non_nullable
                  as Percentiles,
        connectionAvgLatencyMs: null == connectionAvgLatencyMs
            ? _self.connectionAvgLatencyMs
            : connectionAvgLatencyMs // ignore: cast_nullable_to_non_nullable
                  as Percentiles,
        interruptionIncidents: null == interruptionIncidents
            ? _self.interruptionIncidents
            : interruptionIncidents // ignore: cast_nullable_to_non_nullable
                  as List<Incident>,
        p50QualityScore: freezed == p50QualityScore
            ? _self.p50QualityScore
            : p50QualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        p5QualityScore: freezed == p5QualityScore
            ? _self.p5QualityScore
            : p5QualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        scoreBandsByConnectionPct: null == scoreBandsByConnectionPct
            ? _self.scoreBandsByConnectionPct
            : scoreBandsByConnectionPct // ignore: cast_nullable_to_non_nullable
                  as ScoreBands,
        scoreBandsByWatchTimePct: null == scoreBandsByWatchTimePct
            ? _self.scoreBandsByWatchTimePct
            : scoreBandsByWatchTimePct // ignore: cast_nullable_to_non_nullable
                  as ScoreBands,
        viewerInterruptionNote: null == viewerInterruptionNote
            ? _self.viewerInterruptionNote
            : viewerInterruptionNote // ignore: cast_nullable_to_non_nullable
                  as String,
        viewerInterruptionRatePct: freezed == viewerInterruptionRatePct
            ? _self.viewerInterruptionRatePct
            : viewerInterruptionRatePct // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
