// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_request_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionRequestEvent {
  String get callCid;
  DateTime get createdAt;
  List<String> get permissions;
  String get type;
  UserResponse get user;

  /// Create a copy of PermissionRequestEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionRequestEventCopyWith<PermissionRequestEvent> get copyWith =>
      _$PermissionRequestEventCopyWithImpl<PermissionRequestEvent>(
        this as PermissionRequestEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionRequestEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other.permissions,
              permissions,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(permissions),
    type,
    user,
  );

  @override
  String toString() {
    return 'PermissionRequestEvent(callCid: $callCid, createdAt: $createdAt, permissions: $permissions, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PermissionRequestEventCopyWith<$Res> {
  factory $PermissionRequestEventCopyWith(
    PermissionRequestEvent value,
    $Res Function(PermissionRequestEvent) _then,
  ) = _$PermissionRequestEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    List<String> permissions,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$PermissionRequestEventCopyWithImpl<$Res>
    implements $PermissionRequestEventCopyWith<$Res> {
  _$PermissionRequestEventCopyWithImpl(this._self, this._then);

  final PermissionRequestEvent _self;
  final $Res Function(PermissionRequestEvent) _then;

  /// Create a copy of PermissionRequestEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? permissions = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      PermissionRequestEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        permissions: null == permissions
            ? _self.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
