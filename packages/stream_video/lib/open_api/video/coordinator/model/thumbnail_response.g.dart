// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ThumbnailResponse extends ThumbnailResponse {
  @override
  final String imageUrl;

  factory _$ThumbnailResponse(
          [void Function(ThumbnailResponseBuilder)? updates]) =>
      (ThumbnailResponseBuilder()..update(updates))._build();

  _$ThumbnailResponse._({required this.imageUrl}) : super._();
  @override
  ThumbnailResponse rebuild(void Function(ThumbnailResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThumbnailResponseBuilder toBuilder() =>
      ThumbnailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThumbnailResponse && imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ThumbnailResponse')
          ..add('imageUrl', imageUrl))
        .toString();
  }
}

class ThumbnailResponseBuilder
    implements Builder<ThumbnailResponse, ThumbnailResponseBuilder> {
  _$ThumbnailResponse? _$v;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  ThumbnailResponseBuilder() {
    ThumbnailResponse._defaults(this);
  }

  ThumbnailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _imageUrl = $v.imageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThumbnailResponse other) {
    _$v = other as _$ThumbnailResponse;
  }

  @override
  void update(void Function(ThumbnailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThumbnailResponse build() => _build();

  _$ThumbnailResponse _build() {
    final _$result = _$v ??
        _$ThumbnailResponse._(
          imageUrl: BuiltValueNullFieldError.checkNotNull(
              imageUrl, r'ThumbnailResponse', 'imageUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
