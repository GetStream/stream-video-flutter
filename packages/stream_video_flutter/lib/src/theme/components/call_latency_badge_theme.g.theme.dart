// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_latency_badge_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallLatencyBadgeThemeData {
  bool get canMerge => true;

  static StreamCallLatencyBadgeThemeData? lerp(
    StreamCallLatencyBadgeThemeData? a,
    StreamCallLatencyBadgeThemeData? b,
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

    return StreamCallLatencyBadgeThemeData(
      style: StreamCallLatencyBadgeStyle.lerp(a.style, b.style, t),
    );
  }

  StreamCallLatencyBadgeThemeData copyWith({
    StreamCallLatencyBadgeStyle? style,
  }) {
    final _this = (this as StreamCallLatencyBadgeThemeData);

    return StreamCallLatencyBadgeThemeData(style: style ?? _this.style);
  }

  StreamCallLatencyBadgeThemeData merge(
    StreamCallLatencyBadgeThemeData? other,
  ) {
    final _this = (this as StreamCallLatencyBadgeThemeData);

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

    final _this = (this as StreamCallLatencyBadgeThemeData);
    final _other = (other as StreamCallLatencyBadgeThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallLatencyBadgeThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamCallLatencyBadgeStyle {
  bool get canMerge => true;

  static StreamCallLatencyBadgeStyle? lerp(
    StreamCallLatencyBadgeStyle? a,
    StreamCallLatencyBadgeStyle? b,
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

    return StreamCallLatencyBadgeStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      contentHeight: lerpDouble$(a.contentHeight, b.contentHeight, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      dotSize: lerpDouble$(a.dotSize, b.dotSize, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      unitTextColor: Color.lerp(a.unitTextColor, b.unitTextColor, t),
      greatColor: Color.lerp(a.greatColor, b.greatColor, t),
      fairColor: Color.lerp(a.fairColor, b.fairColor, t),
      poorColor: Color.lerp(a.poorColor, b.poorColor, t),
      unknownColor: Color.lerp(a.unknownColor, b.unknownColor, t),
    );
  }

  StreamCallLatencyBadgeStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? contentHeight,
    double? spacing,
    double? dotSize,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
    Color? unitTextColor,
    Color? greatColor,
    Color? fairColor,
    Color? poorColor,
    Color? unknownColor,
  }) {
    final _this = (this as StreamCallLatencyBadgeStyle);

    return StreamCallLatencyBadgeStyle(
      padding: padding ?? _this.padding,
      contentHeight: contentHeight ?? _this.contentHeight,
      spacing: spacing ?? _this.spacing,
      dotSize: dotSize ?? _this.dotSize,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      textStyle: textStyle ?? _this.textStyle,
      unitTextColor: unitTextColor ?? _this.unitTextColor,
      greatColor: greatColor ?? _this.greatColor,
      fairColor: fairColor ?? _this.fairColor,
      poorColor: poorColor ?? _this.poorColor,
      unknownColor: unknownColor ?? _this.unknownColor,
    );
  }

  StreamCallLatencyBadgeStyle merge(StreamCallLatencyBadgeStyle? other) {
    final _this = (this as StreamCallLatencyBadgeStyle);

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
      dotSize: other.dotSize,
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      unitTextColor: other.unitTextColor,
      greatColor: other.greatColor,
      fairColor: other.fairColor,
      poorColor: other.poorColor,
      unknownColor: other.unknownColor,
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

    final _this = (this as StreamCallLatencyBadgeStyle);
    final _other = (other as StreamCallLatencyBadgeStyle);

    return _other.padding == _this.padding &&
        _other.contentHeight == _this.contentHeight &&
        _other.spacing == _this.spacing &&
        _other.dotSize == _this.dotSize &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.textStyle == _this.textStyle &&
        _other.unitTextColor == _this.unitTextColor &&
        _other.greatColor == _this.greatColor &&
        _other.fairColor == _this.fairColor &&
        _other.poorColor == _this.poorColor &&
        _other.unknownColor == _this.unknownColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallLatencyBadgeStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.contentHeight,
      _this.spacing,
      _this.dotSize,
      _this.backgroundColor,
      _this.borderRadius,
      _this.textStyle,
      _this.unitTextColor,
      _this.greatColor,
      _this.fairColor,
      _this.poorColor,
      _this.unknownColor,
    );
  }
}
