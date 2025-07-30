// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_permissions_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateUserPermissionsRequest extends UpdateUserPermissionsRequest {
  @override
  final BuiltList<String>? grantPermissions;
  @override
  final BuiltList<String>? revokePermissions;
  @override
  final String userId;

  factory _$UpdateUserPermissionsRequest(
          [void Function(UpdateUserPermissionsRequestBuilder)? updates]) =>
      (UpdateUserPermissionsRequestBuilder()..update(updates))._build();

  _$UpdateUserPermissionsRequest._(
      {this.grantPermissions, this.revokePermissions, required this.userId})
      : super._();
  @override
  UpdateUserPermissionsRequest rebuild(
          void Function(UpdateUserPermissionsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateUserPermissionsRequestBuilder toBuilder() =>
      UpdateUserPermissionsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateUserPermissionsRequest &&
        grantPermissions == other.grantPermissions &&
        revokePermissions == other.revokePermissions &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, grantPermissions.hashCode);
    _$hash = $jc(_$hash, revokePermissions.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateUserPermissionsRequest')
          ..add('grantPermissions', grantPermissions)
          ..add('revokePermissions', revokePermissions)
          ..add('userId', userId))
        .toString();
  }
}

class UpdateUserPermissionsRequestBuilder
    implements
        Builder<UpdateUserPermissionsRequest,
            UpdateUserPermissionsRequestBuilder> {
  _$UpdateUserPermissionsRequest? _$v;

  ListBuilder<String>? _grantPermissions;
  ListBuilder<String> get grantPermissions =>
      _$this._grantPermissions ??= ListBuilder<String>();
  set grantPermissions(ListBuilder<String>? grantPermissions) =>
      _$this._grantPermissions = grantPermissions;

  ListBuilder<String>? _revokePermissions;
  ListBuilder<String> get revokePermissions =>
      _$this._revokePermissions ??= ListBuilder<String>();
  set revokePermissions(ListBuilder<String>? revokePermissions) =>
      _$this._revokePermissions = revokePermissions;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  UpdateUserPermissionsRequestBuilder() {
    UpdateUserPermissionsRequest._defaults(this);
  }

  UpdateUserPermissionsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _grantPermissions = $v.grantPermissions?.toBuilder();
      _revokePermissions = $v.revokePermissions?.toBuilder();
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateUserPermissionsRequest other) {
    _$v = other as _$UpdateUserPermissionsRequest;
  }

  @override
  void update(void Function(UpdateUserPermissionsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateUserPermissionsRequest build() => _build();

  _$UpdateUserPermissionsRequest _build() {
    _$UpdateUserPermissionsRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateUserPermissionsRequest._(
            grantPermissions: _grantPermissions?.build(),
            revokePermissions: _revokePermissions?.build(),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'UpdateUserPermissionsRequest', 'userId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'grantPermissions';
        _grantPermissions?.build();
        _$failedField = 'revokePermissions';
        _revokePermissions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateUserPermissionsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
