// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_video_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomVideoEvent {
  String get callCid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get type;
  UserResponse get user;

  /// Create a copy of CustomVideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomVideoEventCopyWith<CustomVideoEvent> get copyWith =>
      _$CustomVideoEventCopyWithImpl<CustomVideoEvent>(
        this as CustomVideoEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomVideoEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    type,
    user,
  );

  @override
  String toString() {
    return 'CustomVideoEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CustomVideoEventCopyWith<$Res> {
  factory $CustomVideoEventCopyWith(
    CustomVideoEvent value,
    $Res Function(CustomVideoEvent) _then,
  ) = _$CustomVideoEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CustomVideoEventCopyWithImpl<$Res>
    implements $CustomVideoEventCopyWith<$Res> {
  _$CustomVideoEventCopyWithImpl(this._self, this._then);

  final CustomVideoEvent _self;
  final $Res Function(CustomVideoEvent) _then;

  /// Create a copy of CustomVideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CustomVideoEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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
