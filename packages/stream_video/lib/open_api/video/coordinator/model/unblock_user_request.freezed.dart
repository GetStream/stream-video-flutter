// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unblock_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnblockUserRequest {
  String get userId;

  /// Create a copy of UnblockUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnblockUserRequestCopyWith<UnblockUserRequest> get copyWith =>
      _$UnblockUserRequestCopyWithImpl<UnblockUserRequest>(
        this as UnblockUserRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnblockUserRequest &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @override
  String toString() {
    return 'UnblockUserRequest(userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $UnblockUserRequestCopyWith<$Res> {
  factory $UnblockUserRequestCopyWith(
    UnblockUserRequest value,
    $Res Function(UnblockUserRequest) _then,
  ) = _$UnblockUserRequestCopyWithImpl;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$UnblockUserRequestCopyWithImpl<$Res>
    implements $UnblockUserRequestCopyWith<$Res> {
  _$UnblockUserRequestCopyWithImpl(this._self, this._then);

  final UnblockUserRequest _self;
  final $Res Function(UnblockUserRequest) _then;

  /// Create a copy of UnblockUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      UnblockUserRequest(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
