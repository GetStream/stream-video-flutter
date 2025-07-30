// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_banned_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserBannedEvent extends UserBannedEvent {
  @override
  final String channelId;
  @override
  final String channelType;
  @override
  final String cid;
  @override
  final DateTime createdAt;
  @override
  final User createdBy;
  @override
  final DateTime? expiration;
  @override
  final String? reason;
  @override
  final bool shadow;
  @override
  final String? team;
  @override
  final String type;
  @override
  final User? user;

  factory _$UserBannedEvent([void Function(UserBannedEventBuilder)? updates]) =>
      (UserBannedEventBuilder()..update(updates))._build();

  _$UserBannedEvent._(
      {required this.channelId,
      required this.channelType,
      required this.cid,
      required this.createdAt,
      required this.createdBy,
      this.expiration,
      this.reason,
      required this.shadow,
      this.team,
      required this.type,
      this.user})
      : super._();
  @override
  UserBannedEvent rebuild(void Function(UserBannedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBannedEventBuilder toBuilder() => UserBannedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserBannedEvent &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        cid == other.cid &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        expiration == other.expiration &&
        reason == other.reason &&
        shadow == other.shadow &&
        team == other.team &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, cid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, expiration.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, shadow.hashCode);
    _$hash = $jc(_$hash, team.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserBannedEvent')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('cid', cid)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('expiration', expiration)
          ..add('reason', reason)
          ..add('shadow', shadow)
          ..add('team', team)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UserBannedEventBuilder
    implements Builder<UserBannedEvent, UserBannedEventBuilder> {
  _$UserBannedEvent? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  String? _channelType;
  String? get channelType => _$this._channelType;
  set channelType(String? channelType) => _$this._channelType = channelType;

  String? _cid;
  String? get cid => _$this._cid;
  set cid(String? cid) => _$this._cid = cid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  DateTime? _expiration;
  DateTime? get expiration => _$this._expiration;
  set expiration(DateTime? expiration) => _$this._expiration = expiration;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _shadow;
  bool? get shadow => _$this._shadow;
  set shadow(bool? shadow) => _$this._shadow = shadow;

  String? _team;
  String? get team => _$this._team;
  set team(String? team) => _$this._team = team;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  UserBannedEventBuilder() {
    UserBannedEvent._defaults(this);
  }

  UserBannedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _cid = $v.cid;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy.toBuilder();
      _expiration = $v.expiration;
      _reason = $v.reason;
      _shadow = $v.shadow;
      _team = $v.team;
      _type = $v.type;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserBannedEvent other) {
    _$v = other as _$UserBannedEvent;
  }

  @override
  void update(void Function(UserBannedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserBannedEvent build() => _build();

  _$UserBannedEvent _build() {
    _$UserBannedEvent _$result;
    try {
      _$result = _$v ??
          _$UserBannedEvent._(
            channelId: BuiltValueNullFieldError.checkNotNull(
                channelId, r'UserBannedEvent', 'channelId'),
            channelType: BuiltValueNullFieldError.checkNotNull(
                channelType, r'UserBannedEvent', 'channelType'),
            cid: BuiltValueNullFieldError.checkNotNull(
                cid, r'UserBannedEvent', 'cid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserBannedEvent', 'createdAt'),
            createdBy: createdBy.build(),
            expiration: expiration,
            reason: reason,
            shadow: BuiltValueNullFieldError.checkNotNull(
                shadow, r'UserBannedEvent', 'shadow'),
            team: team,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UserBannedEvent', 'type'),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        createdBy.build();

        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserBannedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
