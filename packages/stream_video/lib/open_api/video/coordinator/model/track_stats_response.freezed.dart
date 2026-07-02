// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackStatsResponse {
  int get durationSeconds;
  String get trackType;

  /// Create a copy of TrackStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackStatsResponseCopyWith<TrackStatsResponse> get copyWith =>
      _$TrackStatsResponseCopyWithImpl<TrackStatsResponse>(
        this as TrackStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackStatsResponse &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.trackType, trackType) ||
                other.trackType == trackType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, durationSeconds, trackType);

  @override
  String toString() {
    return 'TrackStatsResponse(durationSeconds: $durationSeconds, trackType: $trackType)';
  }
}

/// @nodoc
abstract mixin class $TrackStatsResponseCopyWith<$Res> {
  factory $TrackStatsResponseCopyWith(
    TrackStatsResponse value,
    $Res Function(TrackStatsResponse) _then,
  ) = _$TrackStatsResponseCopyWithImpl;
  @useResult
  $Res call({int durationSeconds, String trackType});
}

/// @nodoc
class _$TrackStatsResponseCopyWithImpl<$Res>
    implements $TrackStatsResponseCopyWith<$Res> {
  _$TrackStatsResponseCopyWithImpl(this._self, this._then);

  final TrackStatsResponse _self;
  final $Res Function(TrackStatsResponse) _then;

  /// Create a copy of TrackStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? durationSeconds = null, Object? trackType = null}) {
    return _then(
      TrackStatsResponse(
        durationSeconds: null == durationSeconds
            ? _self.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        trackType: null == trackType
            ? _self.trackType
            : trackType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
