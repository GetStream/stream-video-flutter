// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reactivated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserReactivatedEvent extends UserReactivatedEvent {
  @override
  final DateTime createdAt;
  @override
  final String type;
  @override
  final User? user;

  factory _$UserReactivatedEvent(
          [void Function(UserReactivatedEventBuilder)? updates]) =>
      (UserReactivatedEventBuilder()..update(updates))._build();

  _$UserReactivatedEvent._(
      {required this.createdAt, required this.type, this.user})
      : super._();
  @override
  UserReactivatedEvent rebuild(
          void Function(UserReactivatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserReactivatedEventBuilder toBuilder() =>
      UserReactivatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserReactivatedEvent &&
        createdAt == other.createdAt &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserReactivatedEvent')
          ..add('createdAt', createdAt)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UserReactivatedEventBuilder
    implements Builder<UserReactivatedEvent, UserReactivatedEventBuilder> {
  _$UserReactivatedEvent? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  UserReactivatedEventBuilder() {
    UserReactivatedEvent._defaults(this);
  }

  UserReactivatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _type = $v.type;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserReactivatedEvent other) {
    _$v = other as _$UserReactivatedEvent;
  }

  @override
  void update(void Function(UserReactivatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserReactivatedEvent build() => _build();

  _$UserReactivatedEvent _build() {
    _$UserReactivatedEvent _$result;
    try {
      _$result = _$v ??
          _$UserReactivatedEvent._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserReactivatedEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UserReactivatedEvent', 'type'),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserReactivatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
