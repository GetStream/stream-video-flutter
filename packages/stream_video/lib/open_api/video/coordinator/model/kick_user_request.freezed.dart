// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kick_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KickUserRequest {
  bool? get block;
  String get userId;

  /// Create a copy of KickUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KickUserRequestCopyWith<KickUserRequest> get copyWith =>
      _$KickUserRequestCopyWithImpl<KickUserRequest>(
        this as KickUserRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KickUserRequest &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block, userId);

  @override
  String toString() {
    return 'KickUserRequest(block: $block, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $KickUserRequestCopyWith<$Res> {
  factory $KickUserRequestCopyWith(
    KickUserRequest value,
    $Res Function(KickUserRequest) _then,
  ) = _$KickUserRequestCopyWithImpl;
  @useResult
  $Res call({bool? block, String userId});
}

/// @nodoc
class _$KickUserRequestCopyWithImpl<$Res>
    implements $KickUserRequestCopyWith<$Res> {
  _$KickUserRequestCopyWithImpl(this._self, this._then);

  final KickUserRequest _self;
  final $Res Function(KickUserRequest) _then;

  /// Create a copy of KickUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? block = freezed, Object? userId = null}) {
    return _then(
      KickUserRequest(
        block: freezed == block
            ? _self.block
            : block // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
