// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_accepted_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallAcceptedEvent extends CallAcceptedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$CallAcceptedEvent(
          [void Function(CallAcceptedEventBuilder)? updates]) =>
      (CallAcceptedEventBuilder()..update(updates))._build();

  _$CallAcceptedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.type,
      required this.user})
      : super._();
  @override
  CallAcceptedEvent rebuild(void Function(CallAcceptedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallAcceptedEventBuilder toBuilder() =>
      CallAcceptedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallAcceptedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallAcceptedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class CallAcceptedEventBuilder
    implements Builder<CallAcceptedEvent, CallAcceptedEventBuilder> {
  _$CallAcceptedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CallAcceptedEventBuilder() {
    CallAcceptedEvent._defaults(this);
  }

  CallAcceptedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallAcceptedEvent other) {
    _$v = other as _$CallAcceptedEvent;
  }

  @override
  void update(void Function(CallAcceptedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallAcceptedEvent build() => _build();

  _$CallAcceptedEvent _build() {
    _$CallAcceptedEvent _$result;
    try {
      _$result = _$v ??
          _$CallAcceptedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallAcceptedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallAcceptedEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallAcceptedEvent', 'type'),
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
            r'CallAcceptedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
