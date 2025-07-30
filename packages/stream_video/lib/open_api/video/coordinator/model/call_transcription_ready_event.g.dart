// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_ready_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallTranscriptionReadyEvent extends CallTranscriptionReadyEvent {
  @override
  final String callCid;
  @override
  final CallTranscription callTranscription;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallTranscriptionReadyEvent(
          [void Function(CallTranscriptionReadyEventBuilder)? updates]) =>
      (CallTranscriptionReadyEventBuilder()..update(updates))._build();

  _$CallTranscriptionReadyEvent._(
      {required this.callCid,
      required this.callTranscription,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallTranscriptionReadyEvent rebuild(
          void Function(CallTranscriptionReadyEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallTranscriptionReadyEventBuilder toBuilder() =>
      CallTranscriptionReadyEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallTranscriptionReadyEvent &&
        callCid == other.callCid &&
        callTranscription == other.callTranscription &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, callTranscription.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallTranscriptionReadyEvent')
          ..add('callCid', callCid)
          ..add('callTranscription', callTranscription)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallTranscriptionReadyEventBuilder
    implements
        Builder<CallTranscriptionReadyEvent,
            CallTranscriptionReadyEventBuilder> {
  _$CallTranscriptionReadyEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  CallTranscriptionBuilder? _callTranscription;
  CallTranscriptionBuilder get callTranscription =>
      _$this._callTranscription ??= CallTranscriptionBuilder();
  set callTranscription(CallTranscriptionBuilder? callTranscription) =>
      _$this._callTranscription = callTranscription;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallTranscriptionReadyEventBuilder() {
    CallTranscriptionReadyEvent._defaults(this);
  }

  CallTranscriptionReadyEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _callTranscription = $v.callTranscription.toBuilder();
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallTranscriptionReadyEvent other) {
    _$v = other as _$CallTranscriptionReadyEvent;
  }

  @override
  void update(void Function(CallTranscriptionReadyEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallTranscriptionReadyEvent build() => _build();

  _$CallTranscriptionReadyEvent _build() {
    _$CallTranscriptionReadyEvent _$result;
    try {
      _$result = _$v ??
          _$CallTranscriptionReadyEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallTranscriptionReadyEvent', 'callCid'),
            callTranscription: callTranscription.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallTranscriptionReadyEvent', 'createdAt'),
            egressId: BuiltValueNullFieldError.checkNotNull(
                egressId, r'CallTranscriptionReadyEvent', 'egressId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallTranscriptionReadyEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'callTranscription';
        callTranscription.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallTranscriptionReadyEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
