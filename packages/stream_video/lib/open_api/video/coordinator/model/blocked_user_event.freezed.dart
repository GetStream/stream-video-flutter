// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUserEvent {
  UserResponse? get blockedByUser;
  String get callCid;
  DateTime get createdAt;
  String get type;
  UserResponse get user;

  /// Create a copy of BlockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockedUserEventCopyWith<BlockedUserEvent> get copyWith =>
      _$BlockedUserEventCopyWithImpl<BlockedUserEvent>(
        this as BlockedUserEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockedUserEvent &&
            (identical(other.blockedByUser, blockedByUser) ||
                other.blockedByUser == blockedByUser) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, blockedByUser, callCid, createdAt, type, user);

  @override
  String toString() {
    return 'BlockedUserEvent(blockedByUser: $blockedByUser, callCid: $callCid, createdAt: $createdAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $BlockedUserEventCopyWith<$Res> {
  factory $BlockedUserEventCopyWith(
    BlockedUserEvent value,
    $Res Function(BlockedUserEvent) _then,
  ) = _$BlockedUserEventCopyWithImpl;
  @useResult
  $Res call({
    UserResponse? blockedByUser,
    String callCid,
    DateTime createdAt,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$BlockedUserEventCopyWithImpl<$Res>
    implements $BlockedUserEventCopyWith<$Res> {
  _$BlockedUserEventCopyWithImpl(this._self, this._then);

  final BlockedUserEvent _self;
  final $Res Function(BlockedUserEvent) _then;

  /// Create a copy of BlockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedByUser = freezed,
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      BlockedUserEvent(
        blockedByUser: freezed == blockedByUser
            ? _self.blockedByUser
            : blockedByUser // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
