// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'updated_call_permissions_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdatedCallPermissionsEvent {
  String get callCid;
  DateTime get createdAt;
  List<OwnCapability> get ownCapabilities;
  String get type;
  UserResponse get user;

  /// Create a copy of UpdatedCallPermissionsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatedCallPermissionsEventCopyWith<UpdatedCallPermissionsEvent>
  get copyWith =>
      _$UpdatedCallPermissionsEventCopyWithImpl<UpdatedCallPermissionsEvent>(
        this as UpdatedCallPermissionsEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatedCallPermissionsEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other.ownCapabilities,
              ownCapabilities,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(ownCapabilities),
    type,
    user,
  );

  @override
  String toString() {
    return 'UpdatedCallPermissionsEvent(callCid: $callCid, createdAt: $createdAt, ownCapabilities: $ownCapabilities, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UpdatedCallPermissionsEventCopyWith<$Res> {
  factory $UpdatedCallPermissionsEventCopyWith(
    UpdatedCallPermissionsEvent value,
    $Res Function(UpdatedCallPermissionsEvent) _then,
  ) = _$UpdatedCallPermissionsEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    List<OwnCapability> ownCapabilities,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$UpdatedCallPermissionsEventCopyWithImpl<$Res>
    implements $UpdatedCallPermissionsEventCopyWith<$Res> {
  _$UpdatedCallPermissionsEventCopyWithImpl(this._self, this._then);

  final UpdatedCallPermissionsEvent _self;
  final $Res Function(UpdatedCallPermissionsEvent) _then;

  /// Create a copy of UpdatedCallPermissionsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? ownCapabilities = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UpdatedCallPermissionsEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ownCapabilities: null == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<OwnCapability>,
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
