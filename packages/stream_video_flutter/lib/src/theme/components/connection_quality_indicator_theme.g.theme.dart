// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'connection_quality_indicator_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamConnectionQualityIndicatorThemeData {
  bool get canMerge => true;

  static StreamConnectionQualityIndicatorThemeData? lerp(
    StreamConnectionQualityIndicatorThemeData? a,
    StreamConnectionQualityIndicatorThemeData? b,
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

    return StreamConnectionQualityIndicatorThemeData(
      style: StreamConnectionQualityIndicatorStyle.lerp(a.style, b.style, t),
    );
  }

  StreamConnectionQualityIndicatorThemeData copyWith({
    StreamConnectionQualityIndicatorStyle? style,
  }) {
    final _this = (this as StreamConnectionQualityIndicatorThemeData);

    return StreamConnectionQualityIndicatorThemeData(
      style: style ?? _this.style,
    );
  }

  StreamConnectionQualityIndicatorThemeData merge(
    StreamConnectionQualityIndicatorThemeData? other,
  ) {
    final _this = (this as StreamConnectionQualityIndicatorThemeData);

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

    final _this = (this as StreamConnectionQualityIndicatorThemeData);
    final _other = (other as StreamConnectionQualityIndicatorThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamConnectionQualityIndicatorThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamConnectionQualityIndicatorStyle {
  bool get canMerge => true;

  static StreamConnectionQualityIndicatorStyle? lerp(
    StreamConnectionQualityIndicatorStyle? a,
    StreamConnectionQualityIndicatorStyle? b,
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

    return StreamConnectionQualityIndicatorStyle(
      size: lerpDouble$(a.size, b.size, t),
      decoration: BoxDecoration.lerp(a.decoration, b.decoration, t),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      strokeWidth: lerpDouble$(a.strokeWidth, b.strokeWidth, t),
      poorColor: Color.lerp(a.poorColor, b.poorColor, t),
      fairColor: Color.lerp(a.fairColor, b.fairColor, t),
      greatColor: Color.lerp(a.greatColor, b.greatColor, t),
      inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t),
    );
  }

  StreamConnectionQualityIndicatorStyle copyWith({
    double? size,
    BoxDecoration? decoration,
    double? iconSize,
    double? strokeWidth,
    Color? poorColor,
    Color? fairColor,
    Color? greatColor,
    Color? inactiveColor,
  }) {
    final _this = (this as StreamConnectionQualityIndicatorStyle);

    return StreamConnectionQualityIndicatorStyle(
      size: size ?? _this.size,
      decoration: decoration ?? _this.decoration,
      iconSize: iconSize ?? _this.iconSize,
      strokeWidth: strokeWidth ?? _this.strokeWidth,
      poorColor: poorColor ?? _this.poorColor,
      fairColor: fairColor ?? _this.fairColor,
      greatColor: greatColor ?? _this.greatColor,
      inactiveColor: inactiveColor ?? _this.inactiveColor,
    );
  }

  StreamConnectionQualityIndicatorStyle merge(
    StreamConnectionQualityIndicatorStyle? other,
  ) {
    final _this = (this as StreamConnectionQualityIndicatorStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      size: other.size,
      decoration: other.decoration,
      iconSize: other.iconSize,
      strokeWidth: other.strokeWidth,
      poorColor: other.poorColor,
      fairColor: other.fairColor,
      greatColor: other.greatColor,
      inactiveColor: other.inactiveColor,
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

    final _this = (this as StreamConnectionQualityIndicatorStyle);
    final _other = (other as StreamConnectionQualityIndicatorStyle);

    return _other.size == _this.size &&
        _other.decoration == _this.decoration &&
        _other.iconSize == _this.iconSize &&
        _other.strokeWidth == _this.strokeWidth &&
        _other.poorColor == _this.poorColor &&
        _other.fairColor == _this.fairColor &&
        _other.greatColor == _this.greatColor &&
        _other.inactiveColor == _this.inactiveColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamConnectionQualityIndicatorStyle);

    return Object.hash(
      runtimeType,
      _this.size,
      _this.decoration,
      _this.iconSize,
      _this.strokeWidth,
      _this.poorColor,
      _this.fairColor,
      _this.greatColor,
      _this.inactiveColor,
    );
  }
}
