// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_muted_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserMutedEvent extends UserMutedEvent {
  @override
  final DateTime createdAt;
  @override
  final String? targetUser;
  @override
  final BuiltList<String>? targetUsers;
  @override
  final String type;
  @override
  final User? user;

  factory _$UserMutedEvent([void Function(UserMutedEventBuilder)? updates]) =>
      (UserMutedEventBuilder()..update(updates))._build();

  _$UserMutedEvent._(
      {required this.createdAt,
      this.targetUser,
      this.targetUsers,
      required this.type,
      this.user})
      : super._();
  @override
  UserMutedEvent rebuild(void Function(UserMutedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserMutedEventBuilder toBuilder() => UserMutedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserMutedEvent &&
        createdAt == other.createdAt &&
        targetUser == other.targetUser &&
        targetUsers == other.targetUsers &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, targetUser.hashCode);
    _$hash = $jc(_$hash, targetUsers.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserMutedEvent')
          ..add('createdAt', createdAt)
          ..add('targetUser', targetUser)
          ..add('targetUsers', targetUsers)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UserMutedEventBuilder
    implements Builder<UserMutedEvent, UserMutedEventBuilder> {
  _$UserMutedEvent? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _targetUser;
  String? get targetUser => _$this._targetUser;
  set targetUser(String? targetUser) => _$this._targetUser = targetUser;

  ListBuilder<String>? _targetUsers;
  ListBuilder<String> get targetUsers =>
      _$this._targetUsers ??= ListBuilder<String>();
  set targetUsers(ListBuilder<String>? targetUsers) =>
      _$this._targetUsers = targetUsers;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  UserMutedEventBuilder() {
    UserMutedEvent._defaults(this);
  }

  UserMutedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _targetUser = $v.targetUser;
      _targetUsers = $v.targetUsers?.toBuilder();
      _type = $v.type;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserMutedEvent other) {
    _$v = other as _$UserMutedEvent;
  }

  @override
  void update(void Function(UserMutedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserMutedEvent build() => _build();

  _$UserMutedEvent _build() {
    _$UserMutedEvent _$result;
    try {
      _$result = _$v ??
          _$UserMutedEvent._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserMutedEvent', 'createdAt'),
            targetUser: targetUser,
            targetUsers: _targetUsers?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UserMutedEvent', 'type'),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'targetUsers';
        _targetUsers?.build();

        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserMutedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
