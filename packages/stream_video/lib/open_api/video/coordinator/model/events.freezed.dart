// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUpdatedEvent {
  AppEventResponse get app;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of AppUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppUpdatedEventCopyWith<AppUpdatedEvent> get copyWith =>
      _$AppUpdatedEventCopyWithImpl<AppUpdatedEvent>(
        this as AppUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppUpdatedEvent &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    app,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'AppUpdatedEvent(app: $app, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AppUpdatedEventCopyWith<$Res> {
  factory $AppUpdatedEventCopyWith(
    AppUpdatedEvent value,
    $Res Function(AppUpdatedEvent) _then,
  ) = _$AppUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    AppEventResponse app,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$AppUpdatedEventCopyWithImpl<$Res>
    implements $AppUpdatedEventCopyWith<$Res> {
  _$AppUpdatedEventCopyWithImpl(this._self, this._then);

  final AppUpdatedEvent _self;
  final $Res Function(AppUpdatedEvent) _then;

  /// Create a copy of AppUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      AppUpdatedEvent(
        app: null == app
            ? _self.app
            : app // ignore: cast_nullable_to_non_nullable
                  as AppEventResponse,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$BlockedUserEvent {
  UserResponse? get blockedByUser;
  String get callCid;
  DateTime get createdAt;
  String get type;
  UserResponse get user;

  /// Create a copy of BlockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockedUserEventCopyWith<BlockedUserEvent> get copyWith =>
      _$BlockedUserEventCopyWithImpl<BlockedUserEvent>(
        this as BlockedUserEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockedUserEvent &&
            (identical(other.blockedByUser, blockedByUser) ||
                other.blockedByUser == blockedByUser) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, blockedByUser, callCid, createdAt, type, user);

  @override
  String toString() {
    return 'BlockedUserEvent(blockedByUser: $blockedByUser, callCid: $callCid, createdAt: $createdAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $BlockedUserEventCopyWith<$Res> {
  factory $BlockedUserEventCopyWith(
    BlockedUserEvent value,
    $Res Function(BlockedUserEvent) _then,
  ) = _$BlockedUserEventCopyWithImpl;
  @useResult
  $Res call({
    UserResponse? blockedByUser,
    String callCid,
    DateTime createdAt,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$BlockedUserEventCopyWithImpl<$Res>
    implements $BlockedUserEventCopyWith<$Res> {
  _$BlockedUserEventCopyWithImpl(this._self, this._then);

  final BlockedUserEvent _self;
  final $Res Function(BlockedUserEvent) _then;

  /// Create a copy of BlockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedByUser = freezed,
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      BlockedUserEvent(
        blockedByUser: freezed == blockedByUser
            ? _self.blockedByUser
            : blockedByUser // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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

/// @nodoc
mixin _$CallAcceptedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get type;
  UserResponse get user;

  /// Create a copy of CallAcceptedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallAcceptedEventCopyWith<CallAcceptedEvent> get copyWith =>
      _$CallAcceptedEventCopyWithImpl<CallAcceptedEvent>(
        this as CallAcceptedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallAcceptedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, type, user);

  @override
  String toString() {
    return 'CallAcceptedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallAcceptedEventCopyWith<$Res> {
  factory $CallAcceptedEventCopyWith(
    CallAcceptedEvent value,
    $Res Function(CallAcceptedEvent) _then,
  ) = _$CallAcceptedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallAcceptedEventCopyWithImpl<$Res>
    implements $CallAcceptedEventCopyWith<$Res> {
  _$CallAcceptedEventCopyWithImpl(this._self, this._then);

  final CallAcceptedEvent _self;
  final $Res Function(CallAcceptedEvent) _then;

  /// Create a copy of CallAcceptedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallAcceptedEvent(
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

/// @nodoc
mixin _$CallClosedCaptionsFailedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallClosedCaptionsFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallClosedCaptionsFailedEventCopyWith<CallClosedCaptionsFailedEvent>
  get copyWith =>
      _$CallClosedCaptionsFailedEventCopyWithImpl<
        CallClosedCaptionsFailedEvent
      >(this as CallClosedCaptionsFailedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallClosedCaptionsFailedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallClosedCaptionsFailedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallClosedCaptionsFailedEventCopyWith<$Res> {
  factory $CallClosedCaptionsFailedEventCopyWith(
    CallClosedCaptionsFailedEvent value,
    $Res Function(CallClosedCaptionsFailedEvent) _then,
  ) = _$CallClosedCaptionsFailedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallClosedCaptionsFailedEventCopyWithImpl<$Res>
    implements $CallClosedCaptionsFailedEventCopyWith<$Res> {
  _$CallClosedCaptionsFailedEventCopyWithImpl(this._self, this._then);

  final CallClosedCaptionsFailedEvent _self;
  final $Res Function(CallClosedCaptionsFailedEvent) _then;

  /// Create a copy of CallClosedCaptionsFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallClosedCaptionsFailedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallClosedCaptionsStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallClosedCaptionsStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallClosedCaptionsStartedEventCopyWith<CallClosedCaptionsStartedEvent>
  get copyWith =>
      _$CallClosedCaptionsStartedEventCopyWithImpl<
        CallClosedCaptionsStartedEvent
      >(this as CallClosedCaptionsStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallClosedCaptionsStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallClosedCaptionsStartedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallClosedCaptionsStartedEventCopyWith<$Res> {
  factory $CallClosedCaptionsStartedEventCopyWith(
    CallClosedCaptionsStartedEvent value,
    $Res Function(CallClosedCaptionsStartedEvent) _then,
  ) = _$CallClosedCaptionsStartedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallClosedCaptionsStartedEventCopyWithImpl<$Res>
    implements $CallClosedCaptionsStartedEventCopyWith<$Res> {
  _$CallClosedCaptionsStartedEventCopyWithImpl(this._self, this._then);

  final CallClosedCaptionsStartedEvent _self;
  final $Res Function(CallClosedCaptionsStartedEvent) _then;

  /// Create a copy of CallClosedCaptionsStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallClosedCaptionsStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallClosedCaptionsStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallClosedCaptionsStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallClosedCaptionsStoppedEventCopyWith<CallClosedCaptionsStoppedEvent>
  get copyWith =>
      _$CallClosedCaptionsStoppedEventCopyWithImpl<
        CallClosedCaptionsStoppedEvent
      >(this as CallClosedCaptionsStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallClosedCaptionsStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallClosedCaptionsStoppedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallClosedCaptionsStoppedEventCopyWith<$Res> {
  factory $CallClosedCaptionsStoppedEventCopyWith(
    CallClosedCaptionsStoppedEvent value,
    $Res Function(CallClosedCaptionsStoppedEvent) _then,
  ) = _$CallClosedCaptionsStoppedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallClosedCaptionsStoppedEventCopyWithImpl<$Res>
    implements $CallClosedCaptionsStoppedEventCopyWith<$Res> {
  _$CallClosedCaptionsStoppedEventCopyWithImpl(this._self, this._then);

  final CallClosedCaptionsStoppedEvent _self;
  final $Res Function(CallClosedCaptionsStoppedEvent) _then;

  /// Create a copy of CallClosedCaptionsStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallClosedCaptionsStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallCreatedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get type;

  /// Create a copy of CallCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallCreatedEventCopyWith<CallCreatedEvent> get copyWith =>
      _$CallCreatedEventCopyWithImpl<CallCreatedEvent>(
        this as CallCreatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallCreatedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallCreatedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallCreatedEventCopyWith<$Res> {
  factory $CallCreatedEventCopyWith(
    CallCreatedEvent value,
    $Res Function(CallCreatedEvent) _then,
  ) = _$CallCreatedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String type,
  });
}

/// @nodoc
class _$CallCreatedEventCopyWithImpl<$Res>
    implements $CallCreatedEventCopyWith<$Res> {
  _$CallCreatedEventCopyWithImpl(this._self, this._then);

  final CallCreatedEvent _self;
  final $Res Function(CallCreatedEvent) _then;

  /// Create a copy of CallCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallCreatedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallDeletedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallDeletedEventCopyWith<CallDeletedEvent> get copyWith =>
      _$CallDeletedEventCopyWithImpl<CallDeletedEvent>(
        this as CallDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallDeletedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, call, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallDeletedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallDeletedEventCopyWith<$Res> {
  factory $CallDeletedEventCopyWith(
    CallDeletedEvent value,
    $Res Function(CallDeletedEvent) _then,
  ) = _$CallDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$CallDeletedEventCopyWithImpl<$Res>
    implements $CallDeletedEventCopyWith<$Res> {
  _$CallDeletedEventCopyWithImpl(this._self, this._then);

  final CallDeletedEvent _self;
  final $Res Function(CallDeletedEvent) _then;

  /// Create a copy of CallDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallDeletedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallDTMFEvent {
  String get callCid;
  DateTime get createdAt;
  String get digit;
  int get durationMs;
  int get seqNumber;
  DateTime get timestamp;
  String get type;
  UserResponse get user;

  /// Create a copy of CallDTMFEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallDTMFEventCopyWith<CallDTMFEvent> get copyWith =>
      _$CallDTMFEventCopyWithImpl<CallDTMFEvent>(
        this as CallDTMFEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallDTMFEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.digit, digit) || other.digit == digit) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.seqNumber, seqNumber) ||
                other.seqNumber == seqNumber) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    digit,
    durationMs,
    seqNumber,
    timestamp,
    type,
    user,
  );

  @override
  String toString() {
    return 'CallDTMFEvent(callCid: $callCid, createdAt: $createdAt, digit: $digit, durationMs: $durationMs, seqNumber: $seqNumber, timestamp: $timestamp, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallDTMFEventCopyWith<$Res> {
  factory $CallDTMFEventCopyWith(
    CallDTMFEvent value,
    $Res Function(CallDTMFEvent) _then,
  ) = _$CallDTMFEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String digit,
    int durationMs,
    int seqNumber,
    DateTime timestamp,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallDTMFEventCopyWithImpl<$Res>
    implements $CallDTMFEventCopyWith<$Res> {
  _$CallDTMFEventCopyWithImpl(this._self, this._then);

  final CallDTMFEvent _self;
  final $Res Function(CallDTMFEvent) _then;

  /// Create a copy of CallDTMFEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? digit = null,
    Object? durationMs = null,
    Object? seqNumber = null,
    Object? timestamp = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallDTMFEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        digit: null == digit
            ? _self.digit
            : digit // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMs: null == durationMs
            ? _self.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        seqNumber: null == seqNumber
            ? _self.seqNumber
            : seqNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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

/// @nodoc
mixin _$CallEndedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse>? get members;
  String? get reason;
  String get type;
  UserResponse? get user;

  /// Create a copy of CallEndedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallEndedEventCopyWith<CallEndedEvent> get copyWith =>
      _$CallEndedEventCopyWithImpl<CallEndedEvent>(
        this as CallEndedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallEndedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.reason, reason) || other.reason == reason) &&
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
    reason,
    type,
    user,
  );

  @override
  String toString() {
    return 'CallEndedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, reason: $reason, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallEndedEventCopyWith<$Res> {
  factory $CallEndedEventCopyWith(
    CallEndedEvent value,
    $Res Function(CallEndedEvent) _then,
  ) = _$CallEndedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse>? members,
    String? reason,
    String type,
    UserResponse? user,
  });
}

/// @nodoc
class _$CallEndedEventCopyWithImpl<$Res>
    implements $CallEndedEventCopyWith<$Res> {
  _$CallEndedEventCopyWithImpl(this._self, this._then);

  final CallEndedEvent _self;
  final $Res Function(CallEndedEvent) _then;

  /// Create a copy of CallEndedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = freezed,
    Object? reason = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      CallEndedEvent(
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
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}

/// @nodoc
mixin _$CallFrameRecordingFailedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallFrameRecordingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingFailedEventCopyWith<CallFrameRecordingFailedEvent>
  get copyWith =>
      _$CallFrameRecordingFailedEventCopyWithImpl<
        CallFrameRecordingFailedEvent
      >(this as CallFrameRecordingFailedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingFailedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallFrameRecordingFailedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingFailedEventCopyWith<$Res> {
  factory $CallFrameRecordingFailedEventCopyWith(
    CallFrameRecordingFailedEvent value,
    $Res Function(CallFrameRecordingFailedEvent) _then,
  ) = _$CallFrameRecordingFailedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallFrameRecordingFailedEventCopyWithImpl<$Res>
    implements $CallFrameRecordingFailedEventCopyWith<$Res> {
  _$CallFrameRecordingFailedEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingFailedEvent _self;
  final $Res Function(CallFrameRecordingFailedEvent) _then;

  /// Create a copy of CallFrameRecordingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallFrameRecordingFailedEvent(
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
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallFrameRecordingFrameReadyEvent {
  String get callCid;
  DateTime get capturedAt;
  DateTime get createdAt;
  String get egressId;
  String get sessionId;
  String get trackType;
  String get type;
  String get url;
  Map<String, UserResponse> get users;

  /// Create a copy of CallFrameRecordingFrameReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingFrameReadyEventCopyWith<CallFrameRecordingFrameReadyEvent>
  get copyWith =>
      _$CallFrameRecordingFrameReadyEventCopyWithImpl<
        CallFrameRecordingFrameReadyEvent
      >(this as CallFrameRecordingFrameReadyEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingFrameReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.trackType, trackType) ||
                other.trackType == trackType) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    capturedAt,
    createdAt,
    egressId,
    sessionId,
    trackType,
    type,
    url,
    const DeepCollectionEquality().hash(users),
  );

  @override
  String toString() {
    return 'CallFrameRecordingFrameReadyEvent(callCid: $callCid, capturedAt: $capturedAt, createdAt: $createdAt, egressId: $egressId, sessionId: $sessionId, trackType: $trackType, type: $type, url: $url, users: $users)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingFrameReadyEventCopyWith<$Res> {
  factory $CallFrameRecordingFrameReadyEventCopyWith(
    CallFrameRecordingFrameReadyEvent value,
    $Res Function(CallFrameRecordingFrameReadyEvent) _then,
  ) = _$CallFrameRecordingFrameReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime capturedAt,
    DateTime createdAt,
    String egressId,
    String sessionId,
    String trackType,
    String type,
    String url,
    Map<String, UserResponse> users,
  });
}

/// @nodoc
class _$CallFrameRecordingFrameReadyEventCopyWithImpl<$Res>
    implements $CallFrameRecordingFrameReadyEventCopyWith<$Res> {
  _$CallFrameRecordingFrameReadyEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingFrameReadyEvent _self;
  final $Res Function(CallFrameRecordingFrameReadyEvent) _then;

  /// Create a copy of CallFrameRecordingFrameReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? capturedAt = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? sessionId = null,
    Object? trackType = null,
    Object? type = null,
    Object? url = null,
    Object? users = null,
  }) {
    return _then(
      CallFrameRecordingFrameReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        capturedAt: null == capturedAt
            ? _self.capturedAt
            : capturedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        trackType: null == trackType
            ? _self.trackType
            : trackType // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _self.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as Map<String, UserResponse>,
      ),
    );
  }
}

/// @nodoc
mixin _$CallFrameRecordingStartedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallFrameRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingStartedEventCopyWith<CallFrameRecordingStartedEvent>
  get copyWith =>
      _$CallFrameRecordingStartedEventCopyWithImpl<
        CallFrameRecordingStartedEvent
      >(this as CallFrameRecordingStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingStartedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallFrameRecordingStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingStartedEventCopyWith<$Res> {
  factory $CallFrameRecordingStartedEventCopyWith(
    CallFrameRecordingStartedEvent value,
    $Res Function(CallFrameRecordingStartedEvent) _then,
  ) = _$CallFrameRecordingStartedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallFrameRecordingStartedEventCopyWithImpl<$Res>
    implements $CallFrameRecordingStartedEventCopyWith<$Res> {
  _$CallFrameRecordingStartedEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingStartedEvent _self;
  final $Res Function(CallFrameRecordingStartedEvent) _then;

  /// Create a copy of CallFrameRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallFrameRecordingStartedEvent(
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
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallFrameRecordingStoppedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallFrameRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingStoppedEventCopyWith<CallFrameRecordingStoppedEvent>
  get copyWith =>
      _$CallFrameRecordingStoppedEventCopyWithImpl<
        CallFrameRecordingStoppedEvent
      >(this as CallFrameRecordingStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingStoppedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallFrameRecordingStoppedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingStoppedEventCopyWith<$Res> {
  factory $CallFrameRecordingStoppedEventCopyWith(
    CallFrameRecordingStoppedEvent value,
    $Res Function(CallFrameRecordingStoppedEvent) _then,
  ) = _$CallFrameRecordingStoppedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallFrameRecordingStoppedEventCopyWithImpl<$Res>
    implements $CallFrameRecordingStoppedEventCopyWith<$Res> {
  _$CallFrameRecordingStoppedEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingStoppedEvent _self;
  final $Res Function(CallFrameRecordingStoppedEvent) _then;

  /// Create a copy of CallFrameRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallFrameRecordingStoppedEvent(
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
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallHLSBroadcastingFailedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallHLSBroadcastingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallHLSBroadcastingFailedEventCopyWith<CallHLSBroadcastingFailedEvent>
  get copyWith =>
      _$CallHLSBroadcastingFailedEventCopyWithImpl<
        CallHLSBroadcastingFailedEvent
      >(this as CallHLSBroadcastingFailedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallHLSBroadcastingFailedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallHLSBroadcastingFailedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallHLSBroadcastingFailedEventCopyWith<$Res> {
  factory $CallHLSBroadcastingFailedEventCopyWith(
    CallHLSBroadcastingFailedEvent value,
    $Res Function(CallHLSBroadcastingFailedEvent) _then,
  ) = _$CallHLSBroadcastingFailedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallHLSBroadcastingFailedEventCopyWithImpl<$Res>
    implements $CallHLSBroadcastingFailedEventCopyWith<$Res> {
  _$CallHLSBroadcastingFailedEventCopyWithImpl(this._self, this._then);

  final CallHLSBroadcastingFailedEvent _self;
  final $Res Function(CallHLSBroadcastingFailedEvent) _then;

  /// Create a copy of CallHLSBroadcastingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallHLSBroadcastingFailedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallHLSBroadcastingStartedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get hlsPlaylistUrl;
  String get type;

  /// Create a copy of CallHLSBroadcastingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallHLSBroadcastingStartedEventCopyWith<CallHLSBroadcastingStartedEvent>
  get copyWith =>
      _$CallHLSBroadcastingStartedEventCopyWithImpl<
        CallHLSBroadcastingStartedEvent
      >(this as CallHLSBroadcastingStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallHLSBroadcastingStartedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.hlsPlaylistUrl, hlsPlaylistUrl) ||
                other.hlsPlaylistUrl == hlsPlaylistUrl) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, hlsPlaylistUrl, type);

  @override
  String toString() {
    return 'CallHLSBroadcastingStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, hlsPlaylistUrl: $hlsPlaylistUrl, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallHLSBroadcastingStartedEventCopyWith<$Res> {
  factory $CallHLSBroadcastingStartedEventCopyWith(
    CallHLSBroadcastingStartedEvent value,
    $Res Function(CallHLSBroadcastingStartedEvent) _then,
  ) = _$CallHLSBroadcastingStartedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String hlsPlaylistUrl,
    String type,
  });
}

/// @nodoc
class _$CallHLSBroadcastingStartedEventCopyWithImpl<$Res>
    implements $CallHLSBroadcastingStartedEventCopyWith<$Res> {
  _$CallHLSBroadcastingStartedEventCopyWithImpl(this._self, this._then);

  final CallHLSBroadcastingStartedEvent _self;
  final $Res Function(CallHLSBroadcastingStartedEvent) _then;

  /// Create a copy of CallHLSBroadcastingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? hlsPlaylistUrl = null,
    Object? type = null,
  }) {
    return _then(
      CallHLSBroadcastingStartedEvent(
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
        hlsPlaylistUrl: null == hlsPlaylistUrl
            ? _self.hlsPlaylistUrl
            : hlsPlaylistUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallHLSBroadcastingStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallHLSBroadcastingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallHLSBroadcastingStoppedEventCopyWith<CallHLSBroadcastingStoppedEvent>
  get copyWith =>
      _$CallHLSBroadcastingStoppedEventCopyWithImpl<
        CallHLSBroadcastingStoppedEvent
      >(this as CallHLSBroadcastingStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallHLSBroadcastingStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallHLSBroadcastingStoppedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallHLSBroadcastingStoppedEventCopyWith<$Res> {
  factory $CallHLSBroadcastingStoppedEventCopyWith(
    CallHLSBroadcastingStoppedEvent value,
    $Res Function(CallHLSBroadcastingStoppedEvent) _then,
  ) = _$CallHLSBroadcastingStoppedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallHLSBroadcastingStoppedEventCopyWithImpl<$Res>
    implements $CallHLSBroadcastingStoppedEventCopyWith<$Res> {
  _$CallHLSBroadcastingStoppedEventCopyWithImpl(this._self, this._then);

  final CallHLSBroadcastingStoppedEvent _self;
  final $Res Function(CallHLSBroadcastingStoppedEvent) _then;

  /// Create a copy of CallHLSBroadcastingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallHLSBroadcastingStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallLiveStartedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallLiveStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallLiveStartedEventCopyWith<CallLiveStartedEvent> get copyWith =>
      _$CallLiveStartedEventCopyWithImpl<CallLiveStartedEvent>(
        this as CallLiveStartedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallLiveStartedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, call, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallLiveStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallLiveStartedEventCopyWith<$Res> {
  factory $CallLiveStartedEventCopyWith(
    CallLiveStartedEvent value,
    $Res Function(CallLiveStartedEvent) _then,
  ) = _$CallLiveStartedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$CallLiveStartedEventCopyWithImpl<$Res>
    implements $CallLiveStartedEventCopyWith<$Res> {
  _$CallLiveStartedEventCopyWithImpl(this._self, this._then);

  final CallLiveStartedEvent _self;
  final $Res Function(CallLiveStartedEvent) _then;

  /// Create a copy of CallLiveStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallLiveStartedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallMemberAddedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get type;

  /// Create a copy of CallMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMemberAddedEventCopyWith<CallMemberAddedEvent> get copyWith =>
      _$CallMemberAddedEventCopyWithImpl<CallMemberAddedEvent>(
        this as CallMemberAddedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMemberAddedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallMemberAddedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallMemberAddedEventCopyWith<$Res> {
  factory $CallMemberAddedEventCopyWith(
    CallMemberAddedEvent value,
    $Res Function(CallMemberAddedEvent) _then,
  ) = _$CallMemberAddedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String type,
  });
}

/// @nodoc
class _$CallMemberAddedEventCopyWithImpl<$Res>
    implements $CallMemberAddedEventCopyWith<$Res> {
  _$CallMemberAddedEventCopyWithImpl(this._self, this._then);

  final CallMemberAddedEvent _self;
  final $Res Function(CallMemberAddedEvent) _then;

  /// Create a copy of CallMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallMemberAddedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallMemberRemovedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<String> get members;
  String get type;

  /// Create a copy of CallMemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMemberRemovedEventCopyWith<CallMemberRemovedEvent> get copyWith =>
      _$CallMemberRemovedEventCopyWithImpl<CallMemberRemovedEvent>(
        this as CallMemberRemovedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMemberRemovedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallMemberRemovedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallMemberRemovedEventCopyWith<$Res> {
  factory $CallMemberRemovedEventCopyWith(
    CallMemberRemovedEvent value,
    $Res Function(CallMemberRemovedEvent) _then,
  ) = _$CallMemberRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<String> members,
    String type,
  });
}

/// @nodoc
class _$CallMemberRemovedEventCopyWithImpl<$Res>
    implements $CallMemberRemovedEventCopyWith<$Res> {
  _$CallMemberRemovedEventCopyWithImpl(this._self, this._then);

  final CallMemberRemovedEvent _self;
  final $Res Function(CallMemberRemovedEvent) _then;

  /// Create a copy of CallMemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallMemberRemovedEvent(
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
                  as List<String>,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallMemberUpdatedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get type;

  /// Create a copy of CallMemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMemberUpdatedEventCopyWith<CallMemberUpdatedEvent> get copyWith =>
      _$CallMemberUpdatedEventCopyWithImpl<CallMemberUpdatedEvent>(
        this as CallMemberUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMemberUpdatedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallMemberUpdatedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallMemberUpdatedEventCopyWith<$Res> {
  factory $CallMemberUpdatedEventCopyWith(
    CallMemberUpdatedEvent value,
    $Res Function(CallMemberUpdatedEvent) _then,
  ) = _$CallMemberUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String type,
  });
}

/// @nodoc
class _$CallMemberUpdatedEventCopyWithImpl<$Res>
    implements $CallMemberUpdatedEventCopyWith<$Res> {
  _$CallMemberUpdatedEventCopyWithImpl(this._self, this._then);

  final CallMemberUpdatedEvent _self;
  final $Res Function(CallMemberUpdatedEvent) _then;

  /// Create a copy of CallMemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallMemberUpdatedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallMemberUpdatedPermissionEvent {
  CallResponse get call;
  String get callCid;
  Map<String, List<String>> get capabilitiesByRole;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get type;

  /// Create a copy of CallMemberUpdatedPermissionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMemberUpdatedPermissionEventCopyWith<CallMemberUpdatedPermissionEvent>
  get copyWith =>
      _$CallMemberUpdatedPermissionEventCopyWithImpl<
        CallMemberUpdatedPermissionEvent
      >(this as CallMemberUpdatedPermissionEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMemberUpdatedPermissionEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            const DeepCollectionEquality().equals(
              other.capabilitiesByRole,
              capabilitiesByRole,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    const DeepCollectionEquality().hash(capabilitiesByRole),
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallMemberUpdatedPermissionEvent(call: $call, callCid: $callCid, capabilitiesByRole: $capabilitiesByRole, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallMemberUpdatedPermissionEventCopyWith<$Res> {
  factory $CallMemberUpdatedPermissionEventCopyWith(
    CallMemberUpdatedPermissionEvent value,
    $Res Function(CallMemberUpdatedPermissionEvent) _then,
  ) = _$CallMemberUpdatedPermissionEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    Map<String, List<String>> capabilitiesByRole,
    DateTime createdAt,
    List<MemberResponse> members,
    String type,
  });
}

/// @nodoc
class _$CallMemberUpdatedPermissionEventCopyWithImpl<$Res>
    implements $CallMemberUpdatedPermissionEventCopyWith<$Res> {
  _$CallMemberUpdatedPermissionEventCopyWithImpl(this._self, this._then);

  final CallMemberUpdatedPermissionEvent _self;
  final $Res Function(CallMemberUpdatedPermissionEvent) _then;

  /// Create a copy of CallMemberUpdatedPermissionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? capabilitiesByRole = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallMemberUpdatedPermissionEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        capabilitiesByRole: null == capabilitiesByRole
            ? _self.capabilitiesByRole
            : capabilitiesByRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

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

/// @nodoc
mixin _$CallReactionEvent {
  String get callCid;
  DateTime get createdAt;
  VideoReactionResponse get reaction;
  String get type;

  /// Create a copy of CallReactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallReactionEventCopyWith<CallReactionEvent> get copyWith =>
      _$CallReactionEventCopyWithImpl<CallReactionEvent>(
        this as CallReactionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallReactionEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, reaction, type);

  @override
  String toString() {
    return 'CallReactionEvent(callCid: $callCid, createdAt: $createdAt, reaction: $reaction, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallReactionEventCopyWith<$Res> {
  factory $CallReactionEventCopyWith(
    CallReactionEvent value,
    $Res Function(CallReactionEvent) _then,
  ) = _$CallReactionEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    VideoReactionResponse reaction,
    String type,
  });
}

/// @nodoc
class _$CallReactionEventCopyWithImpl<$Res>
    implements $CallReactionEventCopyWith<$Res> {
  _$CallReactionEventCopyWithImpl(this._self, this._then);

  final CallReactionEvent _self;
  final $Res Function(CallReactionEvent) _then;

  /// Create a copy of CallReactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? reaction = null,
    Object? type = null,
  }) {
    return _then(
      CallReactionEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reaction: null == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as VideoReactionResponse,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRecordingFailedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  RecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingFailedEventCopyWith<CallRecordingFailedEvent> get copyWith =>
      _$CallRecordingFailedEventCopyWithImpl<CallRecordingFailedEvent>(
        this as CallRecordingFailedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingFailedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    egressId,
    recordingType,
    type,
  );

  @override
  String toString() {
    return 'CallRecordingFailedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingFailedEventCopyWith<$Res> {
  factory $CallRecordingFailedEventCopyWith(
    CallRecordingFailedEvent value,
    $Res Function(CallRecordingFailedEvent) _then,
  ) = _$CallRecordingFailedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    RecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingFailedEventCopyWithImpl<$Res>
    implements $CallRecordingFailedEventCopyWith<$Res> {
  _$CallRecordingFailedEventCopyWithImpl(this._self, this._then);

  final CallRecordingFailedEvent _self;
  final $Res Function(CallRecordingFailedEvent) _then;

  /// Create a copy of CallRecordingFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? recordingType = null,
    Object? type = null,
  }) {
    return _then(
      CallRecordingFailedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        recordingType: null == recordingType
            ? _self.recordingType
            : recordingType // ignore: cast_nullable_to_non_nullable
                  as RecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRecordingReadyEvent {
  String get callCid;
  CallRecording get callRecording;
  DateTime get createdAt;
  String get egressId;
  RecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingReadyEventCopyWith<CallRecordingReadyEvent> get copyWith =>
      _$CallRecordingReadyEventCopyWithImpl<CallRecordingReadyEvent>(
        this as CallRecordingReadyEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callRecording, callRecording) ||
                other.callRecording == callRecording) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    callRecording,
    createdAt,
    egressId,
    recordingType,
    type,
  );

  @override
  String toString() {
    return 'CallRecordingReadyEvent(callCid: $callCid, callRecording: $callRecording, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingReadyEventCopyWith<$Res> {
  factory $CallRecordingReadyEventCopyWith(
    CallRecordingReadyEvent value,
    $Res Function(CallRecordingReadyEvent) _then,
  ) = _$CallRecordingReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallRecording callRecording,
    DateTime createdAt,
    String egressId,
    RecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingReadyEventCopyWithImpl<$Res>
    implements $CallRecordingReadyEventCopyWith<$Res> {
  _$CallRecordingReadyEventCopyWithImpl(this._self, this._then);

  final CallRecordingReadyEvent _self;
  final $Res Function(CallRecordingReadyEvent) _then;

  /// Create a copy of CallRecordingReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? callRecording = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? recordingType = null,
    Object? type = null,
  }) {
    return _then(
      CallRecordingReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callRecording: null == callRecording
            ? _self.callRecording
            : callRecording // ignore: cast_nullable_to_non_nullable
                  as CallRecording,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        recordingType: null == recordingType
            ? _self.recordingType
            : recordingType // ignore: cast_nullable_to_non_nullable
                  as RecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRecordingStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  RecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingStartedEventCopyWith<CallRecordingStartedEvent> get copyWith =>
      _$CallRecordingStartedEventCopyWithImpl<CallRecordingStartedEvent>(
        this as CallRecordingStartedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    egressId,
    recordingType,
    type,
  );

  @override
  String toString() {
    return 'CallRecordingStartedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingStartedEventCopyWith<$Res> {
  factory $CallRecordingStartedEventCopyWith(
    CallRecordingStartedEvent value,
    $Res Function(CallRecordingStartedEvent) _then,
  ) = _$CallRecordingStartedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    RecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingStartedEventCopyWithImpl<$Res>
    implements $CallRecordingStartedEventCopyWith<$Res> {
  _$CallRecordingStartedEventCopyWithImpl(this._self, this._then);

  final CallRecordingStartedEvent _self;
  final $Res Function(CallRecordingStartedEvent) _then;

  /// Create a copy of CallRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? recordingType = null,
    Object? type = null,
  }) {
    return _then(
      CallRecordingStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        recordingType: null == recordingType
            ? _self.recordingType
            : recordingType // ignore: cast_nullable_to_non_nullable
                  as RecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRecordingStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  RecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingStoppedEventCopyWith<CallRecordingStoppedEvent> get copyWith =>
      _$CallRecordingStoppedEventCopyWithImpl<CallRecordingStoppedEvent>(
        this as CallRecordingStoppedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    egressId,
    recordingType,
    type,
  );

  @override
  String toString() {
    return 'CallRecordingStoppedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingStoppedEventCopyWith<$Res> {
  factory $CallRecordingStoppedEventCopyWith(
    CallRecordingStoppedEvent value,
    $Res Function(CallRecordingStoppedEvent) _then,
  ) = _$CallRecordingStoppedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    RecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingStoppedEventCopyWithImpl<$Res>
    implements $CallRecordingStoppedEventCopyWith<$Res> {
  _$CallRecordingStoppedEventCopyWithImpl(this._self, this._then);

  final CallRecordingStoppedEvent _self;
  final $Res Function(CallRecordingStoppedEvent) _then;

  /// Create a copy of CallRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? recordingType = null,
    Object? type = null,
  }) {
    return _then(
      CallRecordingStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        recordingType: null == recordingType
            ? _self.recordingType
            : recordingType // ignore: cast_nullable_to_non_nullable
                  as RecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRejectedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String? get reason;
  String get type;
  UserResponse get user;

  /// Create a copy of CallRejectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRejectedEventCopyWith<CallRejectedEvent> get copyWith =>
      _$CallRejectedEventCopyWithImpl<CallRejectedEvent>(
        this as CallRejectedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRejectedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, reason, type, user);

  @override
  String toString() {
    return 'CallRejectedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, reason: $reason, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallRejectedEventCopyWith<$Res> {
  factory $CallRejectedEventCopyWith(
    CallRejectedEvent value,
    $Res Function(CallRejectedEvent) _then,
  ) = _$CallRejectedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String? reason,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallRejectedEventCopyWithImpl<$Res>
    implements $CallRejectedEventCopyWith<$Res> {
  _$CallRejectedEventCopyWithImpl(this._self, this._then);

  final CallRejectedEvent _self;
  final $Res Function(CallRejectedEvent) _then;

  /// Create a copy of CallRejectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? reason = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallRejectedEvent(
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
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// @nodoc
mixin _$CallRingEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String? get ringId;
  String get sessionId;
  String get type;
  UserResponse get user;
  bool get video;

  /// Create a copy of CallRingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRingEventCopyWith<CallRingEvent> get copyWith =>
      _$CallRingEventCopyWithImpl<CallRingEvent>(
        this as CallRingEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRingEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.ringId, ringId) || other.ringId == ringId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.video, video) || other.video == video));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    ringId,
    sessionId,
    type,
    user,
    video,
  );

  @override
  String toString() {
    return 'CallRingEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, ringId: $ringId, sessionId: $sessionId, type: $type, user: $user, video: $video)';
  }
}

/// @nodoc
abstract mixin class $CallRingEventCopyWith<$Res> {
  factory $CallRingEventCopyWith(
    CallRingEvent value,
    $Res Function(CallRingEvent) _then,
  ) = _$CallRingEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String? ringId,
    String sessionId,
    String type,
    UserResponse user,
    bool video,
  });
}

/// @nodoc
class _$CallRingEventCopyWithImpl<$Res>
    implements $CallRingEventCopyWith<$Res> {
  _$CallRingEventCopyWithImpl(this._self, this._then);

  final CallRingEvent _self;
  final $Res Function(CallRingEvent) _then;

  /// Create a copy of CallRingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? ringId = freezed,
    Object? sessionId = null,
    Object? type = null,
    Object? user = null,
    Object? video = null,
  }) {
    return _then(
      CallRingEvent(
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
        ringId: freezed == ringId
            ? _self.ringId
            : ringId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        video: null == video
            ? _self.video
            : video // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRtmpBroadcastFailedEvent {
  String get callCid;
  DateTime get createdAt;
  String get name;
  String get type;

  /// Create a copy of CallRtmpBroadcastFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRtmpBroadcastFailedEventCopyWith<CallRtmpBroadcastFailedEvent>
  get copyWith =>
      _$CallRtmpBroadcastFailedEventCopyWithImpl<CallRtmpBroadcastFailedEvent>(
        this as CallRtmpBroadcastFailedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRtmpBroadcastFailedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, name, type);

  @override
  String toString() {
    return 'CallRtmpBroadcastFailedEvent(callCid: $callCid, createdAt: $createdAt, name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRtmpBroadcastFailedEventCopyWith<$Res> {
  factory $CallRtmpBroadcastFailedEventCopyWith(
    CallRtmpBroadcastFailedEvent value,
    $Res Function(CallRtmpBroadcastFailedEvent) _then,
  ) = _$CallRtmpBroadcastFailedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String name, String type});
}

/// @nodoc
class _$CallRtmpBroadcastFailedEventCopyWithImpl<$Res>
    implements $CallRtmpBroadcastFailedEventCopyWith<$Res> {
  _$CallRtmpBroadcastFailedEventCopyWithImpl(this._self, this._then);

  final CallRtmpBroadcastFailedEvent _self;
  final $Res Function(CallRtmpBroadcastFailedEvent) _then;

  /// Create a copy of CallRtmpBroadcastFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? name = null,
    Object? type = null,
  }) {
    return _then(
      CallRtmpBroadcastFailedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRtmpBroadcastStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get name;
  String get type;

  /// Create a copy of CallRtmpBroadcastStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRtmpBroadcastStartedEventCopyWith<CallRtmpBroadcastStartedEvent>
  get copyWith =>
      _$CallRtmpBroadcastStartedEventCopyWithImpl<
        CallRtmpBroadcastStartedEvent
      >(this as CallRtmpBroadcastStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRtmpBroadcastStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, name, type);

  @override
  String toString() {
    return 'CallRtmpBroadcastStartedEvent(callCid: $callCid, createdAt: $createdAt, name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRtmpBroadcastStartedEventCopyWith<$Res> {
  factory $CallRtmpBroadcastStartedEventCopyWith(
    CallRtmpBroadcastStartedEvent value,
    $Res Function(CallRtmpBroadcastStartedEvent) _then,
  ) = _$CallRtmpBroadcastStartedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String name, String type});
}

/// @nodoc
class _$CallRtmpBroadcastStartedEventCopyWithImpl<$Res>
    implements $CallRtmpBroadcastStartedEventCopyWith<$Res> {
  _$CallRtmpBroadcastStartedEventCopyWithImpl(this._self, this._then);

  final CallRtmpBroadcastStartedEvent _self;
  final $Res Function(CallRtmpBroadcastStartedEvent) _then;

  /// Create a copy of CallRtmpBroadcastStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? name = null,
    Object? type = null,
  }) {
    return _then(
      CallRtmpBroadcastStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallRtmpBroadcastStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get name;
  String get type;

  /// Create a copy of CallRtmpBroadcastStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRtmpBroadcastStoppedEventCopyWith<CallRtmpBroadcastStoppedEvent>
  get copyWith =>
      _$CallRtmpBroadcastStoppedEventCopyWithImpl<
        CallRtmpBroadcastStoppedEvent
      >(this as CallRtmpBroadcastStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRtmpBroadcastStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, name, type);

  @override
  String toString() {
    return 'CallRtmpBroadcastStoppedEvent(callCid: $callCid, createdAt: $createdAt, name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRtmpBroadcastStoppedEventCopyWith<$Res> {
  factory $CallRtmpBroadcastStoppedEventCopyWith(
    CallRtmpBroadcastStoppedEvent value,
    $Res Function(CallRtmpBroadcastStoppedEvent) _then,
  ) = _$CallRtmpBroadcastStoppedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String name, String type});
}

/// @nodoc
class _$CallRtmpBroadcastStoppedEventCopyWithImpl<$Res>
    implements $CallRtmpBroadcastStoppedEventCopyWith<$Res> {
  _$CallRtmpBroadcastStoppedEventCopyWithImpl(this._self, this._then);

  final CallRtmpBroadcastStoppedEvent _self;
  final $Res Function(CallRtmpBroadcastStoppedEvent) _then;

  /// Create a copy of CallRtmpBroadcastStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? name = null,
    Object? type = null,
  }) {
    return _then(
      CallRtmpBroadcastStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

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

/// @nodoc
mixin _$CallSessionParticipantCountsUpdatedEvent {
  int get anonymousParticipantCount;
  String get callCid;
  DateTime get createdAt;
  Map<String, int> get participantsCountByRole;
  String get sessionId;
  String get type;

  /// Create a copy of CallSessionParticipantCountsUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionParticipantCountsUpdatedEventCopyWith<
    CallSessionParticipantCountsUpdatedEvent
  >
  get copyWith =>
      _$CallSessionParticipantCountsUpdatedEventCopyWithImpl<
        CallSessionParticipantCountsUpdatedEvent
      >(this as CallSessionParticipantCountsUpdatedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionParticipantCountsUpdatedEvent &&
            (identical(
                  other.anonymousParticipantCount,
                  anonymousParticipantCount,
                ) ||
                other.anonymousParticipantCount == anonymousParticipantCount) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other.participantsCountByRole,
              participantsCountByRole,
            ) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    anonymousParticipantCount,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(participantsCountByRole),
    sessionId,
    type,
  );

  @override
  String toString() {
    return 'CallSessionParticipantCountsUpdatedEvent(anonymousParticipantCount: $anonymousParticipantCount, callCid: $callCid, createdAt: $createdAt, participantsCountByRole: $participantsCountByRole, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallSessionParticipantCountsUpdatedEventCopyWith<$Res> {
  factory $CallSessionParticipantCountsUpdatedEventCopyWith(
    CallSessionParticipantCountsUpdatedEvent value,
    $Res Function(CallSessionParticipantCountsUpdatedEvent) _then,
  ) = _$CallSessionParticipantCountsUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    int anonymousParticipantCount,
    String callCid,
    DateTime createdAt,
    Map<String, int> participantsCountByRole,
    String sessionId,
    String type,
  });
}

/// @nodoc
class _$CallSessionParticipantCountsUpdatedEventCopyWithImpl<$Res>
    implements $CallSessionParticipantCountsUpdatedEventCopyWith<$Res> {
  _$CallSessionParticipantCountsUpdatedEventCopyWithImpl(
    this._self,
    this._then,
  );

  final CallSessionParticipantCountsUpdatedEvent _self;
  final $Res Function(CallSessionParticipantCountsUpdatedEvent) _then;

  /// Create a copy of CallSessionParticipantCountsUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anonymousParticipantCount = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? participantsCountByRole = null,
    Object? sessionId = null,
    Object? type = null,
  }) {
    return _then(
      CallSessionParticipantCountsUpdatedEvent(
        anonymousParticipantCount: null == anonymousParticipantCount
            ? _self.anonymousParticipantCount
            : anonymousParticipantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        participantsCountByRole: null == participantsCountByRole
            ? _self.participantsCountByRole
            : participantsCountByRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
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

/// @nodoc
mixin _$CallSessionParticipantJoinedEvent {
  String get callCid;
  DateTime get createdAt;
  CallParticipantResponse get participant;
  String get sessionId;
  String get type;

  /// Create a copy of CallSessionParticipantJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionParticipantJoinedEventCopyWith<CallSessionParticipantJoinedEvent>
  get copyWith =>
      _$CallSessionParticipantJoinedEventCopyWithImpl<
        CallSessionParticipantJoinedEvent
      >(this as CallSessionParticipantJoinedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionParticipantJoinedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.participant, participant) ||
                other.participant == participant) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    participant,
    sessionId,
    type,
  );

  @override
  String toString() {
    return 'CallSessionParticipantJoinedEvent(callCid: $callCid, createdAt: $createdAt, participant: $participant, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallSessionParticipantJoinedEventCopyWith<$Res> {
  factory $CallSessionParticipantJoinedEventCopyWith(
    CallSessionParticipantJoinedEvent value,
    $Res Function(CallSessionParticipantJoinedEvent) _then,
  ) = _$CallSessionParticipantJoinedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    CallParticipantResponse participant,
    String sessionId,
    String type,
  });
}

/// @nodoc
class _$CallSessionParticipantJoinedEventCopyWithImpl<$Res>
    implements $CallSessionParticipantJoinedEventCopyWith<$Res> {
  _$CallSessionParticipantJoinedEventCopyWithImpl(this._self, this._then);

  final CallSessionParticipantJoinedEvent _self;
  final $Res Function(CallSessionParticipantJoinedEvent) _then;

  /// Create a copy of CallSessionParticipantJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? participant = null,
    Object? sessionId = null,
    Object? type = null,
  }) {
    return _then(
      CallSessionParticipantJoinedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        participant: null == participant
            ? _self.participant
            : participant // ignore: cast_nullable_to_non_nullable
                  as CallParticipantResponse,
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

/// @nodoc
mixin _$CallSessionParticipantLeftEvent {
  String get callCid;
  DateTime get createdAt;
  int get durationSeconds;
  CallParticipantResponse get participant;
  String? get reason;
  String get sessionId;
  String get type;

  /// Create a copy of CallSessionParticipantLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionParticipantLeftEventCopyWith<CallSessionParticipantLeftEvent>
  get copyWith =>
      _$CallSessionParticipantLeftEventCopyWithImpl<
        CallSessionParticipantLeftEvent
      >(this as CallSessionParticipantLeftEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionParticipantLeftEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.participant, participant) ||
                other.participant == participant) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    durationSeconds,
    participant,
    reason,
    sessionId,
    type,
  );

  @override
  String toString() {
    return 'CallSessionParticipantLeftEvent(callCid: $callCid, createdAt: $createdAt, durationSeconds: $durationSeconds, participant: $participant, reason: $reason, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallSessionParticipantLeftEventCopyWith<$Res> {
  factory $CallSessionParticipantLeftEventCopyWith(
    CallSessionParticipantLeftEvent value,
    $Res Function(CallSessionParticipantLeftEvent) _then,
  ) = _$CallSessionParticipantLeftEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    int durationSeconds,
    CallParticipantResponse participant,
    String? reason,
    String sessionId,
    String type,
  });
}

/// @nodoc
class _$CallSessionParticipantLeftEventCopyWithImpl<$Res>
    implements $CallSessionParticipantLeftEventCopyWith<$Res> {
  _$CallSessionParticipantLeftEventCopyWithImpl(this._self, this._then);

  final CallSessionParticipantLeftEvent _self;
  final $Res Function(CallSessionParticipantLeftEvent) _then;

  /// Create a copy of CallSessionParticipantLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? durationSeconds = null,
    Object? participant = null,
    Object? reason = freezed,
    Object? sessionId = null,
    Object? type = null,
  }) {
    return _then(
      CallSessionParticipantLeftEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationSeconds: null == durationSeconds
            ? _self.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        participant: null == participant
            ? _self.participant
            : participant // ignore: cast_nullable_to_non_nullable
                  as CallParticipantResponse,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// @nodoc
mixin _$CallSessionStartedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get sessionId;
  String get type;

  /// Create a copy of CallSessionStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionStartedEventCopyWith<CallSessionStartedEvent> get copyWith =>
      _$CallSessionStartedEventCopyWithImpl<CallSessionStartedEvent>(
        this as CallSessionStartedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionStartedEvent &&
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
    return 'CallSessionStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallSessionStartedEventCopyWith<$Res> {
  factory $CallSessionStartedEventCopyWith(
    CallSessionStartedEvent value,
    $Res Function(CallSessionStartedEvent) _then,
  ) = _$CallSessionStartedEventCopyWithImpl;
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
class _$CallSessionStartedEventCopyWithImpl<$Res>
    implements $CallSessionStartedEventCopyWith<$Res> {
  _$CallSessionStartedEventCopyWithImpl(this._self, this._then);

  final CallSessionStartedEvent _self;
  final $Res Function(CallSessionStartedEvent) _then;

  /// Create a copy of CallSessionStartedEvent
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
      CallSessionStartedEvent(
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

/// @nodoc
mixin _$CallStatsReportReadyEvent {
  String get callCid;
  CallStatsParticipantCounts get counts;
  DateTime get createdAt;
  bool? get isTrimmed;
  List<CallStatsParticipant>? get participantsOverview;
  String get sessionId;
  String get type;

  /// Create a copy of CallStatsReportReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsReportReadyEventCopyWith<CallStatsReportReadyEvent> get copyWith =>
      _$CallStatsReportReadyEventCopyWithImpl<CallStatsReportReadyEvent>(
        this as CallStatsReportReadyEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsReportReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.counts, counts) || other.counts == counts) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isTrimmed, isTrimmed) ||
                other.isTrimmed == isTrimmed) &&
            const DeepCollectionEquality().equals(
              other.participantsOverview,
              participantsOverview,
            ) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    counts,
    createdAt,
    isTrimmed,
    const DeepCollectionEquality().hash(participantsOverview),
    sessionId,
    type,
  );

  @override
  String toString() {
    return 'CallStatsReportReadyEvent(callCid: $callCid, counts: $counts, createdAt: $createdAt, isTrimmed: $isTrimmed, participantsOverview: $participantsOverview, sessionId: $sessionId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallStatsReportReadyEventCopyWith<$Res> {
  factory $CallStatsReportReadyEventCopyWith(
    CallStatsReportReadyEvent value,
    $Res Function(CallStatsReportReadyEvent) _then,
  ) = _$CallStatsReportReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallStatsParticipantCounts counts,
    DateTime createdAt,
    bool? isTrimmed,
    List<CallStatsParticipant>? participantsOverview,
    String sessionId,
    String type,
  });
}

/// @nodoc
class _$CallStatsReportReadyEventCopyWithImpl<$Res>
    implements $CallStatsReportReadyEventCopyWith<$Res> {
  _$CallStatsReportReadyEventCopyWithImpl(this._self, this._then);

  final CallStatsReportReadyEvent _self;
  final $Res Function(CallStatsReportReadyEvent) _then;

  /// Create a copy of CallStatsReportReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? counts = null,
    Object? createdAt = null,
    Object? isTrimmed = freezed,
    Object? participantsOverview = freezed,
    Object? sessionId = null,
    Object? type = null,
  }) {
    return _then(
      CallStatsReportReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        counts: null == counts
            ? _self.counts
            : counts // ignore: cast_nullable_to_non_nullable
                  as CallStatsParticipantCounts,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isTrimmed: freezed == isTrimmed
            ? _self.isTrimmed
            : isTrimmed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        participantsOverview: freezed == participantsOverview
            ? _self.participantsOverview
            : participantsOverview // ignore: cast_nullable_to_non_nullable
                  as List<CallStatsParticipant>?,
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

/// @nodoc
mixin _$CallTranscriptionFailedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String? get error;
  String get type;

  /// Create a copy of CallTranscriptionFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionFailedEventCopyWith<CallTranscriptionFailedEvent>
  get copyWith =>
      _$CallTranscriptionFailedEventCopyWithImpl<CallTranscriptionFailedEvent>(
        this as CallTranscriptionFailedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscriptionFailedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, egressId, error, type);

  @override
  String toString() {
    return 'CallTranscriptionFailedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, error: $error, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionFailedEventCopyWith<$Res> {
  factory $CallTranscriptionFailedEventCopyWith(
    CallTranscriptionFailedEvent value,
    $Res Function(CallTranscriptionFailedEvent) _then,
  ) = _$CallTranscriptionFailedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    String? error,
    String type,
  });
}

/// @nodoc
class _$CallTranscriptionFailedEventCopyWithImpl<$Res>
    implements $CallTranscriptionFailedEventCopyWith<$Res> {
  _$CallTranscriptionFailedEventCopyWithImpl(this._self, this._then);

  final CallTranscriptionFailedEvent _self;
  final $Res Function(CallTranscriptionFailedEvent) _then;

  /// Create a copy of CallTranscriptionFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? error = freezed,
    Object? type = null,
  }) {
    return _then(
      CallTranscriptionFailedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallTranscriptionReadyEvent {
  String get callCid;
  CallTranscription get callTranscription;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallTranscriptionReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionReadyEventCopyWith<CallTranscriptionReadyEvent>
  get copyWith =>
      _$CallTranscriptionReadyEventCopyWithImpl<CallTranscriptionReadyEvent>(
        this as CallTranscriptionReadyEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscriptionReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callTranscription, callTranscription) ||
                other.callTranscription == callTranscription) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    callTranscription,
    createdAt,
    egressId,
    type,
  );

  @override
  String toString() {
    return 'CallTranscriptionReadyEvent(callCid: $callCid, callTranscription: $callTranscription, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionReadyEventCopyWith<$Res> {
  factory $CallTranscriptionReadyEventCopyWith(
    CallTranscriptionReadyEvent value,
    $Res Function(CallTranscriptionReadyEvent) _then,
  ) = _$CallTranscriptionReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallTranscription callTranscription,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallTranscriptionReadyEventCopyWithImpl<$Res>
    implements $CallTranscriptionReadyEventCopyWith<$Res> {
  _$CallTranscriptionReadyEventCopyWithImpl(this._self, this._then);

  final CallTranscriptionReadyEvent _self;
  final $Res Function(CallTranscriptionReadyEvent) _then;

  /// Create a copy of CallTranscriptionReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? callTranscription = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallTranscriptionReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callTranscription: null == callTranscription
            ? _self.callTranscription
            : callTranscription // ignore: cast_nullable_to_non_nullable
                  as CallTranscription,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallTranscriptionStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallTranscriptionStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionStartedEventCopyWith<CallTranscriptionStartedEvent>
  get copyWith =>
      _$CallTranscriptionStartedEventCopyWithImpl<
        CallTranscriptionStartedEvent
      >(this as CallTranscriptionStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscriptionStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallTranscriptionStartedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionStartedEventCopyWith<$Res> {
  factory $CallTranscriptionStartedEventCopyWith(
    CallTranscriptionStartedEvent value,
    $Res Function(CallTranscriptionStartedEvent) _then,
  ) = _$CallTranscriptionStartedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String egressId, String type});
}

/// @nodoc
class _$CallTranscriptionStartedEventCopyWithImpl<$Res>
    implements $CallTranscriptionStartedEventCopyWith<$Res> {
  _$CallTranscriptionStartedEventCopyWithImpl(this._self, this._then);

  final CallTranscriptionStartedEvent _self;
  final $Res Function(CallTranscriptionStartedEvent) _then;

  /// Create a copy of CallTranscriptionStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallTranscriptionStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallTranscriptionStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallTranscriptionStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionStoppedEventCopyWith<CallTranscriptionStoppedEvent>
  get copyWith =>
      _$CallTranscriptionStoppedEventCopyWithImpl<
        CallTranscriptionStoppedEvent
      >(this as CallTranscriptionStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscriptionStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallTranscriptionStoppedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionStoppedEventCopyWith<$Res> {
  factory $CallTranscriptionStoppedEventCopyWith(
    CallTranscriptionStoppedEvent value,
    $Res Function(CallTranscriptionStoppedEvent) _then,
  ) = _$CallTranscriptionStoppedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String egressId, String type});
}

/// @nodoc
class _$CallTranscriptionStoppedEventCopyWithImpl<$Res>
    implements $CallTranscriptionStoppedEventCopyWith<$Res> {
  _$CallTranscriptionStoppedEventCopyWithImpl(this._self, this._then);

  final CallTranscriptionStoppedEvent _self;
  final $Res Function(CallTranscriptionStoppedEvent) _then;

  /// Create a copy of CallTranscriptionStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallTranscriptionStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallUpdatedEvent {
  CallResponse get call;
  String get callCid;
  Map<String, List<String>> get capabilitiesByRole;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallUpdatedEventCopyWith<CallUpdatedEvent> get copyWith =>
      _$CallUpdatedEventCopyWithImpl<CallUpdatedEvent>(
        this as CallUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallUpdatedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            const DeepCollectionEquality().equals(
              other.capabilitiesByRole,
              capabilitiesByRole,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    const DeepCollectionEquality().hash(capabilitiesByRole),
    createdAt,
    type,
  );

  @override
  String toString() {
    return 'CallUpdatedEvent(call: $call, callCid: $callCid, capabilitiesByRole: $capabilitiesByRole, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallUpdatedEventCopyWith<$Res> {
  factory $CallUpdatedEventCopyWith(
    CallUpdatedEvent value,
    $Res Function(CallUpdatedEvent) _then,
  ) = _$CallUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    Map<String, List<String>> capabilitiesByRole,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$CallUpdatedEventCopyWithImpl<$Res>
    implements $CallUpdatedEventCopyWith<$Res> {
  _$CallUpdatedEventCopyWithImpl(this._self, this._then);

  final CallUpdatedEvent _self;
  final $Res Function(CallUpdatedEvent) _then;

  /// Create a copy of CallUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? capabilitiesByRole = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallUpdatedEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        capabilitiesByRole: null == capabilitiesByRole
            ? _self.capabilitiesByRole
            : capabilitiesByRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CallUserFeedbackSubmittedEvent {
  String get callCid;
  DateTime get createdAt;
  Map<String, Object?>? get custom;
  int get rating;
  String? get reason;
  String? get sdk;
  String? get sdkVersion;
  String get sessionId;
  String get type;
  UserResponse get user;

  /// Create a copy of CallUserFeedbackSubmittedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallUserFeedbackSubmittedEventCopyWith<CallUserFeedbackSubmittedEvent>
  get copyWith =>
      _$CallUserFeedbackSubmittedEventCopyWithImpl<
        CallUserFeedbackSubmittedEvent
      >(this as CallUserFeedbackSubmittedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallUserFeedbackSubmittedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.sdk, sdk) || other.sdk == sdk) &&
            (identical(other.sdkVersion, sdkVersion) ||
                other.sdkVersion == sdkVersion) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    rating,
    reason,
    sdk,
    sdkVersion,
    sessionId,
    type,
    user,
  );

  @override
  String toString() {
    return 'CallUserFeedbackSubmittedEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, rating: $rating, reason: $reason, sdk: $sdk, sdkVersion: $sdkVersion, sessionId: $sessionId, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CallUserFeedbackSubmittedEventCopyWith<$Res> {
  factory $CallUserFeedbackSubmittedEventCopyWith(
    CallUserFeedbackSubmittedEvent value,
    $Res Function(CallUserFeedbackSubmittedEvent) _then,
  ) = _$CallUserFeedbackSubmittedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    Map<String, Object?>? custom,
    int rating,
    String? reason,
    String? sdk,
    String? sdkVersion,
    String sessionId,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CallUserFeedbackSubmittedEventCopyWithImpl<$Res>
    implements $CallUserFeedbackSubmittedEventCopyWith<$Res> {
  _$CallUserFeedbackSubmittedEventCopyWithImpl(this._self, this._then);

  final CallUserFeedbackSubmittedEvent _self;
  final $Res Function(CallUserFeedbackSubmittedEvent) _then;

  /// Create a copy of CallUserFeedbackSubmittedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? custom = freezed,
    Object? rating = null,
    Object? reason = freezed,
    Object? sdk = freezed,
    Object? sdkVersion = freezed,
    Object? sessionId = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CallUserFeedbackSubmittedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        rating: null == rating
            ? _self.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        sdk: freezed == sdk
            ? _self.sdk
            : sdk // ignore: cast_nullable_to_non_nullable
                  as String?,
        sdkVersion: freezed == sdkVersion
            ? _self.sdkVersion
            : sdkVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// @nodoc
mixin _$ClosedCaptionEvent {
  String get callCid;
  CallClosedCaption get closedCaption;
  DateTime get createdAt;
  String get type;

  /// Create a copy of ClosedCaptionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClosedCaptionEventCopyWith<ClosedCaptionEvent> get copyWith =>
      _$ClosedCaptionEventCopyWithImpl<ClosedCaptionEvent>(
        this as ClosedCaptionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClosedCaptionEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.closedCaption, closedCaption) ||
                other.closedCaption == closedCaption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, closedCaption, createdAt, type);

  @override
  String toString() {
    return 'ClosedCaptionEvent(callCid: $callCid, closedCaption: $closedCaption, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ClosedCaptionEventCopyWith<$Res> {
  factory $ClosedCaptionEventCopyWith(
    ClosedCaptionEvent value,
    $Res Function(ClosedCaptionEvent) _then,
  ) = _$ClosedCaptionEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallClosedCaption closedCaption,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$ClosedCaptionEventCopyWithImpl<$Res>
    implements $ClosedCaptionEventCopyWith<$Res> {
  _$ClosedCaptionEventCopyWithImpl(this._self, this._then);

  final ClosedCaptionEvent _self;
  final $Res Function(ClosedCaptionEvent) _then;

  /// Create a copy of ClosedCaptionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? closedCaption = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      ClosedCaptionEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        closedCaption: null == closedCaption
            ? _self.closedCaption
            : closedCaption // ignore: cast_nullable_to_non_nullable
                  as CallClosedCaption,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CustomVideoEvent {
  String get callCid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get type;
  UserResponse get user;

  /// Create a copy of CustomVideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomVideoEventCopyWith<CustomVideoEvent> get copyWith =>
      _$CustomVideoEventCopyWithImpl<CustomVideoEvent>(
        this as CustomVideoEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomVideoEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    type,
    user,
  );

  @override
  String toString() {
    return 'CustomVideoEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CustomVideoEventCopyWith<$Res> {
  factory $CustomVideoEventCopyWith(
    CustomVideoEvent value,
    $Res Function(CustomVideoEvent) _then,
  ) = _$CustomVideoEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$CustomVideoEventCopyWithImpl<$Res>
    implements $CustomVideoEventCopyWith<$Res> {
  _$CustomVideoEventCopyWithImpl(this._self, this._then);

  final CustomVideoEvent _self;
  final $Res Function(CustomVideoEvent) _then;

  /// Create a copy of CustomVideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      CustomVideoEvent(
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
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}

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

/// @nodoc
mixin _$IngressStartedEvent {
  String get callCid;
  String? get clientIp;
  String? get clientName;
  DateTime get createdAt;
  String get ingressStreamId;
  String get publisherType;
  String get type;
  String get userId;
  String? get version;

  /// Create a copy of IngressStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressStartedEventCopyWith<IngressStartedEvent> get copyWith =>
      _$IngressStartedEventCopyWithImpl<IngressStartedEvent>(
        this as IngressStartedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.clientIp, clientIp) ||
                other.clientIp == clientIp) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.ingressStreamId, ingressStreamId) ||
                other.ingressStreamId == ingressStreamId) &&
            (identical(other.publisherType, publisherType) ||
                other.publisherType == publisherType) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    clientIp,
    clientName,
    createdAt,
    ingressStreamId,
    publisherType,
    type,
    userId,
    version,
  );

  @override
  String toString() {
    return 'IngressStartedEvent(callCid: $callCid, clientIp: $clientIp, clientName: $clientName, createdAt: $createdAt, ingressStreamId: $ingressStreamId, publisherType: $publisherType, type: $type, userId: $userId, version: $version)';
  }
}

/// @nodoc
abstract mixin class $IngressStartedEventCopyWith<$Res> {
  factory $IngressStartedEventCopyWith(
    IngressStartedEvent value,
    $Res Function(IngressStartedEvent) _then,
  ) = _$IngressStartedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    String? clientIp,
    String? clientName,
    DateTime createdAt,
    String ingressStreamId,
    String publisherType,
    String type,
    String userId,
    String? version,
  });
}

/// @nodoc
class _$IngressStartedEventCopyWithImpl<$Res>
    implements $IngressStartedEventCopyWith<$Res> {
  _$IngressStartedEventCopyWithImpl(this._self, this._then);

  final IngressStartedEvent _self;
  final $Res Function(IngressStartedEvent) _then;

  /// Create a copy of IngressStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? clientIp = freezed,
    Object? clientName = freezed,
    Object? createdAt = null,
    Object? ingressStreamId = null,
    Object? publisherType = null,
    Object? type = null,
    Object? userId = null,
    Object? version = freezed,
  }) {
    return _then(
      IngressStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        clientIp: freezed == clientIp
            ? _self.clientIp
            : clientIp // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientName: freezed == clientName
            ? _self.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ingressStreamId: null == ingressStreamId
            ? _self.ingressStreamId
            : ingressStreamId // ignore: cast_nullable_to_non_nullable
                  as String,
        publisherType: null == publisherType
            ? _self.publisherType
            : publisherType // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        version: freezed == version
            ? _self.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
mixin _$IngressStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get ingressStreamId;
  String get type;
  String get userId;

  /// Create a copy of IngressStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressStoppedEventCopyWith<IngressStoppedEvent> get copyWith =>
      _$IngressStoppedEventCopyWithImpl<IngressStoppedEvent>(
        this as IngressStoppedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.ingressStreamId, ingressStreamId) ||
                other.ingressStreamId == ingressStreamId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    ingressStreamId,
    type,
    userId,
  );

  @override
  String toString() {
    return 'IngressStoppedEvent(callCid: $callCid, createdAt: $createdAt, ingressStreamId: $ingressStreamId, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $IngressStoppedEventCopyWith<$Res> {
  factory $IngressStoppedEventCopyWith(
    IngressStoppedEvent value,
    $Res Function(IngressStoppedEvent) _then,
  ) = _$IngressStoppedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String ingressStreamId,
    String type,
    String userId,
  });
}

/// @nodoc
class _$IngressStoppedEventCopyWithImpl<$Res>
    implements $IngressStoppedEventCopyWith<$Res> {
  _$IngressStoppedEventCopyWithImpl(this._self, this._then);

  final IngressStoppedEvent _self;
  final $Res Function(IngressStoppedEvent) _then;

  /// Create a copy of IngressStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? ingressStreamId = null,
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(
      IngressStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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

/// @nodoc
mixin _$KickedUserEvent {
  String get callCid;
  DateTime get createdAt;
  UserResponse? get kickedByUser;
  String get type;
  UserResponse get user;

  /// Create a copy of KickedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KickedUserEventCopyWith<KickedUserEvent> get copyWith =>
      _$KickedUserEventCopyWithImpl<KickedUserEvent>(
        this as KickedUserEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KickedUserEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.kickedByUser, kickedByUser) ||
                other.kickedByUser == kickedByUser) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, kickedByUser, type, user);

  @override
  String toString() {
    return 'KickedUserEvent(callCid: $callCid, createdAt: $createdAt, kickedByUser: $kickedByUser, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $KickedUserEventCopyWith<$Res> {
  factory $KickedUserEventCopyWith(
    KickedUserEvent value,
    $Res Function(KickedUserEvent) _then,
  ) = _$KickedUserEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    UserResponse? kickedByUser,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$KickedUserEventCopyWithImpl<$Res>
    implements $KickedUserEventCopyWith<$Res> {
  _$KickedUserEventCopyWithImpl(this._self, this._then);

  final KickedUserEvent _self;
  final $Res Function(KickedUserEvent) _then;

  /// Create a copy of KickedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? kickedByUser = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      KickedUserEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        kickedByUser: freezed == kickedByUser
            ? _self.kickedByUser
            : kickedByUser // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
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

/// @nodoc
mixin _$ModerationCustomActionEvent {
  String get actionId;
  Map<String, Object?>? get actionOptions;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  DateTime? get receivedAt;
  ReviewQueueItemResponse get reviewQueueItem;
  String get type;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationCustomActionEventCopyWith<ModerationCustomActionEvent>
  get copyWith =>
      _$ModerationCustomActionEventCopyWithImpl<ModerationCustomActionEvent>(
        this as ModerationCustomActionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationCustomActionEvent &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            const DeepCollectionEquality().equals(
              other.actionOptions,
              actionOptions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItem, reviewQueueItem) ||
                other.reviewQueueItem == reviewQueueItem) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    actionId,
    const DeepCollectionEquality().hash(actionOptions),
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    receivedAt,
    reviewQueueItem,
    type,
  );

  @override
  String toString() {
    return 'ModerationCustomActionEvent(actionId: $actionId, actionOptions: $actionOptions, createdAt: $createdAt, custom: $custom, message: $message, receivedAt: $receivedAt, reviewQueueItem: $reviewQueueItem, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationCustomActionEventCopyWith<$Res> {
  factory $ModerationCustomActionEventCopyWith(
    ModerationCustomActionEvent value,
    $Res Function(ModerationCustomActionEvent) _then,
  ) = _$ModerationCustomActionEventCopyWithImpl;
  @useResult
  $Res call({
    String actionId,
    Map<String, Object?>? actionOptions,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    DateTime? receivedAt,
    ReviewQueueItemResponse reviewQueueItem,
    String type,
  });
}

/// @nodoc
class _$ModerationCustomActionEventCopyWithImpl<$Res>
    implements $ModerationCustomActionEventCopyWith<$Res> {
  _$ModerationCustomActionEventCopyWithImpl(this._self, this._then);

  final ModerationCustomActionEvent _self;
  final $Res Function(ModerationCustomActionEvent) _then;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionId = null,
    Object? actionOptions = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItem = null,
    Object? type = null,
  }) {
    return _then(
      ModerationCustomActionEvent(
        actionId: null == actionId
            ? _self.actionId
            : actionId // ignore: cast_nullable_to_non_nullable
                  as String,
        actionOptions: freezed == actionOptions
            ? _self.actionOptions
            : actionOptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItem: null == reviewQueueItem
            ? _self.reviewQueueItem
            : reviewQueueItem // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ModerationFlaggedEvent {
  String get contentType;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get objectId;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ModerationFlaggedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationFlaggedEventCopyWith<ModerationFlaggedEvent> get copyWith =>
      _$ModerationFlaggedEventCopyWithImpl<ModerationFlaggedEvent>(
        this as ModerationFlaggedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationFlaggedEvent &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    contentType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    objectId,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ModerationFlaggedEvent(contentType: $contentType, createdAt: $createdAt, custom: $custom, objectId: $objectId, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationFlaggedEventCopyWith<$Res> {
  factory $ModerationFlaggedEventCopyWith(
    ModerationFlaggedEvent value,
    $Res Function(ModerationFlaggedEvent) _then,
  ) = _$ModerationFlaggedEventCopyWithImpl;
  @useResult
  $Res call({
    String contentType,
    DateTime createdAt,
    Map<String, Object?> custom,
    String objectId,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ModerationFlaggedEventCopyWithImpl<$Res>
    implements $ModerationFlaggedEventCopyWith<$Res> {
  _$ModerationFlaggedEventCopyWithImpl(this._self, this._then);

  final ModerationFlaggedEvent _self;
  final $Res Function(ModerationFlaggedEvent) _then;

  /// Create a copy of ModerationFlaggedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? objectId = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ModerationFlaggedEvent(
        contentType: null == contentType
            ? _self.contentType
            : contentType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        objectId: null == objectId
            ? _self.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ModerationMarkReviewedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ReviewQueueItemResponse get item;
  MessageResponse? get message;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationMarkReviewedEventCopyWith<ModerationMarkReviewedEvent>
  get copyWith =>
      _$ModerationMarkReviewedEventCopyWithImpl<ModerationMarkReviewedEvent>(
        this as ModerationMarkReviewedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationMarkReviewedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    item,
    message,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ModerationMarkReviewedEvent(createdAt: $createdAt, custom: $custom, item: $item, message: $message, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationMarkReviewedEventCopyWith<$Res> {
  factory $ModerationMarkReviewedEventCopyWith(
    ModerationMarkReviewedEvent value,
    $Res Function(ModerationMarkReviewedEvent) _then,
  ) = _$ModerationMarkReviewedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    ReviewQueueItemResponse item,
    MessageResponse? message,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ModerationMarkReviewedEventCopyWithImpl<$Res>
    implements $ModerationMarkReviewedEventCopyWith<$Res> {
  _$ModerationMarkReviewedEventCopyWithImpl(this._self, this._then);

  final ModerationMarkReviewedEvent _self;
  final $Res Function(ModerationMarkReviewedEvent) _then;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? item = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ModerationMarkReviewedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        item: null == item
            ? _self.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PermissionRequestEvent {
  String get callCid;
  DateTime get createdAt;
  List<String> get permissions;
  String get type;
  UserResponse get user;

  /// Create a copy of PermissionRequestEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionRequestEventCopyWith<PermissionRequestEvent> get copyWith =>
      _$PermissionRequestEventCopyWithImpl<PermissionRequestEvent>(
        this as PermissionRequestEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionRequestEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other.permissions,
              permissions,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(permissions),
    type,
    user,
  );

  @override
  String toString() {
    return 'PermissionRequestEvent(callCid: $callCid, createdAt: $createdAt, permissions: $permissions, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PermissionRequestEventCopyWith<$Res> {
  factory $PermissionRequestEventCopyWith(
    PermissionRequestEvent value,
    $Res Function(PermissionRequestEvent) _then,
  ) = _$PermissionRequestEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    List<String> permissions,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$PermissionRequestEventCopyWithImpl<$Res>
    implements $PermissionRequestEventCopyWith<$Res> {
  _$PermissionRequestEventCopyWithImpl(this._self, this._then);

  final PermissionRequestEvent _self;
  final $Res Function(PermissionRequestEvent) _then;

  /// Create a copy of PermissionRequestEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? permissions = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      PermissionRequestEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        permissions: null == permissions
            ? _self.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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

/// @nodoc
mixin _$UnblockedUserEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;
  UserResponse get user;

  /// Create a copy of UnblockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnblockedUserEventCopyWith<UnblockedUserEvent> get copyWith =>
      _$UnblockedUserEventCopyWithImpl<UnblockedUserEvent>(
        this as UnblockedUserEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnblockedUserEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type, user);

  @override
  String toString() {
    return 'UnblockedUserEvent(callCid: $callCid, createdAt: $createdAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UnblockedUserEventCopyWith<$Res> {
  factory $UnblockedUserEventCopyWith(
    UnblockedUserEvent value,
    $Res Function(UnblockedUserEvent) _then,
  ) = _$UnblockedUserEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$UnblockedUserEventCopyWithImpl<$Res>
    implements $UnblockedUserEventCopyWith<$Res> {
  _$UnblockedUserEventCopyWithImpl(this._self, this._then);

  final UnblockedUserEvent _self;
  final $Res Function(UnblockedUserEvent) _then;

  /// Create a copy of UnblockedUserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UnblockedUserEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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

/// @nodoc
mixin _$UpdatedCallPermissionsEvent {
  String get callCid;
  DateTime get createdAt;
  List<OwnCapability> get ownCapabilities;
  String get type;
  UserResponse get user;

  /// Create a copy of UpdatedCallPermissionsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatedCallPermissionsEventCopyWith<UpdatedCallPermissionsEvent>
  get copyWith =>
      _$UpdatedCallPermissionsEventCopyWithImpl<UpdatedCallPermissionsEvent>(
        this as UpdatedCallPermissionsEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatedCallPermissionsEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other.ownCapabilities,
              ownCapabilities,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(ownCapabilities),
    type,
    user,
  );

  @override
  String toString() {
    return 'UpdatedCallPermissionsEvent(callCid: $callCid, createdAt: $createdAt, ownCapabilities: $ownCapabilities, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UpdatedCallPermissionsEventCopyWith<$Res> {
  factory $UpdatedCallPermissionsEventCopyWith(
    UpdatedCallPermissionsEvent value,
    $Res Function(UpdatedCallPermissionsEvent) _then,
  ) = _$UpdatedCallPermissionsEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    List<OwnCapability> ownCapabilities,
    String type,
    UserResponse user,
  });
}

/// @nodoc
class _$UpdatedCallPermissionsEventCopyWithImpl<$Res>
    implements $UpdatedCallPermissionsEventCopyWith<$Res> {
  _$UpdatedCallPermissionsEventCopyWithImpl(this._self, this._then);

  final UpdatedCallPermissionsEvent _self;
  final $Res Function(UpdatedCallPermissionsEvent) _then;

  /// Create a copy of UpdatedCallPermissionsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? ownCapabilities = null,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UpdatedCallPermissionsEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ownCapabilities: null == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<OwnCapability>,
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

/// @nodoc
mixin _$UserBannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get expiration;
  String? get reason;
  DateTime? get receivedAt;
  String? get reviewQueueItemId;
  bool? get shadow;
  String? get team;
  int? get totalBans;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBannedEventCopyWith<UserBannedEvent> get copyWith =>
      _$UserBannedEventCopyWithImpl<UserBannedEvent>(
        this as UserBannedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBannedEvent &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) ||
                other.reviewQueueItemId == reviewQueueItemId) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalBans, totalBans) ||
                other.totalBans == totalBans) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    expiration,
    reason,
    receivedAt,
    reviewQueueItemId,
    shadow,
    team,
    totalBans,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserBannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, expiration: $expiration, reason: $reason, receivedAt: $receivedAt, reviewQueueItemId: $reviewQueueItemId, shadow: $shadow, team: $team, totalBans: $totalBans, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserBannedEventCopyWith<$Res> {
  factory $UserBannedEventCopyWith(
    UserBannedEvent value,
    $Res Function(UserBannedEvent) _then,
  ) = _$UserBannedEventCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? expiration,
    String? reason,
    DateTime? receivedAt,
    String? reviewQueueItemId,
    bool? shadow,
    String? team,
    int? totalBans,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserBannedEventCopyWithImpl<$Res>
    implements $UserBannedEventCopyWith<$Res> {
  _$UserBannedEventCopyWithImpl(this._self, this._then);

  final UserBannedEvent _self;
  final $Res Function(UserBannedEvent) _then;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? expiration = freezed,
    Object? reason = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItemId = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? totalBans = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserBannedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        expiration: freezed == expiration
            ? _self.expiration
            : expiration // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalBans: freezed == totalBans
            ? _self.totalBans
            : totalBans // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserDeactivatedEvent {
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserDeactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDeactivatedEventCopyWith<UserDeactivatedEvent> get copyWith =>
      _$UserDeactivatedEventCopyWithImpl<UserDeactivatedEvent>(
        this as UserDeactivatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDeactivatedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserDeactivatedEvent(createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserDeactivatedEventCopyWith<$Res> {
  factory $UserDeactivatedEventCopyWith(
    UserDeactivatedEvent value,
    $Res Function(UserDeactivatedEvent) _then,
  ) = _$UserDeactivatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserDeactivatedEventCopyWithImpl<$Res>
    implements $UserDeactivatedEventCopyWith<$Res> {
  _$UserDeactivatedEventCopyWithImpl(this._self, this._then);

  final UserDeactivatedEvent _self;
  final $Res Function(UserDeactivatedEvent) _then;

  /// Create a copy of UserDeactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserDeactivatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserDeletedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get deleteConversation;
  bool get deleteConversationChannels;
  String get deleteMessages;
  String get deleteUser;
  bool get hardDelete;
  bool get markMessagesDeleted;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDeletedEventCopyWith<UserDeletedEvent> get copyWith =>
      _$UserDeletedEventCopyWithImpl<UserDeletedEvent>(
        this as UserDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDeletedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deleteConversation, deleteConversation) ||
                other.deleteConversation == deleteConversation) &&
            (identical(
                  other.deleteConversationChannels,
                  deleteConversationChannels,
                ) ||
                other.deleteConversationChannels ==
                    deleteConversationChannels) &&
            (identical(other.deleteMessages, deleteMessages) ||
                other.deleteMessages == deleteMessages) &&
            (identical(other.deleteUser, deleteUser) ||
                other.deleteUser == deleteUser) &&
            (identical(other.hardDelete, hardDelete) ||
                other.hardDelete == hardDelete) &&
            (identical(other.markMessagesDeleted, markMessagesDeleted) ||
                other.markMessagesDeleted == markMessagesDeleted) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    deleteConversation,
    deleteConversationChannels,
    deleteMessages,
    deleteUser,
    hardDelete,
    markMessagesDeleted,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserDeletedEvent(createdAt: $createdAt, custom: $custom, deleteConversation: $deleteConversation, deleteConversationChannels: $deleteConversationChannels, deleteMessages: $deleteMessages, deleteUser: $deleteUser, hardDelete: $hardDelete, markMessagesDeleted: $markMessagesDeleted, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserDeletedEventCopyWith<$Res> {
  factory $UserDeletedEventCopyWith(
    UserDeletedEvent value,
    $Res Function(UserDeletedEvent) _then,
  ) = _$UserDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    String deleteConversation,
    bool deleteConversationChannels,
    String deleteMessages,
    String deleteUser,
    bool hardDelete,
    bool markMessagesDeleted,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserDeletedEventCopyWithImpl<$Res>
    implements $UserDeletedEventCopyWith<$Res> {
  _$UserDeletedEventCopyWithImpl(this._self, this._then);

  final UserDeletedEvent _self;
  final $Res Function(UserDeletedEvent) _then;

  /// Create a copy of UserDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? deleteConversation = null,
    Object? deleteConversationChannels = null,
    Object? deleteMessages = null,
    Object? deleteUser = null,
    Object? hardDelete = null,
    Object? markMessagesDeleted = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserDeletedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deleteConversation: null == deleteConversation
            ? _self.deleteConversation
            : deleteConversation // ignore: cast_nullable_to_non_nullable
                  as String,
        deleteConversationChannels: null == deleteConversationChannels
            ? _self.deleteConversationChannels
            : deleteConversationChannels // ignore: cast_nullable_to_non_nullable
                  as bool,
        deleteMessages: null == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as String,
        deleteUser: null == deleteUser
            ? _self.deleteUser
            : deleteUser // ignore: cast_nullable_to_non_nullable
                  as String,
        hardDelete: null == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
        markMessagesDeleted: null == markMessagesDeleted
            ? _self.markMessagesDeleted
            : markMessagesDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserPresenceChangedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserPresenceChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserPresenceChangedEventCopyWith<UserPresenceChangedEvent> get copyWith =>
      _$UserPresenceChangedEventCopyWithImpl<UserPresenceChangedEvent>(
        this as UserPresenceChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserPresenceChangedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserPresenceChangedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserPresenceChangedEventCopyWith<$Res> {
  factory $UserPresenceChangedEventCopyWith(
    UserPresenceChangedEvent value,
    $Res Function(UserPresenceChangedEvent) _then,
  ) = _$UserPresenceChangedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserPresenceChangedEventCopyWithImpl<$Res>
    implements $UserPresenceChangedEventCopyWith<$Res> {
  _$UserPresenceChangedEventCopyWithImpl(this._self, this._then);

  final UserPresenceChangedEvent _self;
  final $Res Function(UserPresenceChangedEvent) _then;

  /// Create a copy of UserPresenceChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserPresenceChangedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserReactivatedEvent {
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserReactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserReactivatedEventCopyWith<UserReactivatedEvent> get copyWith =>
      _$UserReactivatedEventCopyWithImpl<UserReactivatedEvent>(
        this as UserReactivatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserReactivatedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserReactivatedEvent(createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserReactivatedEventCopyWith<$Res> {
  factory $UserReactivatedEventCopyWith(
    UserReactivatedEvent value,
    $Res Function(UserReactivatedEvent) _then,
  ) = _$UserReactivatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserReactivatedEventCopyWithImpl<$Res>
    implements $UserReactivatedEventCopyWith<$Res> {
  _$UserReactivatedEventCopyWithImpl(this._self, this._then);

  final UserReactivatedEvent _self;
  final $Res Function(UserReactivatedEvent) _then;

  /// Create a copy of UserReactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserReactivatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserUnbannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  bool? get shadow;
  String? get team;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserUnbannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUnbannedEventCopyWith<UserUnbannedEvent> get copyWith =>
      _$UserUnbannedEventCopyWithImpl<UserUnbannedEvent>(
        this as UserUnbannedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUnbannedEvent &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    shadow,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUnbannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, shadow: $shadow, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserUnbannedEventCopyWith<$Res> {
  factory $UserUnbannedEventCopyWith(
    UserUnbannedEvent value,
    $Res Function(UserUnbannedEvent) _then,
  ) = _$UserUnbannedEventCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    bool? shadow,
    String? team,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserUnbannedEventCopyWithImpl<$Res>
    implements $UserUnbannedEventCopyWith<$Res> {
  _$UserUnbannedEventCopyWithImpl(this._self, this._then);

  final UserUnbannedEvent _self;
  final $Res Function(UserUnbannedEvent) _then;

  /// Create a copy of UserUnbannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUnbannedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponsePrivacyFields get user;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUpdatedEventCopyWith<UserUpdatedEvent> get copyWith =>
      _$UserUpdatedEventCopyWithImpl<UserUpdatedEvent>(
        this as UserUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUpdatedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUpdatedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserUpdatedEventCopyWith<$Res> {
  factory $UserUpdatedEventCopyWith(
    UserUpdatedEvent value,
    $Res Function(UserUpdatedEvent) _then,
  ) = _$UserUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponsePrivacyFields user,
  });
}

/// @nodoc
class _$UserUpdatedEventCopyWithImpl<$Res>
    implements $UserUpdatedEventCopyWith<$Res> {
  _$UserUpdatedEventCopyWithImpl(this._self, this._then);

  final UserUpdatedEvent _self;
  final $Res Function(UserUpdatedEvent) _then;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponsePrivacyFields,
      ),
    );
  }
}
