// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_stopped_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallHLSBroadcastingStoppedEvent
    extends CallHLSBroadcastingStoppedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallHLSBroadcastingStoppedEvent(
          [void Function(CallHLSBroadcastingStoppedEventBuilder)? updates]) =>
      (CallHLSBroadcastingStoppedEventBuilder()..update(updates))._build();

  _$CallHLSBroadcastingStoppedEvent._(
      {required this.callCid, required this.createdAt, required this.type})
      : super._();
  @override
  CallHLSBroadcastingStoppedEvent rebuild(
          void Function(CallHLSBroadcastingStoppedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallHLSBroadcastingStoppedEventBuilder toBuilder() =>
      CallHLSBroadcastingStoppedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallHLSBroadcastingStoppedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallHLSBroadcastingStoppedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallHLSBroadcastingStoppedEventBuilder
    implements
        Builder<CallHLSBroadcastingStoppedEvent,
            CallHLSBroadcastingStoppedEventBuilder> {
  _$CallHLSBroadcastingStoppedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallHLSBroadcastingStoppedEventBuilder() {
    CallHLSBroadcastingStoppedEvent._defaults(this);
  }

  CallHLSBroadcastingStoppedEventBuilder get _$this {
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
  void replace(CallHLSBroadcastingStoppedEvent other) {
    _$v = other as _$CallHLSBroadcastingStoppedEvent;
  }

  @override
  void update(void Function(CallHLSBroadcastingStoppedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallHLSBroadcastingStoppedEvent build() => _build();

  _$CallHLSBroadcastingStoppedEvent _build() {
    final _$result = _$v ??
        _$CallHLSBroadcastingStoppedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallHLSBroadcastingStoppedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallHLSBroadcastingStoppedEvent', 'createdAt'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallHLSBroadcastingStoppedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
