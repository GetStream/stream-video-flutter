// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'fold_layout_style.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamFoldLayoutStyle {
  bool get canMerge => true;

  static StreamFoldLayoutStyle? lerp(
    StreamFoldLayoutStyle? a,
    StreamFoldLayoutStyle? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return StreamFoldLayoutStyle(
      foldGap: lerpDouble$(a.foldGap, b.foldGap, t),
      minTileSize: Size.lerp(a.minTileSize, b.minTileSize, t),
      avoidFold: t < 0.5 ? a.avoidFold : b.avoidFold,
      centerOnFold: t < 0.5 ? a.centerOnFold : b.centerOnFold,
    );
  }

  StreamFoldLayoutStyle copyWith({
    double? foldGap,
    Size? minTileSize,
    bool? avoidFold,
    bool? centerOnFold,
  }) {
    final _this = (this as StreamFoldLayoutStyle);

    return StreamFoldLayoutStyle(
      foldGap: foldGap ?? _this.foldGap,
      minTileSize: minTileSize ?? _this.minTileSize,
      avoidFold: avoidFold ?? _this.avoidFold,
      centerOnFold: centerOnFold ?? _this.centerOnFold,
    );
  }

  StreamFoldLayoutStyle merge(StreamFoldLayoutStyle? other) {
    final _this = (this as StreamFoldLayoutStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      foldGap: other.foldGap,
      minTileSize: other.minTileSize,
      avoidFold: other.avoidFold,
      centerOnFold: other.centerOnFold,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamFoldLayoutStyle);
    final _other = (other as StreamFoldLayoutStyle);

    return _other.foldGap == _this.foldGap &&
        _other.minTileSize == _this.minTileSize &&
        _other.avoidFold == _this.avoidFold &&
        _other.centerOnFold == _this.centerOnFold;
  }

  @override
  int get hashCode {
    final _this = (this as StreamFoldLayoutStyle);

    return Object.hash(
      runtimeType,
      _this.foldGap,
      _this.minTileSize,
      _this.avoidFold,
      _this.centerOnFold,
    );
  }
}
