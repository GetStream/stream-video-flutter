// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_participants_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallParticipantsResponse extends QueryCallParticipantsResponse {
  @override
  final CallResponse call;
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final MemberResponse? membership;
  @override
  final BuiltList<OwnCapability> ownCapabilities;
  @override
  final BuiltList<CallParticipantResponse> participants;
  @override
  final int totalParticipants;

  factory _$QueryCallParticipantsResponse(
          [void Function(QueryCallParticipantsResponseBuilder)? updates]) =>
      (QueryCallParticipantsResponseBuilder()..update(updates))._build();

  _$QueryCallParticipantsResponse._(
      {required this.call,
      required this.duration,
      required this.members,
      this.membership,
      required this.ownCapabilities,
      required this.participants,
      required this.totalParticipants})
      : super._();
  @override
  QueryCallParticipantsResponse rebuild(
          void Function(QueryCallParticipantsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallParticipantsResponseBuilder toBuilder() =>
      QueryCallParticipantsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallParticipantsResponse &&
        call == other.call &&
        duration == other.duration &&
        members == other.members &&
        membership == other.membership &&
        ownCapabilities == other.ownCapabilities &&
        participants == other.participants &&
        totalParticipants == other.totalParticipants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jc(_$hash, totalParticipants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallParticipantsResponse')
          ..add('call', call)
          ..add('duration', duration)
          ..add('members', members)
          ..add('membership', membership)
          ..add('ownCapabilities', ownCapabilities)
          ..add('participants', participants)
          ..add('totalParticipants', totalParticipants))
        .toString();
  }
}

class QueryCallParticipantsResponseBuilder
    implements
        Builder<QueryCallParticipantsResponse,
            QueryCallParticipantsResponseBuilder> {
  _$QueryCallParticipantsResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  MemberResponseBuilder? _membership;
  MemberResponseBuilder get membership =>
      _$this._membership ??= MemberResponseBuilder();
  set membership(MemberResponseBuilder? membership) =>
      _$this._membership = membership;

  ListBuilder<OwnCapability>? _ownCapabilities;
  ListBuilder<OwnCapability> get ownCapabilities =>
      _$this._ownCapabilities ??= ListBuilder<OwnCapability>();
  set ownCapabilities(ListBuilder<OwnCapability>? ownCapabilities) =>
      _$this._ownCapabilities = ownCapabilities;

  ListBuilder<CallParticipantResponse>? _participants;
  ListBuilder<CallParticipantResponse> get participants =>
      _$this._participants ??= ListBuilder<CallParticipantResponse>();
  set participants(ListBuilder<CallParticipantResponse>? participants) =>
      _$this._participants = participants;

  int? _totalParticipants;
  int? get totalParticipants => _$this._totalParticipants;
  set totalParticipants(int? totalParticipants) =>
      _$this._totalParticipants = totalParticipants;

  QueryCallParticipantsResponseBuilder() {
    QueryCallParticipantsResponse._defaults(this);
  }

  QueryCallParticipantsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _membership = $v.membership?.toBuilder();
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _participants = $v.participants.toBuilder();
      _totalParticipants = $v.totalParticipants;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallParticipantsResponse other) {
    _$v = other as _$QueryCallParticipantsResponse;
  }

  @override
  void update(void Function(QueryCallParticipantsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallParticipantsResponse build() => _build();

  _$QueryCallParticipantsResponse _build() {
    _$QueryCallParticipantsResponse _$result;
    try {
      _$result = _$v ??
          _$QueryCallParticipantsResponse._(
            call: call.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'QueryCallParticipantsResponse', 'duration'),
            members: members.build(),
            membership: _membership?.build(),
            ownCapabilities: ownCapabilities.build(),
            participants: participants.build(),
            totalParticipants: BuiltValueNullFieldError.checkNotNull(
                totalParticipants,
                r'QueryCallParticipantsResponse',
                'totalParticipants'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'members';
        members.build();
        _$failedField = 'membership';
        _membership?.build();
        _$failedField = 'ownCapabilities';
        ownCapabilities.build();
        _$failedField = 'participants';
        participants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallParticipantsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
