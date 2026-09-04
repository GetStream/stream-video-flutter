// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewer_behavior.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewerBehavior {
  double? get bounceRatePct;
  int get connectionDurationP50S;
  double get connectionsPerViewerMean;
  double? get connectionsUnder30sPct;
  double get medianWatchMin;
  String get note;
  double get p90WatchMin;
  double? get returnVisitRatePct;

  /// Create a copy of ViewerBehavior
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ViewerBehaviorCopyWith<ViewerBehavior> get copyWith =>
      _$ViewerBehaviorCopyWithImpl<ViewerBehavior>(
        this as ViewerBehavior,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ViewerBehavior &&
            (identical(other.bounceRatePct, bounceRatePct) ||
                other.bounceRatePct == bounceRatePct) &&
            (identical(other.connectionDurationP50S, connectionDurationP50S) ||
                other.connectionDurationP50S == connectionDurationP50S) &&
            (identical(
                  other.connectionsPerViewerMean,
                  connectionsPerViewerMean,
                ) ||
                other.connectionsPerViewerMean == connectionsPerViewerMean) &&
            (identical(other.connectionsUnder30sPct, connectionsUnder30sPct) ||
                other.connectionsUnder30sPct == connectionsUnder30sPct) &&
            (identical(other.medianWatchMin, medianWatchMin) ||
                other.medianWatchMin == medianWatchMin) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.p90WatchMin, p90WatchMin) ||
                other.p90WatchMin == p90WatchMin) &&
            (identical(other.returnVisitRatePct, returnVisitRatePct) ||
                other.returnVisitRatePct == returnVisitRatePct));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bounceRatePct,
    connectionDurationP50S,
    connectionsPerViewerMean,
    connectionsUnder30sPct,
    medianWatchMin,
    note,
    p90WatchMin,
    returnVisitRatePct,
  );

  @override
  String toString() {
    return 'ViewerBehavior(bounceRatePct: $bounceRatePct, connectionDurationP50S: $connectionDurationP50S, connectionsPerViewerMean: $connectionsPerViewerMean, connectionsUnder30sPct: $connectionsUnder30sPct, medianWatchMin: $medianWatchMin, note: $note, p90WatchMin: $p90WatchMin, returnVisitRatePct: $returnVisitRatePct)';
  }
}

/// @nodoc
abstract mixin class $ViewerBehaviorCopyWith<$Res> {
  factory $ViewerBehaviorCopyWith(
    ViewerBehavior value,
    $Res Function(ViewerBehavior) _then,
  ) = _$ViewerBehaviorCopyWithImpl;
  @useResult
  $Res call({
    double? bounceRatePct,
    int connectionDurationP50S,
    double connectionsPerViewerMean,
    double? connectionsUnder30sPct,
    double medianWatchMin,
    String note,
    double p90WatchMin,
    double? returnVisitRatePct,
  });
}

/// @nodoc
class _$ViewerBehaviorCopyWithImpl<$Res>
    implements $ViewerBehaviorCopyWith<$Res> {
  _$ViewerBehaviorCopyWithImpl(this._self, this._then);

  final ViewerBehavior _self;
  final $Res Function(ViewerBehavior) _then;

  /// Create a copy of ViewerBehavior
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bounceRatePct = freezed,
    Object? connectionDurationP50S = null,
    Object? connectionsPerViewerMean = null,
    Object? connectionsUnder30sPct = freezed,
    Object? medianWatchMin = null,
    Object? note = null,
    Object? p90WatchMin = null,
    Object? returnVisitRatePct = freezed,
  }) {
    return _then(
      ViewerBehavior(
        bounceRatePct: freezed == bounceRatePct
            ? _self.bounceRatePct
            : bounceRatePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        connectionDurationP50S: null == connectionDurationP50S
            ? _self.connectionDurationP50S
            : connectionDurationP50S // ignore: cast_nullable_to_non_nullable
                  as int,
        connectionsPerViewerMean: null == connectionsPerViewerMean
            ? _self.connectionsPerViewerMean
            : connectionsPerViewerMean // ignore: cast_nullable_to_non_nullable
                  as double,
        connectionsUnder30sPct: freezed == connectionsUnder30sPct
            ? _self.connectionsUnder30sPct
            : connectionsUnder30sPct // ignore: cast_nullable_to_non_nullable
                  as double?,
        medianWatchMin: null == medianWatchMin
            ? _self.medianWatchMin
            : medianWatchMin // ignore: cast_nullable_to_non_nullable
                  as double,
        note: null == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        p90WatchMin: null == p90WatchMin
            ? _self.p90WatchMin
            : p90WatchMin // ignore: cast_nullable_to_non_nullable
                  as double,
        returnVisitRatePct: freezed == returnVisitRatePct
            ? _self.returnVisitRatePct
            : returnVisitRatePct // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
