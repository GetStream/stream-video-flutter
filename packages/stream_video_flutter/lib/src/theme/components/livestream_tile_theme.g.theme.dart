// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'livestream_tile_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamLivestreamTileThemeData {
  bool get canMerge => true;

  static StreamLivestreamTileThemeData? lerp(
    StreamLivestreamTileThemeData? a,
    StreamLivestreamTileThemeData? b,
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

    return StreamLivestreamTileThemeData(
      style: StreamLivestreamTileStyle.lerp(a.style, b.style, t),
    );
  }

  StreamLivestreamTileThemeData copyWith({StreamLivestreamTileStyle? style}) {
    final _this = (this as StreamLivestreamTileThemeData);

    return StreamLivestreamTileThemeData(style: style ?? _this.style);
  }

  StreamLivestreamTileThemeData merge(StreamLivestreamTileThemeData? other) {
    final _this = (this as StreamLivestreamTileThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(style: _this.style?.merge(other.style) ?? other.style);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamLivestreamTileThemeData);
    final _other = (other as StreamLivestreamTileThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLivestreamTileThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamLivestreamTileStyle {
  bool get canMerge => true;

  static StreamLivestreamTileStyle? lerp(
    StreamLivestreamTileStyle? a,
    StreamLivestreamTileStyle? b,
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

    return StreamLivestreamTileStyle(
      toolbarPadding: EdgeInsetsGeometry.lerp(
        a.toolbarPadding,
        b.toolbarPadding,
        t,
      ),
      toolbarSpacing: lerpDouble$(a.toolbarSpacing, b.toolbarSpacing, t),
      leadingSpacing: lerpDouble$(a.leadingSpacing, b.leadingSpacing, t),
      trailingSpacing: lerpDouble$(a.trailingSpacing, b.trailingSpacing, t),
      buttonSize: t < 0.5 ? a.buttonSize : b.buttonSize,
    );
  }

  StreamLivestreamTileStyle copyWith({
    EdgeInsetsGeometry? toolbarPadding,
    double? toolbarSpacing,
    double? leadingSpacing,
    double? trailingSpacing,
    StreamButtonSize? buttonSize,
  }) {
    final _this = (this as StreamLivestreamTileStyle);

    return StreamLivestreamTileStyle(
      toolbarPadding: toolbarPadding ?? _this.toolbarPadding,
      toolbarSpacing: toolbarSpacing ?? _this.toolbarSpacing,
      leadingSpacing: leadingSpacing ?? _this.leadingSpacing,
      trailingSpacing: trailingSpacing ?? _this.trailingSpacing,
      buttonSize: buttonSize ?? _this.buttonSize,
    );
  }

  StreamLivestreamTileStyle merge(StreamLivestreamTileStyle? other) {
    final _this = (this as StreamLivestreamTileStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      toolbarPadding: other.toolbarPadding,
      toolbarSpacing: other.toolbarSpacing,
      leadingSpacing: other.leadingSpacing,
      trailingSpacing: other.trailingSpacing,
      buttonSize: other.buttonSize,
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

    final _this = (this as StreamLivestreamTileStyle);
    final _other = (other as StreamLivestreamTileStyle);

    return _other.toolbarPadding == _this.toolbarPadding &&
        _other.toolbarSpacing == _this.toolbarSpacing &&
        _other.leadingSpacing == _this.leadingSpacing &&
        _other.trailingSpacing == _this.trailingSpacing &&
        _other.buttonSize == _this.buttonSize;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLivestreamTileStyle);

    return Object.hash(
      runtimeType,
      _this.toolbarPadding,
      _this.toolbarSpacing,
      _this.leadingSpacing,
      _this.trailingSpacing,
      _this.buttonSize,
    );
  }
}
