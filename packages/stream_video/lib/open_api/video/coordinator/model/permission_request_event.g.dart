// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionRequestEvent extends PermissionRequestEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<String> permissions;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$PermissionRequestEvent(
          [void Function(PermissionRequestEventBuilder)? updates]) =>
      (PermissionRequestEventBuilder()..update(updates))._build();

  _$PermissionRequestEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.permissions,
      required this.type,
      required this.user})
      : super._();
  @override
  PermissionRequestEvent rebuild(
          void Function(PermissionRequestEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionRequestEventBuilder toBuilder() =>
      PermissionRequestEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionRequestEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        permissions == other.permissions &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionRequestEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('permissions', permissions)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class PermissionRequestEventBuilder
    implements Builder<PermissionRequestEvent, PermissionRequestEventBuilder> {
  _$PermissionRequestEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  PermissionRequestEventBuilder() {
    PermissionRequestEvent._defaults(this);
  }

  PermissionRequestEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _permissions = $v.permissions.toBuilder();
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionRequestEvent other) {
    _$v = other as _$PermissionRequestEvent;
  }

  @override
  void update(void Function(PermissionRequestEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionRequestEvent build() => _build();

  _$PermissionRequestEvent _build() {
    _$PermissionRequestEvent _$result;
    try {
      _$result = _$v ??
          _$PermissionRequestEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'PermissionRequestEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PermissionRequestEvent', 'createdAt'),
            permissions: permissions.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PermissionRequestEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PermissionRequestEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
