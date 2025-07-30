// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_left_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSessionParticipantLeftEvent
    extends CallSessionParticipantLeftEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final int durationSeconds;
  @override
  final CallParticipantResponse participant;
  @override
  final String sessionId;
  @override
  final String type;

  factory _$CallSessionParticipantLeftEvent(
          [void Function(CallSessionParticipantLeftEventBuilder)? updates]) =>
      (CallSessionParticipantLeftEventBuilder()..update(updates))._build();

  _$CallSessionParticipantLeftEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.durationSeconds,
      required this.participant,
      required this.sessionId,
      required this.type})
      : super._();
  @override
  CallSessionParticipantLeftEvent rebuild(
          void Function(CallSessionParticipantLeftEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionParticipantLeftEventBuilder toBuilder() =>
      CallSessionParticipantLeftEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionParticipantLeftEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        durationSeconds == other.durationSeconds &&
        participant == other.participant &&
        sessionId == other.sessionId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, participant.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSessionParticipantLeftEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('durationSeconds', durationSeconds)
          ..add('participant', participant)
          ..add('sessionId', sessionId)
          ..add('type', type))
        .toString();
  }
}

class CallSessionParticipantLeftEventBuilder
    implements
        Builder<CallSessionParticipantLeftEvent,
            CallSessionParticipantLeftEventBuilder> {
  _$CallSessionParticipantLeftEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  CallParticipantResponseBuilder? _participant;
  CallParticipantResponseBuilder get participant =>
      _$this._participant ??= CallParticipantResponseBuilder();
  set participant(CallParticipantResponseBuilder? participant) =>
      _$this._participant = participant;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallSessionParticipantLeftEventBuilder() {
    CallSessionParticipantLeftEvent._defaults(this);
  }

  CallSessionParticipantLeftEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _durationSeconds = $v.durationSeconds;
      _participant = $v.participant.toBuilder();
      _sessionId = $v.sessionId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionParticipantLeftEvent other) {
    _$v = other as _$CallSessionParticipantLeftEvent;
  }

  @override
  void update(void Function(CallSessionParticipantLeftEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionParticipantLeftEvent build() => _build();

  _$CallSessionParticipantLeftEvent _build() {
    _$CallSessionParticipantLeftEvent _$result;
    try {
      _$result = _$v ??
          _$CallSessionParticipantLeftEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallSessionParticipantLeftEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallSessionParticipantLeftEvent', 'createdAt'),
            durationSeconds: BuiltValueNullFieldError.checkNotNull(
                durationSeconds,
                r'CallSessionParticipantLeftEvent',
                'durationSeconds'),
            participant: participant.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallSessionParticipantLeftEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallSessionParticipantLeftEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participant';
        participant.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSessionParticipantLeftEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
