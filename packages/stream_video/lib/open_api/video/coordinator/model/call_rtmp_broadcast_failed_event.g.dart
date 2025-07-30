// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rtmp_broadcast_failed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRtmpBroadcastFailedEvent extends CallRtmpBroadcastFailedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String name;
  @override
  final String type;

  factory _$CallRtmpBroadcastFailedEvent(
          [void Function(CallRtmpBroadcastFailedEventBuilder)? updates]) =>
      (CallRtmpBroadcastFailedEventBuilder()..update(updates))._build();

  _$CallRtmpBroadcastFailedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.name,
      required this.type})
      : super._();
  @override
  CallRtmpBroadcastFailedEvent rebuild(
          void Function(CallRtmpBroadcastFailedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRtmpBroadcastFailedEventBuilder toBuilder() =>
      CallRtmpBroadcastFailedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRtmpBroadcastFailedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallRtmpBroadcastFailedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('name', name)
          ..add('type', type))
        .toString();
  }
}

class CallRtmpBroadcastFailedEventBuilder
    implements
        Builder<CallRtmpBroadcastFailedEvent,
            CallRtmpBroadcastFailedEventBuilder> {
  _$CallRtmpBroadcastFailedEvent? _$v;

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

  CallRtmpBroadcastFailedEventBuilder() {
    CallRtmpBroadcastFailedEvent._defaults(this);
  }

  CallRtmpBroadcastFailedEventBuilder get _$this {
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
  void replace(CallRtmpBroadcastFailedEvent other) {
    _$v = other as _$CallRtmpBroadcastFailedEvent;
  }

  @override
  void update(void Function(CallRtmpBroadcastFailedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRtmpBroadcastFailedEvent build() => _build();

  _$CallRtmpBroadcastFailedEvent _build() {
    final _$result = _$v ??
        _$CallRtmpBroadcastFailedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRtmpBroadcastFailedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRtmpBroadcastFailedEvent', 'createdAt'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CallRtmpBroadcastFailedEvent', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRtmpBroadcastFailedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
