// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JoinCallResponse extends JoinCallResponse {
  @override
  final CallResponse call;
  @override
  final bool created;
  @override
  final Credentials credentials;
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final MemberResponse? membership;
  @override
  final BuiltList<OwnCapability> ownCapabilities;
  @override
  final StatsOptions statsOptions;

  factory _$JoinCallResponse(
          [void Function(JoinCallResponseBuilder)? updates]) =>
      (JoinCallResponseBuilder()..update(updates))._build();

  _$JoinCallResponse._(
      {required this.call,
      required this.created,
      required this.credentials,
      required this.duration,
      required this.members,
      this.membership,
      required this.ownCapabilities,
      required this.statsOptions})
      : super._();
  @override
  JoinCallResponse rebuild(void Function(JoinCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinCallResponseBuilder toBuilder() =>
      JoinCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinCallResponse &&
        call == other.call &&
        created == other.created &&
        credentials == other.credentials &&
        duration == other.duration &&
        members == other.members &&
        membership == other.membership &&
        ownCapabilities == other.ownCapabilities &&
        statsOptions == other.statsOptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jc(_$hash, statsOptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JoinCallResponse')
          ..add('call', call)
          ..add('created', created)
          ..add('credentials', credentials)
          ..add('duration', duration)
          ..add('members', members)
          ..add('membership', membership)
          ..add('ownCapabilities', ownCapabilities)
          ..add('statsOptions', statsOptions))
        .toString();
  }
}

class JoinCallResponseBuilder
    implements Builder<JoinCallResponse, JoinCallResponseBuilder> {
  _$JoinCallResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  bool? _created;
  bool? get created => _$this._created;
  set created(bool? created) => _$this._created = created;

  CredentialsBuilder? _credentials;
  CredentialsBuilder get credentials =>
      _$this._credentials ??= CredentialsBuilder();
  set credentials(CredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

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

  StatsOptionsBuilder? _statsOptions;
  StatsOptionsBuilder get statsOptions =>
      _$this._statsOptions ??= StatsOptionsBuilder();
  set statsOptions(StatsOptionsBuilder? statsOptions) =>
      _$this._statsOptions = statsOptions;

  JoinCallResponseBuilder() {
    JoinCallResponse._defaults(this);
  }

  JoinCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _created = $v.created;
      _credentials = $v.credentials.toBuilder();
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _membership = $v.membership?.toBuilder();
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _statsOptions = $v.statsOptions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinCallResponse other) {
    _$v = other as _$JoinCallResponse;
  }

  @override
  void update(void Function(JoinCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JoinCallResponse build() => _build();

  _$JoinCallResponse _build() {
    _$JoinCallResponse _$result;
    try {
      _$result = _$v ??
          _$JoinCallResponse._(
            call: call.build(),
            created: BuiltValueNullFieldError.checkNotNull(
                created, r'JoinCallResponse', 'created'),
            credentials: credentials.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'JoinCallResponse', 'duration'),
            members: members.build(),
            membership: _membership?.build(),
            ownCapabilities: ownCapabilities.build(),
            statsOptions: statsOptions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'credentials';
        credentials.build();

        _$failedField = 'members';
        members.build();
        _$failedField = 'membership';
        _membership?.build();
        _$failedField = 'ownCapabilities';
        ownCapabilities.build();
        _$failedField = 'statsOptions';
        statsOptions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JoinCallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
