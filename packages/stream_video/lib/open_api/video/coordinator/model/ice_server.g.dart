// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_server.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ICEServer extends ICEServer {
  @override
  final String password;
  @override
  final BuiltList<String> urls;
  @override
  final String username;

  factory _$ICEServer([void Function(ICEServerBuilder)? updates]) =>
      (ICEServerBuilder()..update(updates))._build();

  _$ICEServer._(
      {required this.password, required this.urls, required this.username})
      : super._();
  @override
  ICEServer rebuild(void Function(ICEServerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ICEServerBuilder toBuilder() => ICEServerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ICEServer &&
        password == other.password &&
        urls == other.urls &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, urls.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ICEServer')
          ..add('password', password)
          ..add('urls', urls)
          ..add('username', username))
        .toString();
  }
}

class ICEServerBuilder implements Builder<ICEServer, ICEServerBuilder> {
  _$ICEServer? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  ListBuilder<String>? _urls;
  ListBuilder<String> get urls => _$this._urls ??= ListBuilder<String>();
  set urls(ListBuilder<String>? urls) => _$this._urls = urls;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  ICEServerBuilder() {
    ICEServer._defaults(this);
  }

  ICEServerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _urls = $v.urls.toBuilder();
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ICEServer other) {
    _$v = other as _$ICEServer;
  }

  @override
  void update(void Function(ICEServerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ICEServer build() => _build();

  _$ICEServer _build() {
    _$ICEServer _$result;
    try {
      _$result = _$v ??
          _$ICEServer._(
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'ICEServer', 'password'),
            urls: urls.build(),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'ICEServer', 'username'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'urls';
        urls.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ICEServer', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
