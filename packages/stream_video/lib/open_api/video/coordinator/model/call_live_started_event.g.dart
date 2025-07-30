// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_live_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallLiveStartedEvent extends CallLiveStartedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallLiveStartedEvent(
          [void Function(CallLiveStartedEventBuilder)? updates]) =>
      (CallLiveStartedEventBuilder()..update(updates))._build();

  _$CallLiveStartedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.type})
      : super._();
  @override
  CallLiveStartedEvent rebuild(
          void Function(CallLiveStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallLiveStartedEventBuilder toBuilder() =>
      CallLiveStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallLiveStartedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallLiveStartedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallLiveStartedEventBuilder
    implements Builder<CallLiveStartedEvent, CallLiveStartedEventBuilder> {
  _$CallLiveStartedEvent? _$v;

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

  CallLiveStartedEventBuilder() {
    CallLiveStartedEvent._defaults(this);
  }

  CallLiveStartedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallLiveStartedEvent other) {
    _$v = other as _$CallLiveStartedEvent;
  }

  @override
  void update(void Function(CallLiveStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallLiveStartedEvent build() => _build();

  _$CallLiveStartedEvent _build() {
    _$CallLiveStartedEvent _$result;
    try {
      _$result = _$v ??
          _$CallLiveStartedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallLiveStartedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallLiveStartedEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallLiveStartedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallLiveStartedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
