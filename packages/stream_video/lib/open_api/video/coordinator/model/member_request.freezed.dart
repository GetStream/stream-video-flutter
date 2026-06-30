// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberRequest {
  Map<String, Object?>? get custom;
  String? get role;
  String get userId;

  /// Create a copy of MemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberRequestCopyWith<MemberRequest> get copyWith =>
      _$MemberRequestCopyWithImpl<MemberRequest>(
        this as MemberRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    role,
    userId,
  );

  @override
  String toString() {
    return 'MemberRequest(custom: $custom, role: $role, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $MemberRequestCopyWith<$Res> {
  factory $MemberRequestCopyWith(
    MemberRequest value,
    $Res Function(MemberRequest) _then,
  ) = _$MemberRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String? role, String userId});
}

/// @nodoc
class _$MemberRequestCopyWithImpl<$Res>
    implements $MemberRequestCopyWith<$Res> {
  _$MemberRequestCopyWithImpl(this._self, this._then);

  final MemberRequest _self;
  final $Res Function(MemberRequest) _then;

  /// Create a copy of MemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? role = freezed,
    Object? userId = null,
  }) {
    return _then(
      MemberRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        role: freezed == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
