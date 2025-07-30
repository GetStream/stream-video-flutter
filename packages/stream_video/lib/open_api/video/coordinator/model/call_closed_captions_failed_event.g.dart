// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_failed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallClosedCaptionsFailedEvent extends CallClosedCaptionsFailedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallClosedCaptionsFailedEvent(
          [void Function(CallClosedCaptionsFailedEventBuilder)? updates]) =>
      (CallClosedCaptionsFailedEventBuilder()..update(updates))._build();

  _$CallClosedCaptionsFailedEvent._(
      {required this.callCid, required this.createdAt, required this.type})
      : super._();
  @override
  CallClosedCaptionsFailedEvent rebuild(
          void Function(CallClosedCaptionsFailedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallClosedCaptionsFailedEventBuilder toBuilder() =>
      CallClosedCaptionsFailedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallClosedCaptionsFailedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallClosedCaptionsFailedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallClosedCaptionsFailedEventBuilder
    implements
        Builder<CallClosedCaptionsFailedEvent,
            CallClosedCaptionsFailedEventBuilder> {
  _$CallClosedCaptionsFailedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallClosedCaptionsFailedEventBuilder() {
    CallClosedCaptionsFailedEvent._defaults(this);
  }

  CallClosedCaptionsFailedEventBuilder get _$this {
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
  void replace(CallClosedCaptionsFailedEvent other) {
    _$v = other as _$CallClosedCaptionsFailedEvent;
  }

  @override
  void update(void Function(CallClosedCaptionsFailedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallClosedCaptionsFailedEvent build() => _build();

  _$CallClosedCaptionsFailedEvent _build() {
    final _$result = _$v ??
        _$CallClosedCaptionsFailedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallClosedCaptionsFailedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallClosedCaptionsFailedEvent', 'createdAt'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallClosedCaptionsFailedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
