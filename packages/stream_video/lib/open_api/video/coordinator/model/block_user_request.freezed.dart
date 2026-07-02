// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockUserRequest {
  String get userId;

  /// Create a copy of BlockUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockUserRequestCopyWith<BlockUserRequest> get copyWith =>
      _$BlockUserRequestCopyWithImpl<BlockUserRequest>(
        this as BlockUserRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockUserRequest &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @override
  String toString() {
    return 'BlockUserRequest(userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $BlockUserRequestCopyWith<$Res> {
  factory $BlockUserRequestCopyWith(
    BlockUserRequest value,
    $Res Function(BlockUserRequest) _then,
  ) = _$BlockUserRequestCopyWithImpl;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$BlockUserRequestCopyWithImpl<$Res>
    implements $BlockUserRequestCopyWith<$Res> {
  _$BlockUserRequestCopyWithImpl(this._self, this._then);

  final BlockUserRequest _self;
  final $Res Function(BlockUserRequest) _then;

  /// Create a copy of BlockUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      BlockUserRequest(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
