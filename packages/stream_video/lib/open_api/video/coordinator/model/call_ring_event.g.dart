// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_ring_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRingEvent extends CallRingEvent {
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
  @override
  final bool video;

  factory _$CallRingEvent([void Function(CallRingEventBuilder)? updates]) =>
      (CallRingEventBuilder()..update(updates))._build();

  _$CallRingEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.members,
      required this.sessionId,
      required this.type,
      required this.user,
      required this.video})
      : super._();
  @override
  CallRingEvent rebuild(void Function(CallRingEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRingEventBuilder toBuilder() => CallRingEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRingEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        members == other.members &&
        sessionId == other.sessionId &&
        type == other.type &&
        user == other.user &&
        video == other.video;
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
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRingEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('sessionId', sessionId)
          ..add('type', type)
          ..add('user', user)
          ..add('video', video))
        .toString();
  }
}

class CallRingEventBuilder
    implements Builder<CallRingEvent, CallRingEventBuilder> {
  _$CallRingEvent? _$v;

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

  bool? _video;
  bool? get video => _$this._video;
  set video(bool? video) => _$this._video = video;

  CallRingEventBuilder() {
    CallRingEvent._defaults(this);
  }

  CallRingEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _members = $v.members.toBuilder();
      _sessionId = $v.sessionId;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _video = $v.video;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRingEvent other) {
    _$v = other as _$CallRingEvent;
  }

  @override
  void update(void Function(CallRingEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRingEvent build() => _build();

  _$CallRingEvent _build() {
    _$CallRingEvent _$result;
    try {
      _$result = _$v ??
          _$CallRingEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallRingEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallRingEvent', 'createdAt'),
            members: members.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallRingEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallRingEvent', 'type'),
            user: user.build(),
            video: BuiltValueNullFieldError.checkNotNull(
                video, r'CallRingEvent', 'video'),
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
            r'CallRingEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
