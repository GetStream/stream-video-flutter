// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'spectators_indicator_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamSpectatorsIndicatorThemeData {
  bool get canMerge => true;

  static StreamSpectatorsIndicatorThemeData? lerp(
    StreamSpectatorsIndicatorThemeData? a,
    StreamSpectatorsIndicatorThemeData? b,
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

    return StreamSpectatorsIndicatorThemeData(
      style: StreamSpectatorsIndicatorStyle.lerp(a.style, b.style, t),
    );
  }

  StreamSpectatorsIndicatorThemeData copyWith({
    StreamSpectatorsIndicatorStyle? style,
  }) {
    final _this = (this as StreamSpectatorsIndicatorThemeData);

    return StreamSpectatorsIndicatorThemeData(style: style ?? _this.style);
  }

  StreamSpectatorsIndicatorThemeData merge(
    StreamSpectatorsIndicatorThemeData? other,
  ) {
    final _this = (this as StreamSpectatorsIndicatorThemeData);

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

    final _this = (this as StreamSpectatorsIndicatorThemeData);
    final _other = (other as StreamSpectatorsIndicatorThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamSpectatorsIndicatorThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamSpectatorsIndicatorStyle {
  bool get canMerge => true;

  static StreamSpectatorsIndicatorStyle? lerp(
    StreamSpectatorsIndicatorStyle? a,
    StreamSpectatorsIndicatorStyle? b,
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

    return StreamSpectatorsIndicatorStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  StreamSpectatorsIndicatorStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? iconSize,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? iconColor,
    TextStyle? textStyle,
  }) {
    final _this = (this as StreamSpectatorsIndicatorStyle);

    return StreamSpectatorsIndicatorStyle(
      padding: padding ?? _this.padding,
      spacing: spacing ?? _this.spacing,
      iconSize: iconSize ?? _this.iconSize,
      borderRadius: borderRadius ?? _this.borderRadius,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      iconColor: iconColor ?? _this.iconColor,
      textStyle: textStyle ?? _this.textStyle,
    );
  }

  StreamSpectatorsIndicatorStyle merge(StreamSpectatorsIndicatorStyle? other) {
    final _this = (this as StreamSpectatorsIndicatorStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      spacing: other.spacing,
      iconSize: other.iconSize,
      borderRadius: other.borderRadius,
      backgroundColor: other.backgroundColor,
      iconColor: other.iconColor,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
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

    final _this = (this as StreamSpectatorsIndicatorStyle);
    final _other = (other as StreamSpectatorsIndicatorStyle);

    return _other.padding == _this.padding &&
        _other.spacing == _this.spacing &&
        _other.iconSize == _this.iconSize &&
        _other.borderRadius == _this.borderRadius &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.iconColor == _this.iconColor &&
        _other.textStyle == _this.textStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamSpectatorsIndicatorStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.spacing,
      _this.iconSize,
      _this.borderRadius,
      _this.backgroundColor,
      _this.iconColor,
      _this.textStyle,
    );
  }
}
