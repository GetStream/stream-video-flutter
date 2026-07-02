// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinRequest {
  String get sessionId;
  String get userId;

  /// Create a copy of PinRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PinRequestCopyWith<PinRequest> get copyWith =>
      _$PinRequestCopyWithImpl<PinRequest>(this as PinRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PinRequest &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userId);

  @override
  String toString() {
    return 'PinRequest(sessionId: $sessionId, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $PinRequestCopyWith<$Res> {
  factory $PinRequestCopyWith(
    PinRequest value,
    $Res Function(PinRequest) _then,
  ) = _$PinRequestCopyWithImpl;
  @useResult
  $Res call({String sessionId, String userId});
}

/// @nodoc
class _$PinRequestCopyWithImpl<$Res> implements $PinRequestCopyWith<$Res> {
  _$PinRequestCopyWithImpl(this._self, this._then);

  final PinRequest _self;
  final $Res Function(PinRequest) _then;

  /// Create a copy of PinRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionId = null, Object? userId = null}) {
    return _then(
      PinRequest(
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
