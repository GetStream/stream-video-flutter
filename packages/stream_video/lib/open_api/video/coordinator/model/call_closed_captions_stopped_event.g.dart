// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_stopped_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallClosedCaptionsStoppedEvent extends CallClosedCaptionsStoppedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallClosedCaptionsStoppedEvent(
          [void Function(CallClosedCaptionsStoppedEventBuilder)? updates]) =>
      (CallClosedCaptionsStoppedEventBuilder()..update(updates))._build();

  _$CallClosedCaptionsStoppedEvent._(
      {required this.callCid, required this.createdAt, required this.type})
      : super._();
  @override
  CallClosedCaptionsStoppedEvent rebuild(
          void Function(CallClosedCaptionsStoppedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallClosedCaptionsStoppedEventBuilder toBuilder() =>
      CallClosedCaptionsStoppedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallClosedCaptionsStoppedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallClosedCaptionsStoppedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallClosedCaptionsStoppedEventBuilder
    implements
        Builder<CallClosedCaptionsStoppedEvent,
            CallClosedCaptionsStoppedEventBuilder> {
  _$CallClosedCaptionsStoppedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallClosedCaptionsStoppedEventBuilder() {
    CallClosedCaptionsStoppedEvent._defaults(this);
  }

  CallClosedCaptionsStoppedEventBuilder get _$this {
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
  void replace(CallClosedCaptionsStoppedEvent other) {
    _$v = other as _$CallClosedCaptionsStoppedEvent;
  }

  @override
  void update(void Function(CallClosedCaptionsStoppedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallClosedCaptionsStoppedEvent build() => _build();

  _$CallClosedCaptionsStoppedEvent _build() {
    final _$result = _$v ??
        _$CallClosedCaptionsStoppedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallClosedCaptionsStoppedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallClosedCaptionsStoppedEvent', 'createdAt'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallClosedCaptionsStoppedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
