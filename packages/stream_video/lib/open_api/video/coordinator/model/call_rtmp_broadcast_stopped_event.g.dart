// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rtmp_broadcast_stopped_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRtmpBroadcastStoppedEvent extends CallRtmpBroadcastStoppedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String name;
  @override
  final String type;

  factory _$CallRtmpBroadcastStoppedEvent(
          [void Function(CallRtmpBroadcastStoppedEventBuilder)? updates]) =>
      (CallRtmpBroadcastStoppedEventBuilder()..update(updates))._build();

  _$CallRtmpBroadcastStoppedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.name,
      required this.type})
      : super._();
  @override
  CallRtmpBroadcastStoppedEvent rebuild(
          void Function(CallRtmpBroadcastStoppedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRtmpBroadcastStoppedEventBuilder toBuilder() =>
      CallRtmpBroadcastStoppedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRtmpBroadcastStoppedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        name == other.name &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRtmpBroadcastStoppedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('name', name)
          ..add('type', type))
        .toString();
  }
}

class CallRtmpBroadcastStoppedEventBuilder
    implements
        Builder<CallRtmpBroadcastStoppedEvent,
            CallRtmpBroadcastStoppedEventBuilder> {
  _$CallRtmpBroadcastStoppedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallRtmpBroadcastStoppedEventBuilder() {
    CallRtmpBroadcastStoppedEvent._defaults(this);
  }

  CallRtmpBroadcastStoppedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _name = $v.name;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRtmpBroadcastStoppedEvent other) {
    _$v = other as _$CallRtmpBroadcastStoppedEvent;
  }

  @override
  void update(void Function(CallRtmpBroadcastStoppedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRtmpBroadcastStoppedEvent build() => _build();

  _$CallRtmpBroadcastStoppedEvent _build() {
    final _$result = _$v ??
        _$CallRtmpBroadcastStoppedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRtmpBroadcastStoppedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRtmpBroadcastStoppedEvent', 'createdAt'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CallRtmpBroadcastStoppedEvent', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRtmpBroadcastStoppedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
