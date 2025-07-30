// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rtmp_broadcast_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRtmpBroadcastStartedEvent extends CallRtmpBroadcastStartedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String name;
  @override
  final String type;

  factory _$CallRtmpBroadcastStartedEvent(
          [void Function(CallRtmpBroadcastStartedEventBuilder)? updates]) =>
      (CallRtmpBroadcastStartedEventBuilder()..update(updates))._build();

  _$CallRtmpBroadcastStartedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.name,
      required this.type})
      : super._();
  @override
  CallRtmpBroadcastStartedEvent rebuild(
          void Function(CallRtmpBroadcastStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRtmpBroadcastStartedEventBuilder toBuilder() =>
      CallRtmpBroadcastStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRtmpBroadcastStartedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallRtmpBroadcastStartedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('name', name)
          ..add('type', type))
        .toString();
  }
}

class CallRtmpBroadcastStartedEventBuilder
    implements
        Builder<CallRtmpBroadcastStartedEvent,
            CallRtmpBroadcastStartedEventBuilder> {
  _$CallRtmpBroadcastStartedEvent? _$v;

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

  CallRtmpBroadcastStartedEventBuilder() {
    CallRtmpBroadcastStartedEvent._defaults(this);
  }

  CallRtmpBroadcastStartedEventBuilder get _$this {
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
  void replace(CallRtmpBroadcastStartedEvent other) {
    _$v = other as _$CallRtmpBroadcastStartedEvent;
  }

  @override
  void update(void Function(CallRtmpBroadcastStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRtmpBroadcastStartedEvent build() => _build();

  _$CallRtmpBroadcastStartedEvent _build() {
    final _$result = _$v ??
        _$CallRtmpBroadcastStartedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRtmpBroadcastStartedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRtmpBroadcastStartedEvent', 'createdAt'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CallRtmpBroadcastStartedEvent', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRtmpBroadcastStartedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
