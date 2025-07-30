// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_resolution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TargetResolution extends TargetResolution {
  @override
  final int? bitrate;
  @override
  final int height;
  @override
  final int width;

  factory _$TargetResolution(
          [void Function(TargetResolutionBuilder)? updates]) =>
      (TargetResolutionBuilder()..update(updates))._build();

  _$TargetResolution._(
      {this.bitrate, required this.height, required this.width})
      : super._();
  @override
  TargetResolution rebuild(void Function(TargetResolutionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TargetResolutionBuilder toBuilder() =>
      TargetResolutionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TargetResolution &&
        bitrate == other.bitrate &&
        height == other.height &&
        width == other.width;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bitrate.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TargetResolution')
          ..add('bitrate', bitrate)
          ..add('height', height)
          ..add('width', width))
        .toString();
  }
}

class TargetResolutionBuilder
    implements Builder<TargetResolution, TargetResolutionBuilder> {
  _$TargetResolution? _$v;

  int? _bitrate;
  int? get bitrate => _$this._bitrate;
  set bitrate(int? bitrate) => _$this._bitrate = bitrate;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  TargetResolutionBuilder() {
    TargetResolution._defaults(this);
  }

  TargetResolutionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bitrate = $v.bitrate;
      _height = $v.height;
      _width = $v.width;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TargetResolution other) {
    _$v = other as _$TargetResolution;
  }

  @override
  void update(void Function(TargetResolutionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TargetResolution build() => _build();

  _$TargetResolution _build() {
    final _$result = _$v ??
        _$TargetResolution._(
          bitrate: bitrate,
          height: BuiltValueNullFieldError.checkNotNull(
              height, r'TargetResolution', 'height'),
          width: BuiltValueNullFieldError.checkNotNull(
              width, r'TargetResolution', 'width'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
