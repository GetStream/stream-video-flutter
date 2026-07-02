// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_error_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressErrorEvent {
  String get callCid;
  String? get code;
  DateTime get createdAt;
  String get error;
  String get ingressStreamId;
  String get type;
  String get userId;

  /// Create a copy of IngressErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressErrorEventCopyWith<IngressErrorEvent> get copyWith =>
      _$IngressErrorEventCopyWithImpl<IngressErrorEvent>(
        this as IngressErrorEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressErrorEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.ingressStreamId, ingressStreamId) ||
                other.ingressStreamId == ingressStreamId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    code,
    createdAt,
    error,
    ingressStreamId,
    type,
    userId,
  );

  @override
  String toString() {
    return 'IngressErrorEvent(callCid: $callCid, code: $code, createdAt: $createdAt, error: $error, ingressStreamId: $ingressStreamId, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $IngressErrorEventCopyWith<$Res> {
  factory $IngressErrorEventCopyWith(
    IngressErrorEvent value,
    $Res Function(IngressErrorEvent) _then,
  ) = _$IngressErrorEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    String? code,
    DateTime createdAt,
    String error,
    String ingressStreamId,
    String type,
    String userId,
  });
}

/// @nodoc
class _$IngressErrorEventCopyWithImpl<$Res>
    implements $IngressErrorEventCopyWith<$Res> {
  _$IngressErrorEventCopyWithImpl(this._self, this._then);

  final IngressErrorEvent _self;
  final $Res Function(IngressErrorEvent) _then;

  /// Create a copy of IngressErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? code = freezed,
    Object? createdAt = null,
    Object? error = null,
    Object? ingressStreamId = null,
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(
      IngressErrorEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _self.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        ingressStreamId: null == ingressStreamId
            ? _self.ingressStreamId
            : ingressStreamId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
