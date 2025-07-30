// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Credentials extends Credentials {
  @override
  final BuiltList<ICEServer> iceServers;
  @override
  final SFUResponse server;
  @override
  final String token;

  factory _$Credentials([void Function(CredentialsBuilder)? updates]) =>
      (CredentialsBuilder()..update(updates))._build();

  _$Credentials._(
      {required this.iceServers, required this.server, required this.token})
      : super._();
  @override
  Credentials rebuild(void Function(CredentialsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CredentialsBuilder toBuilder() => CredentialsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Credentials &&
        iceServers == other.iceServers &&
        server == other.server &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, iceServers.hashCode);
    _$hash = $jc(_$hash, server.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Credentials')
          ..add('iceServers', iceServers)
          ..add('server', server)
          ..add('token', token))
        .toString();
  }
}

class CredentialsBuilder implements Builder<Credentials, CredentialsBuilder> {
  _$Credentials? _$v;

  ListBuilder<ICEServer>? _iceServers;
  ListBuilder<ICEServer> get iceServers =>
      _$this._iceServers ??= ListBuilder<ICEServer>();
  set iceServers(ListBuilder<ICEServer>? iceServers) =>
      _$this._iceServers = iceServers;

  SFUResponseBuilder? _server;
  SFUResponseBuilder get server => _$this._server ??= SFUResponseBuilder();
  set server(SFUResponseBuilder? server) => _$this._server = server;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  CredentialsBuilder() {
    Credentials._defaults(this);
  }

  CredentialsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _iceServers = $v.iceServers.toBuilder();
      _server = $v.server.toBuilder();
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Credentials other) {
    _$v = other as _$Credentials;
  }

  @override
  void update(void Function(CredentialsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Credentials build() => _build();

  _$Credentials _build() {
    _$Credentials _$result;
    try {
      _$result = _$v ??
          _$Credentials._(
            iceServers: iceServers.build(),
            server: server.build(),
            token: BuiltValueNullFieldError.checkNotNull(
                token, r'Credentials', 'token'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'iceServers';
        iceServers.build();
        _$failedField = 'server';
        server.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Credentials', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
