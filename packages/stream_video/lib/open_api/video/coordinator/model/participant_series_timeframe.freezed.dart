// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_timeframe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSeriesTimeframe {
  int get maxPoints;
  DateTime get since;
  int get stepSeconds;
  DateTime get until;

  /// Create a copy of ParticipantSeriesTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantSeriesTimeframeCopyWith<ParticipantSeriesTimeframe>
  get copyWith =>
      _$ParticipantSeriesTimeframeCopyWithImpl<ParticipantSeriesTimeframe>(
        this as ParticipantSeriesTimeframe,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantSeriesTimeframe &&
            (identical(other.maxPoints, maxPoints) ||
                other.maxPoints == maxPoints) &&
            (identical(other.since, since) || other.since == since) &&
            (identical(other.stepSeconds, stepSeconds) ||
                other.stepSeconds == stepSeconds) &&
            (identical(other.until, until) || other.until == until));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, maxPoints, since, stepSeconds, until);

  @override
  String toString() {
    return 'ParticipantSeriesTimeframe(maxPoints: $maxPoints, since: $since, stepSeconds: $stepSeconds, until: $until)';
  }
}

/// @nodoc
abstract mixin class $ParticipantSeriesTimeframeCopyWith<$Res> {
  factory $ParticipantSeriesTimeframeCopyWith(
    ParticipantSeriesTimeframe value,
    $Res Function(ParticipantSeriesTimeframe) _then,
  ) = _$ParticipantSeriesTimeframeCopyWithImpl;
  @useResult
  $Res call({int maxPoints, DateTime since, int stepSeconds, DateTime until});
}

/// @nodoc
class _$ParticipantSeriesTimeframeCopyWithImpl<$Res>
    implements $ParticipantSeriesTimeframeCopyWith<$Res> {
  _$ParticipantSeriesTimeframeCopyWithImpl(this._self, this._then);

  final ParticipantSeriesTimeframe _self;
  final $Res Function(ParticipantSeriesTimeframe) _then;

  /// Create a copy of ParticipantSeriesTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxPoints = null,
    Object? since = null,
    Object? stepSeconds = null,
    Object? until = null,
  }) {
    return _then(
      ParticipantSeriesTimeframe(
        maxPoints: null == maxPoints
            ? _self.maxPoints
            : maxPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        since: null == since
            ? _self.since
            : since // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        stepSeconds: null == stepSeconds
            ? _self.stepSeconds
            : stepSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        until: null == until
            ? _self.until
            : until // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
