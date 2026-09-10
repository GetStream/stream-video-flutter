// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audience.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Audience {
  int get avgConcurrentViewers;
  List<ConcurrencyMinute> get concurrencyByMinute;
  double get hoursWatched;
  String? get peakAt;
  int get peakConcurrentViewers;
  int? get rampUpMinTo90pctPeak;
  double? get retentionAt90pctMark;
  double? get retentionAtMidpoint;
  String? get shape;
  int get uniqueViewers;
  int get viewerConnections;

  /// Create a copy of Audience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudienceCopyWith<Audience> get copyWith =>
      _$AudienceCopyWithImpl<Audience>(this as Audience, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Audience &&
            (identical(other.avgConcurrentViewers, avgConcurrentViewers) ||
                other.avgConcurrentViewers == avgConcurrentViewers) &&
            const DeepCollectionEquality().equals(
              other.concurrencyByMinute,
              concurrencyByMinute,
            ) &&
            (identical(other.hoursWatched, hoursWatched) ||
                other.hoursWatched == hoursWatched) &&
            (identical(other.peakAt, peakAt) || other.peakAt == peakAt) &&
            (identical(other.peakConcurrentViewers, peakConcurrentViewers) ||
                other.peakConcurrentViewers == peakConcurrentViewers) &&
            (identical(other.rampUpMinTo90pctPeak, rampUpMinTo90pctPeak) ||
                other.rampUpMinTo90pctPeak == rampUpMinTo90pctPeak) &&
            (identical(other.retentionAt90pctMark, retentionAt90pctMark) ||
                other.retentionAt90pctMark == retentionAt90pctMark) &&
            (identical(other.retentionAtMidpoint, retentionAtMidpoint) ||
                other.retentionAtMidpoint == retentionAtMidpoint) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            (identical(other.uniqueViewers, uniqueViewers) ||
                other.uniqueViewers == uniqueViewers) &&
            (identical(other.viewerConnections, viewerConnections) ||
                other.viewerConnections == viewerConnections));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    avgConcurrentViewers,
    const DeepCollectionEquality().hash(concurrencyByMinute),
    hoursWatched,
    peakAt,
    peakConcurrentViewers,
    rampUpMinTo90pctPeak,
    retentionAt90pctMark,
    retentionAtMidpoint,
    shape,
    uniqueViewers,
    viewerConnections,
  );

  @override
  String toString() {
    return 'Audience(avgConcurrentViewers: $avgConcurrentViewers, concurrencyByMinute: $concurrencyByMinute, hoursWatched: $hoursWatched, peakAt: $peakAt, peakConcurrentViewers: $peakConcurrentViewers, rampUpMinTo90pctPeak: $rampUpMinTo90pctPeak, retentionAt90pctMark: $retentionAt90pctMark, retentionAtMidpoint: $retentionAtMidpoint, shape: $shape, uniqueViewers: $uniqueViewers, viewerConnections: $viewerConnections)';
  }
}

/// @nodoc
abstract mixin class $AudienceCopyWith<$Res> {
  factory $AudienceCopyWith(Audience value, $Res Function(Audience) _then) =
      _$AudienceCopyWithImpl;
  @useResult
  $Res call({
    int avgConcurrentViewers,
    List<ConcurrencyMinute> concurrencyByMinute,
    double hoursWatched,
    String? peakAt,
    int peakConcurrentViewers,
    int? rampUpMinTo90pctPeak,
    double? retentionAt90pctMark,
    double? retentionAtMidpoint,
    String? shape,
    int uniqueViewers,
    int viewerConnections,
  });
}

/// @nodoc
class _$AudienceCopyWithImpl<$Res> implements $AudienceCopyWith<$Res> {
  _$AudienceCopyWithImpl(this._self, this._then);

  final Audience _self;
  final $Res Function(Audience) _then;

  /// Create a copy of Audience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgConcurrentViewers = null,
    Object? concurrencyByMinute = null,
    Object? hoursWatched = null,
    Object? peakAt = freezed,
    Object? peakConcurrentViewers = null,
    Object? rampUpMinTo90pctPeak = freezed,
    Object? retentionAt90pctMark = freezed,
    Object? retentionAtMidpoint = freezed,
    Object? shape = freezed,
    Object? uniqueViewers = null,
    Object? viewerConnections = null,
  }) {
    return _then(
      Audience(
        avgConcurrentViewers: null == avgConcurrentViewers
            ? _self.avgConcurrentViewers
            : avgConcurrentViewers // ignore: cast_nullable_to_non_nullable
                  as int,
        concurrencyByMinute: null == concurrencyByMinute
            ? _self.concurrencyByMinute
            : concurrencyByMinute // ignore: cast_nullable_to_non_nullable
                  as List<ConcurrencyMinute>,
        hoursWatched: null == hoursWatched
            ? _self.hoursWatched
            : hoursWatched // ignore: cast_nullable_to_non_nullable
                  as double,
        peakAt: freezed == peakAt
            ? _self.peakAt
            : peakAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        peakConcurrentViewers: null == peakConcurrentViewers
            ? _self.peakConcurrentViewers
            : peakConcurrentViewers // ignore: cast_nullable_to_non_nullable
                  as int,
        rampUpMinTo90pctPeak: freezed == rampUpMinTo90pctPeak
            ? _self.rampUpMinTo90pctPeak
            : rampUpMinTo90pctPeak // ignore: cast_nullable_to_non_nullable
                  as int?,
        retentionAt90pctMark: freezed == retentionAt90pctMark
            ? _self.retentionAt90pctMark
            : retentionAt90pctMark // ignore: cast_nullable_to_non_nullable
                  as double?,
        retentionAtMidpoint: freezed == retentionAtMidpoint
            ? _self.retentionAtMidpoint
            : retentionAtMidpoint // ignore: cast_nullable_to_non_nullable
                  as double?,
        shape: freezed == shape
            ? _self.shape
            : shape // ignore: cast_nullable_to_non_nullable
                  as String?,
        uniqueViewers: null == uniqueViewers
            ? _self.uniqueViewers
            : uniqueViewers // ignore: cast_nullable_to_non_nullable
                  as int,
        viewerConnections: null == viewerConnections
            ? _self.viewerConnections
            : viewerConnections // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
