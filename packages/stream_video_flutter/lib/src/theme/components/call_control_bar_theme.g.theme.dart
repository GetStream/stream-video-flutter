// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_control_bar_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$CallControlBarThemeData {
  bool get canMerge => true;

  static CallControlBarThemeData? lerp(
    CallControlBarThemeData? a,
    CallControlBarThemeData? b,
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

    return CallControlBarThemeData(
      style: CallControlBarStyle.lerp(a.style, b.style, t),
    );
  }

  CallControlBarThemeData copyWith({CallControlBarStyle? style}) {
    final _this = (this as CallControlBarThemeData);

    return CallControlBarThemeData(style: style ?? _this.style);
  }

  CallControlBarThemeData merge(CallControlBarThemeData? other) {
    final _this = (this as CallControlBarThemeData);

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

    final _this = (this as CallControlBarThemeData);
    final _other = (other as CallControlBarThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as CallControlBarThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$CallControlBarStyle {
  bool get canMerge => true;

  static CallControlBarStyle? lerp(
    CallControlBarStyle? a,
    CallControlBarStyle? b,
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

    return CallControlBarStyle(
      height: lerpDouble$(a.height, b.height, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      slotSpacing: lerpDouble$(a.slotSpacing, b.slotSpacing, t),
      controlSpacing: lerpDouble$(a.controlSpacing, b.controlSpacing, t),
      surfaceStyle: t < 0.5 ? a.surfaceStyle : b.surfaceStyle,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      floatingBackgroundColor: Color.lerp(
        a.floatingBackgroundColor,
        b.floatingBackgroundColor,
        t,
      ),
    );
  }

  CallControlBarStyle copyWith({
    double? height,
    EdgeInsetsGeometry? padding,
    double? slotSpacing,
    double? controlSpacing,
    StreamSurfaceStyle? surfaceStyle,
    Color? backgroundColor,
    Color? floatingBackgroundColor,
  }) {
    final _this = (this as CallControlBarStyle);

    return CallControlBarStyle(
      height: height ?? _this.height,
      padding: padding ?? _this.padding,
      slotSpacing: slotSpacing ?? _this.slotSpacing,
      controlSpacing: controlSpacing ?? _this.controlSpacing,
      surfaceStyle: surfaceStyle ?? _this.surfaceStyle,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      floatingBackgroundColor:
          floatingBackgroundColor ?? _this.floatingBackgroundColor,
    );
  }

  CallControlBarStyle merge(CallControlBarStyle? other) {
    final _this = (this as CallControlBarStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      height: other.height,
      padding: other.padding,
      slotSpacing: other.slotSpacing,
      controlSpacing: other.controlSpacing,
      surfaceStyle: other.surfaceStyle,
      backgroundColor: other.backgroundColor,
      floatingBackgroundColor: other.floatingBackgroundColor,
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

    final _this = (this as CallControlBarStyle);
    final _other = (other as CallControlBarStyle);

    return _other.height == _this.height &&
        _other.padding == _this.padding &&
        _other.slotSpacing == _this.slotSpacing &&
        _other.controlSpacing == _this.controlSpacing &&
        _other.surfaceStyle == _this.surfaceStyle &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.floatingBackgroundColor == _this.floatingBackgroundColor;
  }

  @override
  int get hashCode {
    final _this = (this as CallControlBarStyle);

    return Object.hash(
      runtimeType,
      _this.height,
      _this.padding,
      _this.slotSpacing,
      _this.controlSpacing,
      _this.surfaceStyle,
      _this.backgroundColor,
      _this.floatingBackgroundColor,
    );
  }
}
