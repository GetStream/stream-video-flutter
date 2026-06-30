// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_session_ended_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallSessionEndedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get sessionId;
  String get type;

  /// Create a copy of CallSessionEndedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionEndedEventCopyWith<CallSessionEndedEvent> get copyWith =>
      _$CallSessionEndedEventCopyWithImpl<CallSessionEndedEvent>(
        this as CallSessionEndedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionEndedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, sessionId, type);

  @override
  String toString() {
    return 'CallSessionEndedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallSessionEndedEventCopyWith<$Res> {
  factory $CallSessionEndedEventCopyWith(
    CallSessionEndedEvent value,
    $Res Function(CallSessionEndedEvent) _then,
  ) = _$CallSessionEndedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String sessionId,
    String type,
  });
}

/// @nodoc
class _$CallSessionEndedEventCopyWithImpl<$Res>
    implements $CallSessionEndedEventCopyWith<$Res> {
  _$CallSessionEndedEventCopyWithImpl(this._self, this._then);

  final CallSessionEndedEvent _self;
  final $Res Function(CallSessionEndedEvent) _then;

  /// Create a copy of CallSessionEndedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? sessionId = null,
    Object? type = null,
  }) {
    return _then(
      CallSessionEndedEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
