// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_joined_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSessionParticipantJoinedEvent
    extends CallSessionParticipantJoinedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final CallParticipantResponse participant;
  @override
  final String sessionId;
  @override
  final String type;

  factory _$CallSessionParticipantJoinedEvent(
          [void Function(CallSessionParticipantJoinedEventBuilder)? updates]) =>
      (CallSessionParticipantJoinedEventBuilder()..update(updates))._build();

  _$CallSessionParticipantJoinedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.participant,
      required this.sessionId,
      required this.type})
      : super._();
  @override
  CallSessionParticipantJoinedEvent rebuild(
          void Function(CallSessionParticipantJoinedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionParticipantJoinedEventBuilder toBuilder() =>
      CallSessionParticipantJoinedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionParticipantJoinedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        participant == other.participant &&
        sessionId == other.sessionId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, participant.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSessionParticipantJoinedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('participant', participant)
          ..add('sessionId', sessionId)
          ..add('type', type))
        .toString();
  }
}

class CallSessionParticipantJoinedEventBuilder
    implements
        Builder<CallSessionParticipantJoinedEvent,
            CallSessionParticipantJoinedEventBuilder> {
  _$CallSessionParticipantJoinedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

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

  CallSessionParticipantJoinedEventBuilder() {
    CallSessionParticipantJoinedEvent._defaults(this);
  }

  CallSessionParticipantJoinedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _participant = $v.participant.toBuilder();
      _sessionId = $v.sessionId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionParticipantJoinedEvent other) {
    _$v = other as _$CallSessionParticipantJoinedEvent;
  }

  @override
  void update(
      void Function(CallSessionParticipantJoinedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionParticipantJoinedEvent build() => _build();

  _$CallSessionParticipantJoinedEvent _build() {
    _$CallSessionParticipantJoinedEvent _$result;
    try {
      _$result = _$v ??
          _$CallSessionParticipantJoinedEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallSessionParticipantJoinedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallSessionParticipantJoinedEvent', 'createdAt'),
            participant: participant.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallSessionParticipantJoinedEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallSessionParticipantJoinedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participant';
        participant.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSessionParticipantJoinedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
