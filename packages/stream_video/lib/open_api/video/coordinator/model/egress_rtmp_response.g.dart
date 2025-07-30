// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_rtmp_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EgressRTMPResponse extends EgressRTMPResponse {
  @override
  final String name;
  @override
  final DateTime startedAt;
  @override
  final String? streamKey;
  @override
  final String? streamUrl;

  factory _$EgressRTMPResponse(
          [void Function(EgressRTMPResponseBuilder)? updates]) =>
      (EgressRTMPResponseBuilder()..update(updates))._build();

  _$EgressRTMPResponse._(
      {required this.name,
      required this.startedAt,
      this.streamKey,
      this.streamUrl})
      : super._();
  @override
  EgressRTMPResponse rebuild(
          void Function(EgressRTMPResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EgressRTMPResponseBuilder toBuilder() =>
      EgressRTMPResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EgressRTMPResponse &&
        name == other.name &&
        startedAt == other.startedAt &&
        streamKey == other.streamKey &&
        streamUrl == other.streamUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, streamKey.hashCode);
    _$hash = $jc(_$hash, streamUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EgressRTMPResponse')
          ..add('name', name)
          ..add('startedAt', startedAt)
          ..add('streamKey', streamKey)
          ..add('streamUrl', streamUrl))
        .toString();
  }
}

class EgressRTMPResponseBuilder
    implements Builder<EgressRTMPResponse, EgressRTMPResponseBuilder> {
  _$EgressRTMPResponse? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  String? _streamKey;
  String? get streamKey => _$this._streamKey;
  set streamKey(String? streamKey) => _$this._streamKey = streamKey;

  String? _streamUrl;
  String? get streamUrl => _$this._streamUrl;
  set streamUrl(String? streamUrl) => _$this._streamUrl = streamUrl;

  EgressRTMPResponseBuilder() {
    EgressRTMPResponse._defaults(this);
  }

  EgressRTMPResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _startedAt = $v.startedAt;
      _streamKey = $v.streamKey;
      _streamUrl = $v.streamUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EgressRTMPResponse other) {
    _$v = other as _$EgressRTMPResponse;
  }

  @override
  void update(void Function(EgressRTMPResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EgressRTMPResponse build() => _build();

  _$EgressRTMPResponse _build() {
    final _$result = _$v ??
        _$EgressRTMPResponse._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'EgressRTMPResponse', 'name'),
          startedAt: BuiltValueNullFieldError.checkNotNull(
              startedAt, r'EgressRTMPResponse', 'startedAt'),
          streamKey: streamKey,
          streamUrl: streamUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
