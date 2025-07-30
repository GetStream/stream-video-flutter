// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_updated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserUpdatedEvent extends UserUpdatedEvent {
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? receivedAt;
  @override
  final String type;
  @override
  final UserResponsePrivacyFields user;

  factory _$UserUpdatedEvent(
          [void Function(UserUpdatedEventBuilder)? updates]) =>
      (UserUpdatedEventBuilder()..update(updates))._build();

  _$UserUpdatedEvent._(
      {required this.createdAt,
      required this.custom,
      this.receivedAt,
      required this.type,
      required this.user})
      : super._();
  @override
  UserUpdatedEvent rebuild(void Function(UserUpdatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserUpdatedEventBuilder toBuilder() =>
      UserUpdatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserUpdatedEvent &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        receivedAt == other.receivedAt &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserUpdatedEvent')
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('receivedAt', receivedAt)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UserUpdatedEventBuilder
    implements Builder<UserUpdatedEvent, UserUpdatedEventBuilder> {
  _$UserUpdatedEvent? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(DateTime? receivedAt) => _$this._receivedAt = receivedAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponsePrivacyFieldsBuilder? _user;
  UserResponsePrivacyFieldsBuilder get user =>
      _$this._user ??= UserResponsePrivacyFieldsBuilder();
  set user(UserResponsePrivacyFieldsBuilder? user) => _$this._user = user;

  UserUpdatedEventBuilder() {
    UserUpdatedEvent._defaults(this);
  }

  UserUpdatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _receivedAt = $v.receivedAt;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserUpdatedEvent other) {
    _$v = other as _$UserUpdatedEvent;
  }

  @override
  void update(void Function(UserUpdatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserUpdatedEvent build() => _build();

  _$UserUpdatedEvent _build() {
    _$UserUpdatedEvent _$result;
    try {
      _$result = _$v ??
          _$UserUpdatedEvent._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserUpdatedEvent', 'createdAt'),
            custom: custom.build(),
            receivedAt: receivedAt,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UserUpdatedEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserUpdatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
