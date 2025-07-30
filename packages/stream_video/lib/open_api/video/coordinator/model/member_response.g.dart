// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberResponse extends MemberResponse {
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? deletedAt;
  @override
  final String? role;
  @override
  final DateTime updatedAt;
  @override
  final UserResponse user;
  @override
  final String userId;

  factory _$MemberResponse([void Function(MemberResponseBuilder)? updates]) =>
      (MemberResponseBuilder()..update(updates))._build();

  _$MemberResponse._(
      {required this.createdAt,
      required this.custom,
      this.deletedAt,
      this.role,
      required this.updatedAt,
      required this.user,
      required this.userId})
      : super._();
  @override
  MemberResponse rebuild(void Function(MemberResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberResponseBuilder toBuilder() => MemberResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberResponse &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        deletedAt == other.deletedAt &&
        role == other.role &&
        updatedAt == other.updatedAt &&
        user == other.user &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberResponse')
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('deletedAt', deletedAt)
          ..add('role', role)
          ..add('updatedAt', updatedAt)
          ..add('user', user)
          ..add('userId', userId))
        .toString();
  }
}

class MemberResponseBuilder
    implements Builder<MemberResponse, MemberResponseBuilder> {
  _$MemberResponse? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  MemberResponseBuilder() {
    MemberResponse._defaults(this);
  }

  MemberResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _deletedAt = $v.deletedAt;
      _role = $v.role;
      _updatedAt = $v.updatedAt;
      _user = $v.user.toBuilder();
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberResponse other) {
    _$v = other as _$MemberResponse;
  }

  @override
  void update(void Function(MemberResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberResponse build() => _build();

  _$MemberResponse _build() {
    _$MemberResponse _$result;
    try {
      _$result = _$v ??
          _$MemberResponse._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'MemberResponse', 'createdAt'),
            custom: custom.build(),
            deletedAt: deletedAt,
            role: role,
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'MemberResponse', 'updatedAt'),
            user: user.build(),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'MemberResponse', 'userId'),
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
            r'MemberResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
