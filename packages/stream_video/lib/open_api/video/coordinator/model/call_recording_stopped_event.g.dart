// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_stopped_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRecordingStoppedEvent extends CallRecordingStoppedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallRecordingStoppedEvent(
          [void Function(CallRecordingStoppedEventBuilder)? updates]) =>
      (CallRecordingStoppedEventBuilder()..update(updates))._build();

  _$CallRecordingStoppedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallRecordingStoppedEvent rebuild(
          void Function(CallRecordingStoppedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRecordingStoppedEventBuilder toBuilder() =>
      CallRecordingStoppedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRecordingStoppedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRecordingStoppedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallRecordingStoppedEventBuilder
    implements
        Builder<CallRecordingStoppedEvent, CallRecordingStoppedEventBuilder> {
  _$CallRecordingStoppedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallRecordingStoppedEventBuilder() {
    CallRecordingStoppedEvent._defaults(this);
  }

  CallRecordingStoppedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRecordingStoppedEvent other) {
    _$v = other as _$CallRecordingStoppedEvent;
  }

  @override
  void update(void Function(CallRecordingStoppedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRecordingStoppedEvent build() => _build();

  _$CallRecordingStoppedEvent _build() {
    final _$result = _$v ??
        _$CallRecordingStoppedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRecordingStoppedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRecordingStoppedEvent', 'createdAt'),
          egressId: BuiltValueNullFieldError.checkNotNull(
              egressId, r'CallRecordingStoppedEvent', 'egressId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRecordingStoppedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
