// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_permission_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestPermissionRequest {
  List<RequestPermissionRequestPermissions> get permissions;

  /// Create a copy of RequestPermissionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RequestPermissionRequestCopyWith<RequestPermissionRequest> get copyWith =>
      _$RequestPermissionRequestCopyWithImpl<RequestPermissionRequest>(
        this as RequestPermissionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RequestPermissionRequest &&
            const DeepCollectionEquality().equals(
              other.permissions,
              permissions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(permissions),
  );

  @override
  String toString() {
    return 'RequestPermissionRequest(permissions: $permissions)';
  }
}

/// @nodoc
abstract mixin class $RequestPermissionRequestCopyWith<$Res> {
  factory $RequestPermissionRequestCopyWith(
    RequestPermissionRequest value,
    $Res Function(RequestPermissionRequest) _then,
  ) = _$RequestPermissionRequestCopyWithImpl;
  @useResult
  $Res call({List<RequestPermissionRequestPermissions> permissions});
}

/// @nodoc
class _$RequestPermissionRequestCopyWithImpl<$Res>
    implements $RequestPermissionRequestCopyWith<$Res> {
  _$RequestPermissionRequestCopyWithImpl(this._self, this._then);

  final RequestPermissionRequest _self;
  final $Res Function(RequestPermissionRequest) _then;

  /// Create a copy of RequestPermissionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? permissions = null}) {
    return _then(
      RequestPermissionRequest(
        permissions: null == permissions
            ? _self.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<RequestPermissionRequestPermissions>,
      ),
    );
  }
}
