// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSessionStartedEvent extends CallSessionStartedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String sessionId;
  @override
  final String type;

  factory _$CallSessionStartedEvent(
          [void Function(CallSessionStartedEventBuilder)? updates]) =>
      (CallSessionStartedEventBuilder()..update(updates))._build();

  _$CallSessionStartedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.sessionId,
      required this.type})
      : super._();
  @override
  CallSessionStartedEvent rebuild(
          void Function(CallSessionStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionStartedEventBuilder toBuilder() =>
      CallSessionStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionStartedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        sessionId == other.sessionId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSessionStartedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('sessionId', sessionId)
          ..add('type', type))
        .toString();
  }
}

class CallSessionStartedEventBuilder
    implements
        Builder<CallSessionStartedEvent, CallSessionStartedEventBuilder> {
  _$CallSessionStartedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallSessionStartedEventBuilder() {
    CallSessionStartedEvent._defaults(this);
  }

  CallSessionStartedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _sessionId = $v.sessionId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionStartedEvent other) {
    _$v = other as _$CallSessionStartedEvent;
  }

  @override
  void update(void Function(CallSessionStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionStartedEvent build() => _build();

  _$CallSessionStartedEvent _build() {
    _$CallSessionStartedEvent _$result;
    try {
      _$result = _$v ??
          _$CallSessionStartedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallSessionStartedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallSessionStartedEvent', 'createdAt'),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallSessionStartedEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallSessionStartedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSessionStartedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
