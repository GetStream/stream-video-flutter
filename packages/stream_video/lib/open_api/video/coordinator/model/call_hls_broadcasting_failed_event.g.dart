// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_failed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallHLSBroadcastingFailedEvent extends CallHLSBroadcastingFailedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallHLSBroadcastingFailedEvent(
          [void Function(CallHLSBroadcastingFailedEventBuilder)? updates]) =>
      (CallHLSBroadcastingFailedEventBuilder()..update(updates))._build();

  _$CallHLSBroadcastingFailedEvent._(
      {required this.callCid, required this.createdAt, required this.type})
      : super._();
  @override
  CallHLSBroadcastingFailedEvent rebuild(
          void Function(CallHLSBroadcastingFailedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallHLSBroadcastingFailedEventBuilder toBuilder() =>
      CallHLSBroadcastingFailedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallHLSBroadcastingFailedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallHLSBroadcastingFailedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallHLSBroadcastingFailedEventBuilder
    implements
        Builder<CallHLSBroadcastingFailedEvent,
            CallHLSBroadcastingFailedEventBuilder> {
  _$CallHLSBroadcastingFailedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallHLSBroadcastingFailedEventBuilder() {
    CallHLSBroadcastingFailedEvent._defaults(this);
  }

  CallHLSBroadcastingFailedEventBuilder get _$this {
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
  void replace(CallHLSBroadcastingFailedEvent other) {
    _$v = other as _$CallHLSBroadcastingFailedEvent;
  }

  @override
  void update(void Function(CallHLSBroadcastingFailedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallHLSBroadcastingFailedEvent build() => _build();

  _$CallHLSBroadcastingFailedEvent _build() {
    final _$result = _$v ??
        _$CallHLSBroadcastingFailedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallHLSBroadcastingFailedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallHLSBroadcastingFailedEvent', 'createdAt'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallHLSBroadcastingFailedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
