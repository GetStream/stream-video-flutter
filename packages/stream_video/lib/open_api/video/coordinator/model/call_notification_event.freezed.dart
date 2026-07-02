// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_notification_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallNotificationEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get sessionId;
  String get type;
  UserResponse get user;

  /// Create a copy of CallNotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallNotificationEventCopyWith<CallNotificationEvent> get copyWith =>
      _$CallNotificationEventCopyWithImpl<CallNotificationEvent>(
        this as CallNotificationEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallNotificationEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    sessionId,
    type,
    user,
  );

  @override
  String toString() {
    return 'CallNotificationEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, sessionId: $sessionId, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallNotificationEventCopyWith<$Res> {
  factory $CallNotificationEventCopyWith(
    CallNotificationEvent value,
    $Res Function(CallNotificationEvent) _then,
  ) = _$CallNotificationEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String sessionId,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallNotificationEventCopyWithImpl<$Res>
    implements $CallNotificationEventCopyWith<$Res> {
  _$CallNotificationEventCopyWithImpl(this._self, this._then);

  final CallNotificationEvent _self;
  final $Res Function(CallNotificationEvent) _then;

  /// Create a copy of CallNotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? sessionId = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallNotificationEvent(
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
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
