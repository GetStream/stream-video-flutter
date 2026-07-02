// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsMapLocation {
  int get count;
  int get liveCount;
  CallStatsLocation? get location;

  /// Create a copy of CallStatsMapLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsMapLocationCopyWith<CallStatsMapLocation> get copyWith =>
      _$CallStatsMapLocationCopyWithImpl<CallStatsMapLocation>(
        this as CallStatsMapLocation,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsMapLocation &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.liveCount, liveCount) ||
                other.liveCount == liveCount) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, liveCount, location);

  @override
  String toString() {
    return 'CallStatsMapLocation(count: $count, liveCount: $liveCount, location: $location)';
  }
}

/// @nodoc
abstract mixin class $CallStatsMapLocationCopyWith<$Res> {
  factory $CallStatsMapLocationCopyWith(
    CallStatsMapLocation value,
    $Res Function(CallStatsMapLocation) _then,
  ) = _$CallStatsMapLocationCopyWithImpl;
  @useResult
  $Res call({int count, int liveCount, CallStatsLocation? location});
}

/// @nodoc
class _$CallStatsMapLocationCopyWithImpl<$Res>
    implements $CallStatsMapLocationCopyWith<$Res> {
  _$CallStatsMapLocationCopyWithImpl(this._self, this._then);

  final CallStatsMapLocation _self;
  final $Res Function(CallStatsMapLocation) _then;

  /// Create a copy of CallStatsMapLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? liveCount = null,
    Object? location = freezed,
  }) {
    return _then(
      CallStatsMapLocation(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        liveCount: null == liveCount
            ? _self.liveCount
            : liveCount // ignore: cast_nullable_to_non_nullable
                  as int,
        location: freezed == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as CallStatsLocation?,
      ),
    );
  }
}
