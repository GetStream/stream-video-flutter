// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserResponse extends UserResponse {
  @override
  final BuiltList<String> blockedUserIds;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? deactivatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String id;
  @override
  final String? image;
  @override
  final String language;
  @override
  final DateTime? lastActive;
  @override
  final String? name;
  @override
  final DateTime? revokeTokensIssuedBefore;
  @override
  final String role;
  @override
  final BuiltList<String> teams;
  @override
  final BuiltMap<String, String>? teamsRole;
  @override
  final DateTime updatedAt;

  factory _$UserResponse([void Function(UserResponseBuilder)? updates]) =>
      (UserResponseBuilder()..update(updates))._build();

  _$UserResponse._(
      {required this.blockedUserIds,
      required this.createdAt,
      required this.custom,
      this.deactivatedAt,
      this.deletedAt,
      required this.id,
      this.image,
      required this.language,
      this.lastActive,
      this.name,
      this.revokeTokensIssuedBefore,
      required this.role,
      required this.teams,
      this.teamsRole,
      required this.updatedAt})
      : super._();
  @override
  UserResponse rebuild(void Function(UserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserResponseBuilder toBuilder() => UserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserResponse &&
        blockedUserIds == other.blockedUserIds &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        deactivatedAt == other.deactivatedAt &&
        deletedAt == other.deletedAt &&
        id == other.id &&
        image == other.image &&
        language == other.language &&
        lastActive == other.lastActive &&
        name == other.name &&
        revokeTokensIssuedBefore == other.revokeTokensIssuedBefore &&
        role == other.role &&
        teams == other.teams &&
        teamsRole == other.teamsRole &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, blockedUserIds.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, deactivatedAt.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, lastActive.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
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
    return (newBuiltValueToStringHelper(r'UserResponse')
          ..add('blockedUserIds', blockedUserIds)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('deactivatedAt', deactivatedAt)
          ..add('deletedAt', deletedAt)
          ..add('id', id)
          ..add('image', image)
          ..add('language', language)
          ..add('lastActive', lastActive)
          ..add('name', name)
          ..add('revokeTokensIssuedBefore', revokeTokensIssuedBefore)
          ..add('role', role)
          ..add('teams', teams)
          ..add('teamsRole', teamsRole)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserResponseBuilder
    implements Builder<UserResponse, UserResponseBuilder> {
  _$UserResponse? _$v;

  ListBuilder<String>? _blockedUserIds;
  ListBuilder<String> get blockedUserIds =>
      _$this._blockedUserIds ??= ListBuilder<String>();
  set blockedUserIds(ListBuilder<String>? blockedUserIds) =>
      _$this._blockedUserIds = blockedUserIds;

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

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  DateTime? _lastActive;
  DateTime? get lastActive => _$this._lastActive;
  set lastActive(DateTime? lastActive) => _$this._lastActive = lastActive;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  UserResponseBuilder() {
    UserResponse._defaults(this);
  }

  UserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _blockedUserIds = $v.blockedUserIds.toBuilder();
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _deactivatedAt = $v.deactivatedAt;
      _deletedAt = $v.deletedAt;
      _id = $v.id;
      _image = $v.image;
      _language = $v.language;
      _lastActive = $v.lastActive;
      _name = $v.name;
      _revokeTokensIssuedBefore = $v.revokeTokensIssuedBefore;
      _role = $v.role;
      _teams = $v.teams.toBuilder();
      _teamsRole = $v.teamsRole?.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserResponse other) {
    _$v = other as _$UserResponse;
  }

  @override
  void update(void Function(UserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserResponse build() => _build();

  _$UserResponse _build() {
    _$UserResponse _$result;
    try {
      _$result = _$v ??
          _$UserResponse._(
            blockedUserIds: blockedUserIds.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserResponse', 'createdAt'),
            custom: custom.build(),
            deactivatedAt: deactivatedAt,
            deletedAt: deletedAt,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserResponse', 'id'),
            image: image,
            language: BuiltValueNullFieldError.checkNotNull(
                language, r'UserResponse', 'language'),
            lastActive: lastActive,
            name: name,
            revokeTokensIssuedBefore: revokeTokensIssuedBefore,
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'UserResponse', 'role'),
            teams: teams.build(),
            teamsRole: _teamsRole?.build(),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'UserResponse', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockedUserIds';
        blockedUserIds.build();

        _$failedField = 'custom';
        custom.build();

        _$failedField = 'teams';
        teams.build();
        _$failedField = 'teamsRole';
        _teamsRole?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
