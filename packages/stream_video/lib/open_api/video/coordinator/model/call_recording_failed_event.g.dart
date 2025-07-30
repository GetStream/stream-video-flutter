// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_failed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRecordingFailedEvent extends CallRecordingFailedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallRecordingFailedEvent(
          [void Function(CallRecordingFailedEventBuilder)? updates]) =>
      (CallRecordingFailedEventBuilder()..update(updates))._build();

  _$CallRecordingFailedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallRecordingFailedEvent rebuild(
          void Function(CallRecordingFailedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRecordingFailedEventBuilder toBuilder() =>
      CallRecordingFailedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRecordingFailedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallRecordingFailedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallRecordingFailedEventBuilder
    implements
        Builder<CallRecordingFailedEvent, CallRecordingFailedEventBuilder> {
  _$CallRecordingFailedEvent? _$v;

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

  CallRecordingFailedEventBuilder() {
    CallRecordingFailedEvent._defaults(this);
  }

  CallRecordingFailedEventBuilder get _$this {
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
  void replace(CallRecordingFailedEvent other) {
    _$v = other as _$CallRecordingFailedEvent;
  }

  @override
  void update(void Function(CallRecordingFailedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRecordingFailedEvent build() => _build();

  _$CallRecordingFailedEvent _build() {
    final _$result = _$v ??
        _$CallRecordingFailedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallRecordingFailedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallRecordingFailedEvent', 'createdAt'),
          egressId: BuiltValueNullFieldError.checkNotNull(
              egressId, r'CallRecordingFailedEvent', 'egressId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallRecordingFailedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
