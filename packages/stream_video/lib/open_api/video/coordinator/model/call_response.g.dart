// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallResponse extends CallResponse {
  @override
  final bool backstage;
  @override
  final BuiltList<String> blockedUserIds;
  @override
  final bool captioning;
  @override
  final String? channelCid;
  @override
  final String cid;
  @override
  final DateTime createdAt;
  @override
  final UserResponse createdBy;
  @override
  final String currentSessionId;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final EgressResponse egress;
  @override
  final DateTime? endedAt;
  @override
  final String id;
  @override
  final CallIngressResponse ingress;
  @override
  final int? joinAheadTimeSeconds;
  @override
  final bool recording;
  @override
  final CallSessionResponse? session;
  @override
  final CallSettingsResponse settings;
  @override
  final DateTime? startsAt;
  @override
  final String? team;
  @override
  final ThumbnailResponse? thumbnails;
  @override
  final bool transcribing;
  @override
  final String type;
  @override
  final DateTime updatedAt;

  factory _$CallResponse([void Function(CallResponseBuilder)? updates]) =>
      (CallResponseBuilder()..update(updates))._build();

  _$CallResponse._(
      {required this.backstage,
      required this.blockedUserIds,
      required this.captioning,
      this.channelCid,
      required this.cid,
      required this.createdAt,
      required this.createdBy,
      required this.currentSessionId,
      required this.custom,
      required this.egress,
      this.endedAt,
      required this.id,
      required this.ingress,
      this.joinAheadTimeSeconds,
      required this.recording,
      this.session,
      required this.settings,
      this.startsAt,
      this.team,
      this.thumbnails,
      required this.transcribing,
      required this.type,
      required this.updatedAt})
      : super._();
  @override
  CallResponse rebuild(void Function(CallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallResponseBuilder toBuilder() => CallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallResponse &&
        backstage == other.backstage &&
        blockedUserIds == other.blockedUserIds &&
        captioning == other.captioning &&
        channelCid == other.channelCid &&
        cid == other.cid &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        currentSessionId == other.currentSessionId &&
        custom == other.custom &&
        egress == other.egress &&
        endedAt == other.endedAt &&
        id == other.id &&
        ingress == other.ingress &&
        joinAheadTimeSeconds == other.joinAheadTimeSeconds &&
        recording == other.recording &&
        session == other.session &&
        settings == other.settings &&
        startsAt == other.startsAt &&
        team == other.team &&
        thumbnails == other.thumbnails &&
        transcribing == other.transcribing &&
        type == other.type &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, backstage.hashCode);
    _$hash = $jc(_$hash, blockedUserIds.hashCode);
    _$hash = $jc(_$hash, captioning.hashCode);
    _$hash = $jc(_$hash, channelCid.hashCode);
    _$hash = $jc(_$hash, cid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, currentSessionId.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, egress.hashCode);
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ingress.hashCode);
    _$hash = $jc(_$hash, joinAheadTimeSeconds.hashCode);
    _$hash = $jc(_$hash, recording.hashCode);
    _$hash = $jc(_$hash, session.hashCode);
    _$hash = $jc(_$hash, settings.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, team.hashCode);
    _$hash = $jc(_$hash, thumbnails.hashCode);
    _$hash = $jc(_$hash, transcribing.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallResponse')
          ..add('backstage', backstage)
          ..add('blockedUserIds', blockedUserIds)
          ..add('captioning', captioning)
          ..add('channelCid', channelCid)
          ..add('cid', cid)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('currentSessionId', currentSessionId)
          ..add('custom', custom)
          ..add('egress', egress)
          ..add('endedAt', endedAt)
          ..add('id', id)
          ..add('ingress', ingress)
          ..add('joinAheadTimeSeconds', joinAheadTimeSeconds)
          ..add('recording', recording)
          ..add('session', session)
          ..add('settings', settings)
          ..add('startsAt', startsAt)
          ..add('team', team)
          ..add('thumbnails', thumbnails)
          ..add('transcribing', transcribing)
          ..add('type', type)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class CallResponseBuilder
    implements Builder<CallResponse, CallResponseBuilder> {
  _$CallResponse? _$v;

  bool? _backstage;
  bool? get backstage => _$this._backstage;
  set backstage(bool? backstage) => _$this._backstage = backstage;

  ListBuilder<String>? _blockedUserIds;
  ListBuilder<String> get blockedUserIds =>
      _$this._blockedUserIds ??= ListBuilder<String>();
  set blockedUserIds(ListBuilder<String>? blockedUserIds) =>
      _$this._blockedUserIds = blockedUserIds;

  bool? _captioning;
  bool? get captioning => _$this._captioning;
  set captioning(bool? captioning) => _$this._captioning = captioning;

  String? _channelCid;
  String? get channelCid => _$this._channelCid;
  set channelCid(String? channelCid) => _$this._channelCid = channelCid;

  String? _cid;
  String? get cid => _$this._cid;
  set cid(String? cid) => _$this._cid = cid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserResponseBuilder? _createdBy;
  UserResponseBuilder get createdBy =>
      _$this._createdBy ??= UserResponseBuilder();
  set createdBy(UserResponseBuilder? createdBy) =>
      _$this._createdBy = createdBy;

  String? _currentSessionId;
  String? get currentSessionId => _$this._currentSessionId;
  set currentSessionId(String? currentSessionId) =>
      _$this._currentSessionId = currentSessionId;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  EgressResponseBuilder? _egress;
  EgressResponseBuilder get egress =>
      _$this._egress ??= EgressResponseBuilder();
  set egress(EgressResponseBuilder? egress) => _$this._egress = egress;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CallIngressResponseBuilder? _ingress;
  CallIngressResponseBuilder get ingress =>
      _$this._ingress ??= CallIngressResponseBuilder();
  set ingress(CallIngressResponseBuilder? ingress) => _$this._ingress = ingress;

  int? _joinAheadTimeSeconds;
  int? get joinAheadTimeSeconds => _$this._joinAheadTimeSeconds;
  set joinAheadTimeSeconds(int? joinAheadTimeSeconds) =>
      _$this._joinAheadTimeSeconds = joinAheadTimeSeconds;

  bool? _recording;
  bool? get recording => _$this._recording;
  set recording(bool? recording) => _$this._recording = recording;

  CallSessionResponseBuilder? _session;
  CallSessionResponseBuilder get session =>
      _$this._session ??= CallSessionResponseBuilder();
  set session(CallSessionResponseBuilder? session) => _$this._session = session;

  CallSettingsResponseBuilder? _settings;
  CallSettingsResponseBuilder get settings =>
      _$this._settings ??= CallSettingsResponseBuilder();
  set settings(CallSettingsResponseBuilder? settings) =>
      _$this._settings = settings;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _team;
  String? get team => _$this._team;
  set team(String? team) => _$this._team = team;

  ThumbnailResponseBuilder? _thumbnails;
  ThumbnailResponseBuilder get thumbnails =>
      _$this._thumbnails ??= ThumbnailResponseBuilder();
  set thumbnails(ThumbnailResponseBuilder? thumbnails) =>
      _$this._thumbnails = thumbnails;

  bool? _transcribing;
  bool? get transcribing => _$this._transcribing;
  set transcribing(bool? transcribing) => _$this._transcribing = transcribing;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  CallResponseBuilder() {
    CallResponse._defaults(this);
  }

  CallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _backstage = $v.backstage;
      _blockedUserIds = $v.blockedUserIds.toBuilder();
      _captioning = $v.captioning;
      _channelCid = $v.channelCid;
      _cid = $v.cid;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy.toBuilder();
      _currentSessionId = $v.currentSessionId;
      _custom = $v.custom.toBuilder();
      _egress = $v.egress.toBuilder();
      _endedAt = $v.endedAt;
      _id = $v.id;
      _ingress = $v.ingress.toBuilder();
      _joinAheadTimeSeconds = $v.joinAheadTimeSeconds;
      _recording = $v.recording;
      _session = $v.session?.toBuilder();
      _settings = $v.settings.toBuilder();
      _startsAt = $v.startsAt;
      _team = $v.team;
      _thumbnails = $v.thumbnails?.toBuilder();
      _transcribing = $v.transcribing;
      _type = $v.type;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallResponse other) {
    _$v = other as _$CallResponse;
  }

  @override
  void update(void Function(CallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallResponse build() => _build();

  _$CallResponse _build() {
    _$CallResponse _$result;
    try {
      _$result = _$v ??
          _$CallResponse._(
            backstage: BuiltValueNullFieldError.checkNotNull(
                backstage, r'CallResponse', 'backstage'),
            blockedUserIds: blockedUserIds.build(),
            captioning: BuiltValueNullFieldError.checkNotNull(
                captioning, r'CallResponse', 'captioning'),
            channelCid: channelCid,
            cid: BuiltValueNullFieldError.checkNotNull(
                cid, r'CallResponse', 'cid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallResponse', 'createdAt'),
            createdBy: createdBy.build(),
            currentSessionId: BuiltValueNullFieldError.checkNotNull(
                currentSessionId, r'CallResponse', 'currentSessionId'),
            custom: custom.build(),
            egress: egress.build(),
            endedAt: endedAt,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CallResponse', 'id'),
            ingress: ingress.build(),
            joinAheadTimeSeconds: joinAheadTimeSeconds,
            recording: BuiltValueNullFieldError.checkNotNull(
                recording, r'CallResponse', 'recording'),
            session: _session?.build(),
            settings: settings.build(),
            startsAt: startsAt,
            team: team,
            thumbnails: _thumbnails?.build(),
            transcribing: BuiltValueNullFieldError.checkNotNull(
                transcribing, r'CallResponse', 'transcribing'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallResponse', 'type'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'CallResponse', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockedUserIds';
        blockedUserIds.build();

        _$failedField = 'createdBy';
        createdBy.build();

        _$failedField = 'custom';
        custom.build();
        _$failedField = 'egress';
        egress.build();

        _$failedField = 'ingress';
        ingress.build();

        _$failedField = 'session';
        _session?.build();
        _$failedField = 'settings';
        settings.build();

        _$failedField = 'thumbnails';
        _thumbnails?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
