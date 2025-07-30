// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_ready_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRecordingReadyEvent extends CallRecordingReadyEvent {
  @override
  final String callCid;
  @override
  final CallRecording callRecording;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallRecordingReadyEvent(
          [void Function(CallRecordingReadyEventBuilder)? updates]) =>
      (CallRecordingReadyEventBuilder()..update(updates))._build();

  _$CallRecordingReadyEvent._(
      {required this.callCid,
      required this.callRecording,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallRecordingReadyEvent rebuild(
          void Function(CallRecordingReadyEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRecordingReadyEventBuilder toBuilder() =>
      CallRecordingReadyEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRecordingReadyEvent &&
        callCid == other.callCid &&
        callRecording == other.callRecording &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, callRecording.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRecordingReadyEvent')
          ..add('callCid', callCid)
          ..add('callRecording', callRecording)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallRecordingReadyEventBuilder
    implements
        Builder<CallRecordingReadyEvent, CallRecordingReadyEventBuilder> {
  _$CallRecordingReadyEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  CallRecordingBuilder? _callRecording;
  CallRecordingBuilder get callRecording =>
      _$this._callRecording ??= CallRecordingBuilder();
  set callRecording(CallRecordingBuilder? callRecording) =>
      _$this._callRecording = callRecording;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallRecordingReadyEventBuilder() {
    CallRecordingReadyEvent._defaults(this);
  }

  CallRecordingReadyEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _callRecording = $v.callRecording.toBuilder();
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRecordingReadyEvent other) {
    _$v = other as _$CallRecordingReadyEvent;
  }

  @override
  void update(void Function(CallRecordingReadyEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRecordingReadyEvent build() => _build();

  _$CallRecordingReadyEvent _build() {
    _$CallRecordingReadyEvent _$result;
    try {
      _$result = _$v ??
          _$CallRecordingReadyEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallRecordingReadyEvent', 'callCid'),
            callRecording: callRecording.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallRecordingReadyEvent', 'createdAt'),
            egressId: BuiltValueNullFieldError.checkNotNull(
                egressId, r'CallRecordingReadyEvent', 'egressId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallRecordingReadyEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'callRecording';
        callRecording.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallRecordingReadyEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
