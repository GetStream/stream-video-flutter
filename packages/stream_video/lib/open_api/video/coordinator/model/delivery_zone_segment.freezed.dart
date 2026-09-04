// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_zone_segment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryZoneSegment {
  double? get avgQualityScore;
  String get key;
  bool get outlier;
  double? get p5QualityScore;
  double? get poorPct;
  int get sessions;
  double? get sharePct;
  double? get watchSharePct;

  /// Create a copy of DeliveryZoneSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryZoneSegmentCopyWith<DeliveryZoneSegment> get copyWith =>
      _$DeliveryZoneSegmentCopyWithImpl<DeliveryZoneSegment>(
        this as DeliveryZoneSegment,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveryZoneSegment &&
            (identical(other.avgQualityScore, avgQualityScore) ||
                other.avgQualityScore == avgQualityScore) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.outlier, outlier) || other.outlier == outlier) &&
            (identical(other.p5QualityScore, p5QualityScore) ||
                other.p5QualityScore == p5QualityScore) &&
            (identical(other.poorPct, poorPct) || other.poorPct == poorPct) &&
            (identical(other.sessions, sessions) ||
                other.sessions == sessions) &&
            (identical(other.sharePct, sharePct) ||
                other.sharePct == sharePct) &&
            (identical(other.watchSharePct, watchSharePct) ||
                other.watchSharePct == watchSharePct));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    avgQualityScore,
    key,
    outlier,
    p5QualityScore,
    poorPct,
    sessions,
    sharePct,
    watchSharePct,
  );

  @override
  String toString() {
    return 'DeliveryZoneSegment(avgQualityScore: $avgQualityScore, key: $key, outlier: $outlier, p5QualityScore: $p5QualityScore, poorPct: $poorPct, sessions: $sessions, sharePct: $sharePct, watchSharePct: $watchSharePct)';
  }
}

/// @nodoc
abstract mixin class $DeliveryZoneSegmentCopyWith<$Res> {
  factory $DeliveryZoneSegmentCopyWith(
    DeliveryZoneSegment value,
    $Res Function(DeliveryZoneSegment) _then,
  ) = _$DeliveryZoneSegmentCopyWithImpl;
  @useResult
  $Res call({
    double? avgQualityScore,
    String key,
    bool outlier,
    double? p5QualityScore,
    double? poorPct,
    int sessions,
    double? sharePct,
    double? watchSharePct,
  });
}

/// @nodoc
class _$DeliveryZoneSegmentCopyWithImpl<$Res>
    implements $DeliveryZoneSegmentCopyWith<$Res> {
  _$DeliveryZoneSegmentCopyWithImpl(this._self, this._then);

  final DeliveryZoneSegment _self;
  final $Res Function(DeliveryZoneSegment) _then;

  /// Create a copy of DeliveryZoneSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgQualityScore = freezed,
    Object? key = null,
    Object? outlier = null,
    Object? p5QualityScore = freezed,
    Object? poorPct = freezed,
    Object? sessions = null,
    Object? sharePct = freezed,
    Object? watchSharePct = freezed,
  }) {
    return _then(
      DeliveryZoneSegment(
        avgQualityScore: freezed == avgQualityScore
            ? _self.avgQualityScore
            : avgQualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        outlier: null == outlier
            ? _self.outlier
            : outlier // ignore: cast_nullable_to_non_nullable
                  as bool,
        p5QualityScore: freezed == p5QualityScore
            ? _self.p5QualityScore
            : p5QualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        poorPct: freezed == poorPct
            ? _self.poorPct
            : poorPct // ignore: cast_nullable_to_non_nullable
                  as double?,
        sessions: null == sessions
            ? _self.sessions
            : sessions // ignore: cast_nullable_to_non_nullable
                  as int,
        sharePct: freezed == sharePct
            ? _self.sharePct
            : sharePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        watchSharePct: freezed == watchSharePct
            ? _self.watchSharePct
            : watchSharePct // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
