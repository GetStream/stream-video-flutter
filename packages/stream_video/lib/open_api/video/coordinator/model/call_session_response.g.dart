// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSessionResponse extends CallSessionResponse {
  @override
  final BuiltMap<String, DateTime> acceptedBy;
  @override
  final int anonymousParticipantCount;
  @override
  final DateTime? endedAt;
  @override
  final String id;
  @override
  final DateTime? liveEndedAt;
  @override
  final DateTime? liveStartedAt;
  @override
  final BuiltMap<String, DateTime> missedBy;
  @override
  final BuiltList<CallParticipantResponse> participants;
  @override
  final BuiltMap<String, int> participantsCountByRole;
  @override
  final BuiltMap<String, DateTime> rejectedBy;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? timerEndsAt;

  factory _$CallSessionResponse(
          [void Function(CallSessionResponseBuilder)? updates]) =>
      (CallSessionResponseBuilder()..update(updates))._build();

  _$CallSessionResponse._(
      {required this.acceptedBy,
      required this.anonymousParticipantCount,
      this.endedAt,
      required this.id,
      this.liveEndedAt,
      this.liveStartedAt,
      required this.missedBy,
      required this.participants,
      required this.participantsCountByRole,
      required this.rejectedBy,
      this.startedAt,
      this.timerEndsAt})
      : super._();
  @override
  CallSessionResponse rebuild(
          void Function(CallSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionResponseBuilder toBuilder() =>
      CallSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionResponse &&
        acceptedBy == other.acceptedBy &&
        anonymousParticipantCount == other.anonymousParticipantCount &&
        endedAt == other.endedAt &&
        id == other.id &&
        liveEndedAt == other.liveEndedAt &&
        liveStartedAt == other.liveStartedAt &&
        missedBy == other.missedBy &&
        participants == other.participants &&
        participantsCountByRole == other.participantsCountByRole &&
        rejectedBy == other.rejectedBy &&
        startedAt == other.startedAt &&
        timerEndsAt == other.timerEndsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptedBy.hashCode);
    _$hash = $jc(_$hash, anonymousParticipantCount.hashCode);
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, liveEndedAt.hashCode);
    _$hash = $jc(_$hash, liveStartedAt.hashCode);
    _$hash = $jc(_$hash, missedBy.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jc(_$hash, participantsCountByRole.hashCode);
    _$hash = $jc(_$hash, rejectedBy.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, timerEndsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSessionResponse')
          ..add('acceptedBy', acceptedBy)
          ..add('anonymousParticipantCount', anonymousParticipantCount)
          ..add('endedAt', endedAt)
          ..add('id', id)
          ..add('liveEndedAt', liveEndedAt)
          ..add('liveStartedAt', liveStartedAt)
          ..add('missedBy', missedBy)
          ..add('participants', participants)
          ..add('participantsCountByRole', participantsCountByRole)
          ..add('rejectedBy', rejectedBy)
          ..add('startedAt', startedAt)
          ..add('timerEndsAt', timerEndsAt))
        .toString();
  }
}

class CallSessionResponseBuilder
    implements Builder<CallSessionResponse, CallSessionResponseBuilder> {
  _$CallSessionResponse? _$v;

  MapBuilder<String, DateTime>? _acceptedBy;
  MapBuilder<String, DateTime> get acceptedBy =>
      _$this._acceptedBy ??= MapBuilder<String, DateTime>();
  set acceptedBy(MapBuilder<String, DateTime>? acceptedBy) =>
      _$this._acceptedBy = acceptedBy;

  int? _anonymousParticipantCount;
  int? get anonymousParticipantCount => _$this._anonymousParticipantCount;
  set anonymousParticipantCount(int? anonymousParticipantCount) =>
      _$this._anonymousParticipantCount = anonymousParticipantCount;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _liveEndedAt;
  DateTime? get liveEndedAt => _$this._liveEndedAt;
  set liveEndedAt(DateTime? liveEndedAt) => _$this._liveEndedAt = liveEndedAt;

  DateTime? _liveStartedAt;
  DateTime? get liveStartedAt => _$this._liveStartedAt;
  set liveStartedAt(DateTime? liveStartedAt) =>
      _$this._liveStartedAt = liveStartedAt;

  MapBuilder<String, DateTime>? _missedBy;
  MapBuilder<String, DateTime> get missedBy =>
      _$this._missedBy ??= MapBuilder<String, DateTime>();
  set missedBy(MapBuilder<String, DateTime>? missedBy) =>
      _$this._missedBy = missedBy;

  ListBuilder<CallParticipantResponse>? _participants;
  ListBuilder<CallParticipantResponse> get participants =>
      _$this._participants ??= ListBuilder<CallParticipantResponse>();
  set participants(ListBuilder<CallParticipantResponse>? participants) =>
      _$this._participants = participants;

  MapBuilder<String, int>? _participantsCountByRole;
  MapBuilder<String, int> get participantsCountByRole =>
      _$this._participantsCountByRole ??= MapBuilder<String, int>();
  set participantsCountByRole(
          MapBuilder<String, int>? participantsCountByRole) =>
      _$this._participantsCountByRole = participantsCountByRole;

  MapBuilder<String, DateTime>? _rejectedBy;
  MapBuilder<String, DateTime> get rejectedBy =>
      _$this._rejectedBy ??= MapBuilder<String, DateTime>();
  set rejectedBy(MapBuilder<String, DateTime>? rejectedBy) =>
      _$this._rejectedBy = rejectedBy;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _timerEndsAt;
  DateTime? get timerEndsAt => _$this._timerEndsAt;
  set timerEndsAt(DateTime? timerEndsAt) => _$this._timerEndsAt = timerEndsAt;

  CallSessionResponseBuilder() {
    CallSessionResponse._defaults(this);
  }

  CallSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptedBy = $v.acceptedBy.toBuilder();
      _anonymousParticipantCount = $v.anonymousParticipantCount;
      _endedAt = $v.endedAt;
      _id = $v.id;
      _liveEndedAt = $v.liveEndedAt;
      _liveStartedAt = $v.liveStartedAt;
      _missedBy = $v.missedBy.toBuilder();
      _participants = $v.participants.toBuilder();
      _participantsCountByRole = $v.participantsCountByRole.toBuilder();
      _rejectedBy = $v.rejectedBy.toBuilder();
      _startedAt = $v.startedAt;
      _timerEndsAt = $v.timerEndsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionResponse other) {
    _$v = other as _$CallSessionResponse;
  }

  @override
  void update(void Function(CallSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionResponse build() => _build();

  _$CallSessionResponse _build() {
    _$CallSessionResponse _$result;
    try {
      _$result = _$v ??
          _$CallSessionResponse._(
            acceptedBy: acceptedBy.build(),
            anonymousParticipantCount: BuiltValueNullFieldError.checkNotNull(
                anonymousParticipantCount,
                r'CallSessionResponse',
                'anonymousParticipantCount'),
            endedAt: endedAt,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CallSessionResponse', 'id'),
            liveEndedAt: liveEndedAt,
            liveStartedAt: liveStartedAt,
            missedBy: missedBy.build(),
            participants: participants.build(),
            participantsCountByRole: participantsCountByRole.build(),
            rejectedBy: rejectedBy.build(),
            startedAt: startedAt,
            timerEndsAt: timerEndsAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptedBy';
        acceptedBy.build();

        _$failedField = 'missedBy';
        missedBy.build();
        _$failedField = 'participants';
        participants.build();
        _$failedField = 'participantsCountByRole';
        participantsCountByRole.build();
        _$failedField = 'rejectedBy';
        rejectedBy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSessionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
