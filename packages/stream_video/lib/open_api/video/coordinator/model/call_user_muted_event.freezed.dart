// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_user_muted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallUserMutedEvent {
  String get callCid;
  DateTime get createdAt;
  String get fromUserId;
  List<String> get mutedUserIds;
  String get reason;
  String get type;

  /// Create a copy of CallUserMutedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallUserMutedEventCopyWith<CallUserMutedEvent> get copyWith =>
      _$CallUserMutedEventCopyWithImpl<CallUserMutedEvent>(
        this as CallUserMutedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallUserMutedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            const DeepCollectionEquality().equals(
              other.mutedUserIds,
              mutedUserIds,
            ) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    fromUserId,
    const DeepCollectionEquality().hash(mutedUserIds),
    reason,
    type,
  );

  @override
  String toString() {
    return 'CallUserMutedEvent(callCid: $callCid, createdAt: $createdAt, fromUserId: $fromUserId, mutedUserIds: $mutedUserIds, reason: $reason, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallUserMutedEventCopyWith<$Res> {
  factory $CallUserMutedEventCopyWith(
    CallUserMutedEvent value,
    $Res Function(CallUserMutedEvent) _then,
  ) = _$CallUserMutedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String fromUserId,
    List<String> mutedUserIds,
    String reason,
    String type,
  });
}

/// @nodoc
class _$CallUserMutedEventCopyWithImpl<$Res>
    implements $CallUserMutedEventCopyWith<$Res> {
  _$CallUserMutedEventCopyWithImpl(this._self, this._then);

  final CallUserMutedEvent _self;
  final $Res Function(CallUserMutedEvent) _then;

  /// Create a copy of CallUserMutedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? fromUserId = null,
    Object? mutedUserIds = null,
    Object? reason = null,
    Object? type = null,
  }) {
    return _then(
      CallUserMutedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fromUserId: null == fromUserId
            ? _self.fromUserId
            : fromUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        mutedUserIds: null == mutedUserIds
            ? _self.mutedUserIds
            : mutedUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        reason: null == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
