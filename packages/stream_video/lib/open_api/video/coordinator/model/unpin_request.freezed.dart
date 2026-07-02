// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unpin_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnpinRequest {
  String get sessionId;
  String get userId;

  /// Create a copy of UnpinRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnpinRequestCopyWith<UnpinRequest> get copyWith =>
      _$UnpinRequestCopyWithImpl<UnpinRequest>(
        this as UnpinRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnpinRequest &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userId);

  @override
  String toString() {
    return 'UnpinRequest(sessionId: $sessionId, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $UnpinRequestCopyWith<$Res> {
  factory $UnpinRequestCopyWith(
    UnpinRequest value,
    $Res Function(UnpinRequest) _then,
  ) = _$UnpinRequestCopyWithImpl;
  @useResult
  $Res call({String sessionId, String userId});
}

/// @nodoc
class _$UnpinRequestCopyWithImpl<$Res> implements $UnpinRequestCopyWith<$Res> {
  _$UnpinRequestCopyWithImpl(this._self, this._then);

  final UnpinRequest _self;
  final $Res Function(UnpinRequest) _then;

  /// Create a copy of UnpinRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionId = null, Object? userId = null}) {
    return _then(
      UnpinRequest(
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
