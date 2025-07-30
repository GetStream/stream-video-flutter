// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallClosedCaptionsStartedEvent extends CallClosedCaptionsStartedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallClosedCaptionsStartedEvent(
          [void Function(CallClosedCaptionsStartedEventBuilder)? updates]) =>
      (CallClosedCaptionsStartedEventBuilder()..update(updates))._build();

  _$CallClosedCaptionsStartedEvent._(
      {required this.callCid, required this.createdAt, required this.type})
      : super._();
  @override
  CallClosedCaptionsStartedEvent rebuild(
          void Function(CallClosedCaptionsStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallClosedCaptionsStartedEventBuilder toBuilder() =>
      CallClosedCaptionsStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallClosedCaptionsStartedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallClosedCaptionsStartedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallClosedCaptionsStartedEventBuilder
    implements
        Builder<CallClosedCaptionsStartedEvent,
            CallClosedCaptionsStartedEventBuilder> {
  _$CallClosedCaptionsStartedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallClosedCaptionsStartedEventBuilder() {
    CallClosedCaptionsStartedEvent._defaults(this);
  }

  CallClosedCaptionsStartedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallClosedCaptionsStartedEvent other) {
    _$v = other as _$CallClosedCaptionsStartedEvent;
  }

  @override
  void update(void Function(CallClosedCaptionsStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallClosedCaptionsStartedEvent build() => _build();

  _$CallClosedCaptionsStartedEvent _build() {
    final _$result = _$v ??
        _$CallClosedCaptionsStartedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallClosedCaptionsStartedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallClosedCaptionsStartedEvent', 'createdAt'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallClosedCaptionsStartedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
