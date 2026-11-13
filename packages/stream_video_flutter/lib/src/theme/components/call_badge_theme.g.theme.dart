// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_badge_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallBadgeThemeData {
  bool get canMerge => true;

  static StreamCallBadgeThemeData? lerp(
    StreamCallBadgeThemeData? a,
    StreamCallBadgeThemeData? b,
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

    return StreamCallBadgeThemeData(
      style: StreamCallBadgeStyle.lerp(a.style, b.style, t),
    );
  }

  StreamCallBadgeThemeData copyWith({StreamCallBadgeStyle? style}) {
    final _this = (this as StreamCallBadgeThemeData);

    return StreamCallBadgeThemeData(style: style ?? _this.style);
  }

  StreamCallBadgeThemeData merge(StreamCallBadgeThemeData? other) {
    final _this = (this as StreamCallBadgeThemeData);

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

    final _this = (this as StreamCallBadgeThemeData);
    final _other = (other as StreamCallBadgeThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallBadgeThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamCallBadgeStyle {
  bool get canMerge => true;

  static StreamCallBadgeStyle? lerp(
    StreamCallBadgeStyle? a,
    StreamCallBadgeStyle? b,
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

    return StreamCallBadgeStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      contentHeight: lerpDouble$(a.contentHeight, b.contentHeight, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  StreamCallBadgeStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? contentHeight,
    double? spacing,
    double? iconSize,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
  }) {
    final _this = (this as StreamCallBadgeStyle);

    return StreamCallBadgeStyle(
      padding: padding ?? _this.padding,
      contentHeight: contentHeight ?? _this.contentHeight,
      spacing: spacing ?? _this.spacing,
      iconSize: iconSize ?? _this.iconSize,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      textStyle: textStyle ?? _this.textStyle,
    );
  }

  StreamCallBadgeStyle merge(StreamCallBadgeStyle? other) {
    final _this = (this as StreamCallBadgeStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      contentHeight: other.contentHeight,
      spacing: other.spacing,
      iconSize: other.iconSize,
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
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

    final _this = (this as StreamCallBadgeStyle);
    final _other = (other as StreamCallBadgeStyle);

    return _other.padding == _this.padding &&
        _other.contentHeight == _this.contentHeight &&
        _other.spacing == _this.spacing &&
        _other.iconSize == _this.iconSize &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.textStyle == _this.textStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallBadgeStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.contentHeight,
      _this.spacing,
      _this.iconSize,
      _this.backgroundColor,
      _this.borderRadius,
      _this.textStyle,
    );
  }
}
