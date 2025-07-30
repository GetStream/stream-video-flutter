// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_hls_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EgressHLSResponse extends EgressHLSResponse {
  @override
  final String playlistUrl;
  @override
  final String status;

  factory _$EgressHLSResponse(
          [void Function(EgressHLSResponseBuilder)? updates]) =>
      (EgressHLSResponseBuilder()..update(updates))._build();

  _$EgressHLSResponse._({required this.playlistUrl, required this.status})
      : super._();
  @override
  EgressHLSResponse rebuild(void Function(EgressHLSResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EgressHLSResponseBuilder toBuilder() =>
      EgressHLSResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EgressHLSResponse &&
        playlistUrl == other.playlistUrl &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, playlistUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EgressHLSResponse')
          ..add('playlistUrl', playlistUrl)
          ..add('status', status))
        .toString();
  }
}

class EgressHLSResponseBuilder
    implements Builder<EgressHLSResponse, EgressHLSResponseBuilder> {
  _$EgressHLSResponse? _$v;

  String? _playlistUrl;
  String? get playlistUrl => _$this._playlistUrl;
  set playlistUrl(String? playlistUrl) => _$this._playlistUrl = playlistUrl;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  EgressHLSResponseBuilder() {
    EgressHLSResponse._defaults(this);
  }

  EgressHLSResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _playlistUrl = $v.playlistUrl;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EgressHLSResponse other) {
    _$v = other as _$EgressHLSResponse;
  }

  @override
  void update(void Function(EgressHLSResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EgressHLSResponse build() => _build();

  _$EgressHLSResponse _build() {
    final _$result = _$v ??
        _$EgressHLSResponse._(
          playlistUrl: BuiltValueNullFieldError.checkNotNull(
              playlistUrl, r'EgressHLSResponse', 'playlistUrl'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'EgressHLSResponse', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
