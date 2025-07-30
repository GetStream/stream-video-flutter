// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_notification_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallNotificationEvent extends CallNotificationEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final String sessionId;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$CallNotificationEvent(
          [void Function(CallNotificationEventBuilder)? updates]) =>
      (CallNotificationEventBuilder()..update(updates))._build();

  _$CallNotificationEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.members,
      required this.sessionId,
      required this.type,
      required this.user})
      : super._();
  @override
  CallNotificationEvent rebuild(
          void Function(CallNotificationEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallNotificationEventBuilder toBuilder() =>
      CallNotificationEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallNotificationEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        members == other.members &&
        sessionId == other.sessionId &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallNotificationEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('sessionId', sessionId)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class CallNotificationEventBuilder
    implements Builder<CallNotificationEvent, CallNotificationEventBuilder> {
  _$CallNotificationEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CallNotificationEventBuilder() {
    CallNotificationEvent._defaults(this);
  }

  CallNotificationEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _members = $v.members.toBuilder();
      _sessionId = $v.sessionId;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallNotificationEvent other) {
    _$v = other as _$CallNotificationEvent;
  }

  @override
  void update(void Function(CallNotificationEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallNotificationEvent build() => _build();

  _$CallNotificationEvent _build() {
    _$CallNotificationEvent _$result;
    try {
      _$result = _$v ??
          _$CallNotificationEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallNotificationEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallNotificationEvent', 'createdAt'),
            members: members.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallNotificationEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallNotificationEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'members';
        members.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallNotificationEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
