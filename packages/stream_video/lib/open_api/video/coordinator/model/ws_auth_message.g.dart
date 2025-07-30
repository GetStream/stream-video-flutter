// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_auth_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WSAuthMessage extends WSAuthMessage {
  @override
  final BuiltList<String>? products;
  @override
  final String token;
  @override
  final ConnectUserDetailsRequest userDetails;

  factory _$WSAuthMessage([void Function(WSAuthMessageBuilder)? updates]) =>
      (WSAuthMessageBuilder()..update(updates))._build();

  _$WSAuthMessage._(
      {this.products, required this.token, required this.userDetails})
      : super._();
  @override
  WSAuthMessage rebuild(void Function(WSAuthMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WSAuthMessageBuilder toBuilder() => WSAuthMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WSAuthMessage &&
        products == other.products &&
        token == other.token &&
        userDetails == other.userDetails;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, userDetails.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WSAuthMessage')
          ..add('products', products)
          ..add('token', token)
          ..add('userDetails', userDetails))
        .toString();
  }
}

class WSAuthMessageBuilder
    implements Builder<WSAuthMessage, WSAuthMessageBuilder> {
  _$WSAuthMessage? _$v;

  ListBuilder<String>? _products;
  ListBuilder<String> get products =>
      _$this._products ??= ListBuilder<String>();
  set products(ListBuilder<String>? products) => _$this._products = products;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  ConnectUserDetailsRequestBuilder? _userDetails;
  ConnectUserDetailsRequestBuilder get userDetails =>
      _$this._userDetails ??= ConnectUserDetailsRequestBuilder();
  set userDetails(ConnectUserDetailsRequestBuilder? userDetails) =>
      _$this._userDetails = userDetails;

  WSAuthMessageBuilder() {
    WSAuthMessage._defaults(this);
  }

  WSAuthMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _products = $v.products?.toBuilder();
      _token = $v.token;
      _userDetails = $v.userDetails.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WSAuthMessage other) {
    _$v = other as _$WSAuthMessage;
  }

  @override
  void update(void Function(WSAuthMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WSAuthMessage build() => _build();

  _$WSAuthMessage _build() {
    _$WSAuthMessage _$result;
    try {
      _$result = _$v ??
          _$WSAuthMessage._(
            products: _products?.build(),
            token: BuiltValueNullFieldError.checkNotNull(
                token, r'WSAuthMessage', 'token'),
            userDetails: userDetails.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'products';
        _products?.build();

        _$failedField = 'userDetails';
        userDetails.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WSAuthMessage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
