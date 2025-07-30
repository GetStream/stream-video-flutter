// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallTranscriptionStartedEvent extends CallTranscriptionStartedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallTranscriptionStartedEvent(
          [void Function(CallTranscriptionStartedEventBuilder)? updates]) =>
      (CallTranscriptionStartedEventBuilder()..update(updates))._build();

  _$CallTranscriptionStartedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallTranscriptionStartedEvent rebuild(
          void Function(CallTranscriptionStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallTranscriptionStartedEventBuilder toBuilder() =>
      CallTranscriptionStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallTranscriptionStartedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallTranscriptionStartedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallTranscriptionStartedEventBuilder
    implements
        Builder<CallTranscriptionStartedEvent,
            CallTranscriptionStartedEventBuilder> {
  _$CallTranscriptionStartedEvent? _$v;

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

  CallTranscriptionStartedEventBuilder() {
    CallTranscriptionStartedEvent._defaults(this);
  }

  CallTranscriptionStartedEventBuilder get _$this {
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
  void replace(CallTranscriptionStartedEvent other) {
    _$v = other as _$CallTranscriptionStartedEvent;
  }

  @override
  void update(void Function(CallTranscriptionStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallTranscriptionStartedEvent build() => _build();

  _$CallTranscriptionStartedEvent _build() {
    final _$result = _$v ??
        _$CallTranscriptionStartedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallTranscriptionStartedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallTranscriptionStartedEvent', 'createdAt'),
          egressId: BuiltValueNullFieldError.checkNotNull(
              egressId, r'CallTranscriptionStartedEvent', 'egressId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallTranscriptionStartedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
