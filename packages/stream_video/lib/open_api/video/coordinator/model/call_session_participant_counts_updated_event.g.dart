// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_counts_updated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSessionParticipantCountsUpdatedEvent
    extends CallSessionParticipantCountsUpdatedEvent {
  @override
  final int anonymousParticipantCount;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, int> participantsCountByRole;
  @override
  final String sessionId;
  @override
  final String type;

  factory _$CallSessionParticipantCountsUpdatedEvent(
          [void Function(CallSessionParticipantCountsUpdatedEventBuilder)?
              updates]) =>
      (CallSessionParticipantCountsUpdatedEventBuilder()..update(updates))
          ._build();

  _$CallSessionParticipantCountsUpdatedEvent._(
      {required this.anonymousParticipantCount,
      required this.callCid,
      required this.createdAt,
      required this.participantsCountByRole,
      required this.sessionId,
      required this.type})
      : super._();
  @override
  CallSessionParticipantCountsUpdatedEvent rebuild(
          void Function(CallSessionParticipantCountsUpdatedEventBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionParticipantCountsUpdatedEventBuilder toBuilder() =>
      CallSessionParticipantCountsUpdatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionParticipantCountsUpdatedEvent &&
        anonymousParticipantCount == other.anonymousParticipantCount &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        participantsCountByRole == other.participantsCountByRole &&
        sessionId == other.sessionId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anonymousParticipantCount.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, participantsCountByRole.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CallSessionParticipantCountsUpdatedEvent')
          ..add('anonymousParticipantCount', anonymousParticipantCount)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('participantsCountByRole', participantsCountByRole)
          ..add('sessionId', sessionId)
          ..add('type', type))
        .toString();
  }
}

class CallSessionParticipantCountsUpdatedEventBuilder
    implements
        Builder<CallSessionParticipantCountsUpdatedEvent,
            CallSessionParticipantCountsUpdatedEventBuilder> {
  _$CallSessionParticipantCountsUpdatedEvent? _$v;

  int? _anonymousParticipantCount;
  int? get anonymousParticipantCount => _$this._anonymousParticipantCount;
  set anonymousParticipantCount(int? anonymousParticipantCount) =>
      _$this._anonymousParticipantCount = anonymousParticipantCount;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, int>? _participantsCountByRole;
  MapBuilder<String, int> get participantsCountByRole =>
      _$this._participantsCountByRole ??= MapBuilder<String, int>();
  set participantsCountByRole(
          MapBuilder<String, int>? participantsCountByRole) =>
      _$this._participantsCountByRole = participantsCountByRole;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallSessionParticipantCountsUpdatedEventBuilder() {
    CallSessionParticipantCountsUpdatedEvent._defaults(this);
  }

  CallSessionParticipantCountsUpdatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anonymousParticipantCount = $v.anonymousParticipantCount;
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _participantsCountByRole = $v.participantsCountByRole.toBuilder();
      _sessionId = $v.sessionId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionParticipantCountsUpdatedEvent other) {
    _$v = other as _$CallSessionParticipantCountsUpdatedEvent;
  }

  @override
  void update(
      void Function(CallSessionParticipantCountsUpdatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionParticipantCountsUpdatedEvent build() => _build();

  _$CallSessionParticipantCountsUpdatedEvent _build() {
    _$CallSessionParticipantCountsUpdatedEvent _$result;
    try {
      _$result = _$v ??
          _$CallSessionParticipantCountsUpdatedEvent._(
            anonymousParticipantCount: BuiltValueNullFieldError.checkNotNull(
                anonymousParticipantCount,
                r'CallSessionParticipantCountsUpdatedEvent',
                'anonymousParticipantCount'),
            callCid: BuiltValueNullFieldError.checkNotNull(callCid,
                r'CallSessionParticipantCountsUpdatedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'CallSessionParticipantCountsUpdatedEvent', 'createdAt'),
            participantsCountByRole: participantsCountByRole.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(sessionId,
                r'CallSessionParticipantCountsUpdatedEvent', 'sessionId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallSessionParticipantCountsUpdatedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participantsCountByRole';
        participantsCountByRole.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSessionParticipantCountsUpdatedEvent',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
