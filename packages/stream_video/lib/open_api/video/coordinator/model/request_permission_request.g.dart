// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_permission_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RequestPermissionRequest extends RequestPermissionRequest {
  @override
  final BuiltList<String> permissions;

  factory _$RequestPermissionRequest(
          [void Function(RequestPermissionRequestBuilder)? updates]) =>
      (RequestPermissionRequestBuilder()..update(updates))._build();

  _$RequestPermissionRequest._({required this.permissions}) : super._();
  @override
  RequestPermissionRequest rebuild(
          void Function(RequestPermissionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestPermissionRequestBuilder toBuilder() =>
      RequestPermissionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestPermissionRequest &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RequestPermissionRequest')
          ..add('permissions', permissions))
        .toString();
  }
}

class RequestPermissionRequestBuilder
    implements
        Builder<RequestPermissionRequest, RequestPermissionRequestBuilder> {
  _$RequestPermissionRequest? _$v;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  RequestPermissionRequestBuilder() {
    RequestPermissionRequest._defaults(this);
  }

  RequestPermissionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RequestPermissionRequest other) {
    _$v = other as _$RequestPermissionRequest;
  }

  @override
  void update(void Function(RequestPermissionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestPermissionRequest build() => _build();

  _$RequestPermissionRequest _build() {
    _$RequestPermissionRequest _$result;
    try {
      _$result = _$v ??
          _$RequestPermissionRequest._(
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RequestPermissionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
