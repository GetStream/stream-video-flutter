// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_deactivated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserDeactivatedEvent extends UserDeactivatedEvent {
  @override
  final DateTime createdAt;
  @override
  final User createdBy;
  @override
  final String type;
  @override
  final User? user;

  factory _$UserDeactivatedEvent(
          [void Function(UserDeactivatedEventBuilder)? updates]) =>
      (UserDeactivatedEventBuilder()..update(updates))._build();

  _$UserDeactivatedEvent._(
      {required this.createdAt,
      required this.createdBy,
      required this.type,
      this.user})
      : super._();
  @override
  UserDeactivatedEvent rebuild(
          void Function(UserDeactivatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDeactivatedEventBuilder toBuilder() =>
      UserDeactivatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDeactivatedEvent &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserDeactivatedEvent')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UserDeactivatedEventBuilder
    implements Builder<UserDeactivatedEvent, UserDeactivatedEventBuilder> {
  _$UserDeactivatedEvent? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  UserDeactivatedEventBuilder() {
    UserDeactivatedEvent._defaults(this);
  }

  UserDeactivatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy.toBuilder();
      _type = $v.type;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDeactivatedEvent other) {
    _$v = other as _$UserDeactivatedEvent;
  }

  @override
  void update(void Function(UserDeactivatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserDeactivatedEvent build() => _build();

  _$UserDeactivatedEvent _build() {
    _$UserDeactivatedEvent _$result;
    try {
      _$result = _$v ??
          _$UserDeactivatedEvent._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserDeactivatedEvent', 'createdAt'),
            createdBy: createdBy.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UserDeactivatedEvent', 'type'),
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
            r'UserDeactivatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
