// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_moderation_warning_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallModerationWarningEvent {
  String get callCid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get message;
  String get type;
  String get userId;

  /// Create a copy of CallModerationWarningEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallModerationWarningEventCopyWith<CallModerationWarningEvent>
  get copyWith =>
      _$CallModerationWarningEventCopyWithImpl<CallModerationWarningEvent>(
        this as CallModerationWarningEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallModerationWarningEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    type,
    userId,
  );

  @override
  String toString() {
    return 'CallModerationWarningEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, message: $message, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $CallModerationWarningEventCopyWith<$Res> {
  factory $CallModerationWarningEventCopyWith(
    CallModerationWarningEvent value,
    $Res Function(CallModerationWarningEvent) _then,
  ) = _$CallModerationWarningEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String message,
    String type,
    String userId,
  });
}

/// @nodoc
class _$CallModerationWarningEventCopyWithImpl<$Res>
    implements $CallModerationWarningEventCopyWith<$Res> {
  _$CallModerationWarningEventCopyWithImpl(this._self, this._then);

  final CallModerationWarningEvent _self;
  final $Res Function(CallModerationWarningEvent) _then;

  /// Create a copy of CallModerationWarningEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = null,
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(
      CallModerationWarningEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
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
