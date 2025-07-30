// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sfu_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SFUResponse extends SFUResponse {
  @override
  final String edgeName;
  @override
  final String url;
  @override
  final String wsEndpoint;

  factory _$SFUResponse([void Function(SFUResponseBuilder)? updates]) =>
      (SFUResponseBuilder()..update(updates))._build();

  _$SFUResponse._(
      {required this.edgeName, required this.url, required this.wsEndpoint})
      : super._();
  @override
  SFUResponse rebuild(void Function(SFUResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SFUResponseBuilder toBuilder() => SFUResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SFUResponse &&
        edgeName == other.edgeName &&
        url == other.url &&
        wsEndpoint == other.wsEndpoint;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, edgeName.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, wsEndpoint.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SFUResponse')
          ..add('edgeName', edgeName)
          ..add('url', url)
          ..add('wsEndpoint', wsEndpoint))
        .toString();
  }
}

class SFUResponseBuilder implements Builder<SFUResponse, SFUResponseBuilder> {
  _$SFUResponse? _$v;

  String? _edgeName;
  String? get edgeName => _$this._edgeName;
  set edgeName(String? edgeName) => _$this._edgeName = edgeName;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _wsEndpoint;
  String? get wsEndpoint => _$this._wsEndpoint;
  set wsEndpoint(String? wsEndpoint) => _$this._wsEndpoint = wsEndpoint;

  SFUResponseBuilder() {
    SFUResponse._defaults(this);
  }

  SFUResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _edgeName = $v.edgeName;
      _url = $v.url;
      _wsEndpoint = $v.wsEndpoint;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SFUResponse other) {
    _$v = other as _$SFUResponse;
  }

  @override
  void update(void Function(SFUResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SFUResponse build() => _build();

  _$SFUResponse _build() {
    final _$result = _$v ??
        _$SFUResponse._(
          edgeName: BuiltValueNullFieldError.checkNotNull(
              edgeName, r'SFUResponse', 'edgeName'),
          url:
              BuiltValueNullFieldError.checkNotNull(url, r'SFUResponse', 'url'),
          wsEndpoint: BuiltValueNullFieldError.checkNotNull(
              wsEndpoint, r'SFUResponse', 'wsEndpoint'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
