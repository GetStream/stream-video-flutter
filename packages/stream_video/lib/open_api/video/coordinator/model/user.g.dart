// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final DateTime? banExpires;
  @override
  final bool banned;
  @override
  final DateTime? createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? deactivatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String id;
  @override
  final bool? invisible;
  @override
  final String? language;
  @override
  final DateTime? lastActive;
  @override
  final DateTime? lastEngagedAt;
  @override
  final bool online;
  @override
  final PrivacySettings? privacySettings;
  @override
  final DateTime? revokeTokensIssuedBefore;
  @override
  final String role;
  @override
  final BuiltList<String>? teams;
  @override
  final BuiltMap<String, String> teamsRole;
  @override
  final DateTime? updatedAt;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (UserBuilder()..update(updates))._build();

  _$User._(
      {this.banExpires,
      required this.banned,
      this.createdAt,
      required this.custom,
      this.deactivatedAt,
      this.deletedAt,
      required this.id,
      this.invisible,
      this.language,
      this.lastActive,
      this.lastEngagedAt,
      required this.online,
      this.privacySettings,
      this.revokeTokensIssuedBefore,
      required this.role,
      this.teams,
      required this.teamsRole,
      this.updatedAt})
      : super._();
  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        banExpires == other.banExpires &&
        banned == other.banned &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        deactivatedAt == other.deactivatedAt &&
        deletedAt == other.deletedAt &&
        id == other.id &&
        invisible == other.invisible &&
        language == other.language &&
        lastActive == other.lastActive &&
        lastEngagedAt == other.lastEngagedAt &&
        online == other.online &&
        privacySettings == other.privacySettings &&
        revokeTokensIssuedBefore == other.revokeTokensIssuedBefore &&
        role == other.role &&
        teams == other.teams &&
        teamsRole == other.teamsRole &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, banExpires.hashCode);
    _$hash = $jc(_$hash, banned.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, deactivatedAt.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, invisible.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, lastActive.hashCode);
    _$hash = $jc(_$hash, lastEngagedAt.hashCode);
    _$hash = $jc(_$hash, online.hashCode);
    _$hash = $jc(_$hash, privacySettings.hashCode);
    _$hash = $jc(_$hash, revokeTokensIssuedBefore.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, teams.hashCode);
    _$hash = $jc(_$hash, teamsRole.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('banExpires', banExpires)
          ..add('banned', banned)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('deactivatedAt', deactivatedAt)
          ..add('deletedAt', deletedAt)
          ..add('id', id)
          ..add('invisible', invisible)
          ..add('language', language)
          ..add('lastActive', lastActive)
          ..add('lastEngagedAt', lastEngagedAt)
          ..add('online', online)
          ..add('privacySettings', privacySettings)
          ..add('revokeTokensIssuedBefore', revokeTokensIssuedBefore)
          ..add('role', role)
          ..add('teams', teams)
          ..add('teamsRole', teamsRole)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  DateTime? _banExpires;
  DateTime? get banExpires => _$this._banExpires;
  set banExpires(DateTime? banExpires) => _$this._banExpires = banExpires;

  bool? _banned;
  bool? get banned => _$this._banned;
  set banned(bool? banned) => _$this._banned = banned;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  DateTime? _deactivatedAt;
  DateTime? get deactivatedAt => _$this._deactivatedAt;
  set deactivatedAt(DateTime? deactivatedAt) =>
      _$this._deactivatedAt = deactivatedAt;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _invisible;
  bool? get invisible => _$this._invisible;
  set invisible(bool? invisible) => _$this._invisible = invisible;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  DateTime? _lastActive;
  DateTime? get lastActive => _$this._lastActive;
  set lastActive(DateTime? lastActive) => _$this._lastActive = lastActive;

  DateTime? _lastEngagedAt;
  DateTime? get lastEngagedAt => _$this._lastEngagedAt;
  set lastEngagedAt(DateTime? lastEngagedAt) =>
      _$this._lastEngagedAt = lastEngagedAt;

  bool? _online;
  bool? get online => _$this._online;
  set online(bool? online) => _$this._online = online;

  PrivacySettingsBuilder? _privacySettings;
  PrivacySettingsBuilder get privacySettings =>
      _$this._privacySettings ??= PrivacySettingsBuilder();
  set privacySettings(PrivacySettingsBuilder? privacySettings) =>
      _$this._privacySettings = privacySettings;

  DateTime? _revokeTokensIssuedBefore;
  DateTime? get revokeTokensIssuedBefore => _$this._revokeTokensIssuedBefore;
  set revokeTokensIssuedBefore(DateTime? revokeTokensIssuedBefore) =>
      _$this._revokeTokensIssuedBefore = revokeTokensIssuedBefore;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  ListBuilder<String>? _teams;
  ListBuilder<String> get teams => _$this._teams ??= ListBuilder<String>();
  set teams(ListBuilder<String>? teams) => _$this._teams = teams;

  MapBuilder<String, String>? _teamsRole;
  MapBuilder<String, String> get teamsRole =>
      _$this._teamsRole ??= MapBuilder<String, String>();
  set teamsRole(MapBuilder<String, String>? teamsRole) =>
      _$this._teamsRole = teamsRole;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserBuilder() {
    User._defaults(this);
  }

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _banExpires = $v.banExpires;
      _banned = $v.banned;
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _deactivatedAt = $v.deactivatedAt;
      _deletedAt = $v.deletedAt;
      _id = $v.id;
      _invisible = $v.invisible;
      _language = $v.language;
      _lastActive = $v.lastActive;
      _lastEngagedAt = $v.lastEngagedAt;
      _online = $v.online;
      _privacySettings = $v.privacySettings?.toBuilder();
      _revokeTokensIssuedBefore = $v.revokeTokensIssuedBefore;
      _role = $v.role;
      _teams = $v.teams?.toBuilder();
      _teamsRole = $v.teamsRole.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    _$User _$result;
    try {
      _$result = _$v ??
          _$User._(
            banExpires: banExpires,
            banned: BuiltValueNullFieldError.checkNotNull(
                banned, r'User', 'banned'),
            createdAt: createdAt,
            custom: custom.build(),
            deactivatedAt: deactivatedAt,
            deletedAt: deletedAt,
            id: BuiltValueNullFieldError.checkNotNull(id, r'User', 'id'),
            invisible: invisible,
            language: language,
            lastActive: lastActive,
            lastEngagedAt: lastEngagedAt,
            online: BuiltValueNullFieldError.checkNotNull(
                online, r'User', 'online'),
            privacySettings: _privacySettings?.build(),
            revokeTokensIssuedBefore: revokeTokensIssuedBefore,
            role: BuiltValueNullFieldError.checkNotNull(role, r'User', 'role'),
            teams: _teams?.build(),
            teamsRole: teamsRole.build(),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();

        _$failedField = 'privacySettings';
        _privacySettings?.build();

        _$failedField = 'teams';
        _teams?.build();
        _$failedField = 'teamsRole';
        teamsRole.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
