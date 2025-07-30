// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_transcription_failed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallTranscriptionFailedEvent extends CallTranscriptionFailedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String? error;
  @override
  final String type;

  factory _$CallTranscriptionFailedEvent(
          [void Function(CallTranscriptionFailedEventBuilder)? updates]) =>
      (CallTranscriptionFailedEventBuilder()..update(updates))._build();

  _$CallTranscriptionFailedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.egressId,
      this.error,
      required this.type})
      : super._();
  @override
  CallTranscriptionFailedEvent rebuild(
          void Function(CallTranscriptionFailedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallTranscriptionFailedEventBuilder toBuilder() =>
      CallTranscriptionFailedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallTranscriptionFailedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        error == other.error &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallTranscriptionFailedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('error', error)
          ..add('type', type))
        .toString();
  }
}

class CallTranscriptionFailedEventBuilder
    implements
        Builder<CallTranscriptionFailedEvent,
            CallTranscriptionFailedEventBuilder> {
  _$CallTranscriptionFailedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallTranscriptionFailedEventBuilder() {
    CallTranscriptionFailedEvent._defaults(this);
  }

  CallTranscriptionFailedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _error = $v.error;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallTranscriptionFailedEvent other) {
    _$v = other as _$CallTranscriptionFailedEvent;
  }

  @override
  void update(void Function(CallTranscriptionFailedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallTranscriptionFailedEvent build() => _build();

  _$CallTranscriptionFailedEvent _build() {
    final _$result = _$v ??
        _$CallTranscriptionFailedEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallTranscriptionFailedEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallTranscriptionFailedEvent', 'createdAt'),
          egressId: BuiltValueNullFieldError.checkNotNull(
              egressId, r'CallTranscriptionFailedEvent', 'egressId'),
          error: error,
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallTranscriptionFailedEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
