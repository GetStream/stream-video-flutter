// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_moderation_blur_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallModerationBlurEvent {
  String get callCid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get type;
  String get userId;

  /// Create a copy of CallModerationBlurEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallModerationBlurEventCopyWith<CallModerationBlurEvent> get copyWith =>
      _$CallModerationBlurEventCopyWithImpl<CallModerationBlurEvent>(
        this as CallModerationBlurEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallModerationBlurEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    type,
    userId,
  );

  @override
  String toString() {
    return 'CallModerationBlurEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $CallModerationBlurEventCopyWith<$Res> {
  factory $CallModerationBlurEventCopyWith(
    CallModerationBlurEvent value,
    $Res Function(CallModerationBlurEvent) _then,
  ) = _$CallModerationBlurEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String type,
    String userId,
  });
}

/// @nodoc
class _$CallModerationBlurEventCopyWithImpl<$Res>
    implements $CallModerationBlurEventCopyWith<$Res> {
  _$CallModerationBlurEventCopyWithImpl(this._self, this._then);

  final CallModerationBlurEvent _self;
  final $Res Function(CallModerationBlurEvent) _then;

  /// Create a copy of CallModerationBlurEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(
      CallModerationBlurEvent(
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
