// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRecordingStartedEvent extends CallRecordingStartedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallRecordingStartedEvent(
          [void Function(CallRecordingStartedEventBuilder)? updates]) =>
      (CallRecordingStartedEventBuilder()..update(updates))._build();

  _$CallRecordingStartedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallRecordingStartedEvent rebuild(
          void Function(CallRecordingStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRecordingStartedEventBuilder toBuilder() =>
      CallRecordingStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRecordingStartedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallRecordingStartedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallRecordingStartedEventBuilder
    implements
        Builder<CallRecordingStartedEvent, CallRecordingStartedEventBuilder> {
  _$CallRecordingStartedEvent? _$v;

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

  CallRecordingStartedEventBuilder() {
    CallRecordingStartedEvent._defaults(this);
  }

  CallRecordingStartedEventBuilder get _$this {
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
  void replace(CallRecordingStartedEvent other) {
    _$v = other as _$CallRecordingStartedEvent;
  }

  @override
  void update(void Function(CallRecordingStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRecordingStartedEvent build() => _build();

  _$CallRecordingStartedEvent _build() {
    final _$result = _$v ??
        _$CallRecordingStartedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRecordingStartedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRecordingStartedEvent', 'createdAt'),
          egressId: BuiltValueNullFieldError.checkNotNull(
              egressId, r'CallRecordingStartedEvent', 'egressId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRecordingStartedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
