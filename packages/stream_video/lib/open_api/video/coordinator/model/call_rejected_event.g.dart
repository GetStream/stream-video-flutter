// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rejected_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRejectedEvent extends CallRejectedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String? reason;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$CallRejectedEvent(
          [void Function(CallRejectedEventBuilder)? updates]) =>
      (CallRejectedEventBuilder()..update(updates))._build();

  _$CallRejectedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      this.reason,
      required this.type,
      required this.user})
      : super._();
  @override
  CallRejectedEvent rebuild(void Function(CallRejectedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRejectedEventBuilder toBuilder() =>
      CallRejectedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRejectedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        reason == other.reason &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRejectedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('reason', reason)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class CallRejectedEventBuilder
    implements Builder<CallRejectedEvent, CallRejectedEventBuilder> {
  _$CallRejectedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CallRejectedEventBuilder() {
    CallRejectedEvent._defaults(this);
  }

  CallRejectedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _reason = $v.reason;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRejectedEvent other) {
    _$v = other as _$CallRejectedEvent;
  }

  @override
  void update(void Function(CallRejectedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRejectedEvent build() => _build();

  _$CallRejectedEvent _build() {
    _$CallRejectedEvent _$result;
    try {
      _$result = _$v ??
          _$CallRejectedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallRejectedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallRejectedEvent', 'createdAt'),
            reason: reason,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallRejectedEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallRejectedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
