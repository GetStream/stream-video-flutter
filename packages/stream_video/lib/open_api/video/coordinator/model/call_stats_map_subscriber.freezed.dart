// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_subscriber.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsMapSubscriber {
  bool get isLive;
  CallStatsLocation? get location;
  String? get name;
  String get userId;
  String get userSessionId;

  /// Create a copy of CallStatsMapSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsMapSubscriberCopyWith<CallStatsMapSubscriber> get copyWith =>
      _$CallStatsMapSubscriberCopyWithImpl<CallStatsMapSubscriber>(
        this as CallStatsMapSubscriber,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsMapSubscriber &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userSessionId, userSessionId) ||
                other.userSessionId == userSessionId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLive, location, name, userId, userSessionId);

  @override
  String toString() {
    return 'CallStatsMapSubscriber(isLive: $isLive, location: $location, name: $name, userId: $userId, userSessionId: $userSessionId)';
  }
}

/// @nodoc
abstract mixin class $CallStatsMapSubscriberCopyWith<$Res> {
  factory $CallStatsMapSubscriberCopyWith(
    CallStatsMapSubscriber value,
    $Res Function(CallStatsMapSubscriber) _then,
  ) = _$CallStatsMapSubscriberCopyWithImpl;
  @useResult
  $Res call({
    bool isLive,
    CallStatsLocation? location,
    String? name,
    String userId,
    String userSessionId,
  });
}

/// @nodoc
class _$CallStatsMapSubscriberCopyWithImpl<$Res>
    implements $CallStatsMapSubscriberCopyWith<$Res> {
  _$CallStatsMapSubscriberCopyWithImpl(this._self, this._then);

  final CallStatsMapSubscriber _self;
  final $Res Function(CallStatsMapSubscriber) _then;

  /// Create a copy of CallStatsMapSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLive = null,
    Object? location = freezed,
    Object? name = freezed,
    Object? userId = null,
    Object? userSessionId = null,
  }) {
    return _then(
      CallStatsMapSubscriber(
        isLive: null == isLive
            ? _self.isLive
            : isLive // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: freezed == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as CallStatsLocation?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userSessionId: null == userSessionId
            ? _self.userSessionId
            : userSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
