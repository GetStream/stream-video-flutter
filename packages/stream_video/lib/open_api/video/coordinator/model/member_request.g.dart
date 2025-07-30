// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberRequest extends MemberRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final String? role;
  @override
  final String userId;

  factory _$MemberRequest([void Function(MemberRequestBuilder)? updates]) =>
      (MemberRequestBuilder()..update(updates))._build();

  _$MemberRequest._({this.custom, this.role, required this.userId}) : super._();
  @override
  MemberRequest rebuild(void Function(MemberRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberRequestBuilder toBuilder() => MemberRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberRequest &&
        custom == other.custom &&
        role == other.role &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberRequest')
          ..add('custom', custom)
          ..add('role', role)
          ..add('userId', userId))
        .toString();
  }
}

class MemberRequestBuilder
    implements Builder<MemberRequest, MemberRequestBuilder> {
  _$MemberRequest? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  MemberRequestBuilder() {
    MemberRequest._defaults(this);
  }

  MemberRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _role = $v.role;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberRequest other) {
    _$v = other as _$MemberRequest;
  }

  @override
  void update(void Function(MemberRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberRequest build() => _build();

  _$MemberRequest _build() {
    _$MemberRequest _$result;
    try {
      _$result = _$v ??
          _$MemberRequest._(
            custom: _custom?.build(),
            role: role,
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'MemberRequest', 'userId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MemberRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
