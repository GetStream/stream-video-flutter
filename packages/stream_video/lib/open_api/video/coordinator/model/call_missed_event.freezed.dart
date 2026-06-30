// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_missed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallMissedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  bool get notifyUser;
  String get sessionId;
  String get type;
  UserResponse get user;

  /// Create a copy of CallMissedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMissedEventCopyWith<CallMissedEvent> get copyWith =>
      _$CallMissedEventCopyWithImpl<CallMissedEvent>(
        this as CallMissedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMissedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.notifyUser, notifyUser) ||
                other.notifyUser == notifyUser) &&
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
    notifyUser,
    sessionId,
    type,
    user,
  );

  @override
  String toString() {
    return 'CallMissedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, notifyUser: $notifyUser, sessionId: $sessionId, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallMissedEventCopyWith<$Res> {
  factory $CallMissedEventCopyWith(
    CallMissedEvent value,
    $Res Function(CallMissedEvent) _then,
  ) = _$CallMissedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    bool notifyUser,
    String sessionId,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallMissedEventCopyWithImpl<$Res>
    implements $CallMissedEventCopyWith<$Res> {
  _$CallMissedEventCopyWithImpl(this._self, this._then);

  final CallMissedEvent _self;
  final $Res Function(CallMissedEvent) _then;

  /// Create a copy of CallMissedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? notifyUser = null,
    Object? sessionId = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallMissedEvent(
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
        notifyUser: null == notifyUser
            ? _self.notifyUser
            : notifyUser // ignore: cast_nullable_to_non_nullable
                  as bool,
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
