// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_duration_badge_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$CallDurationBadgeThemeData {
  bool get canMerge => true;

  static CallDurationBadgeThemeData? lerp(
    CallDurationBadgeThemeData? a,
    CallDurationBadgeThemeData? b,
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

    return CallDurationBadgeThemeData(
      style: CallDurationBadgeStyle.lerp(a.style, b.style, t),
    );
  }

  CallDurationBadgeThemeData copyWith({CallDurationBadgeStyle? style}) {
    final _this = (this as CallDurationBadgeThemeData);

    return CallDurationBadgeThemeData(style: style ?? _this.style);
  }

  CallDurationBadgeThemeData merge(CallDurationBadgeThemeData? other) {
    final _this = (this as CallDurationBadgeThemeData);

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

    final _this = (this as CallDurationBadgeThemeData);
    final _other = (other as CallDurationBadgeThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as CallDurationBadgeThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$CallDurationBadgeStyle {
  bool get canMerge => true;

  static CallDurationBadgeStyle? lerp(
    CallDurationBadgeStyle? a,
    CallDurationBadgeStyle? b,
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

    return CallDurationBadgeStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      contentHeight: lerpDouble$(a.contentHeight, b.contentHeight, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      indicatorSpacing: lerpDouble$(a.indicatorSpacing, b.indicatorSpacing, t),
      indicatorSize: lerpDouble$(a.indicatorSize, b.indicatorSize, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      elapsedTextColor: Color.lerp(a.elapsedTextColor, b.elapsedTextColor, t),
      encryptedColor: Color.lerp(a.encryptedColor, b.encryptedColor, t),
      recordingColor: Color.lerp(a.recordingColor, b.recordingColor, t),
      screenShareColor: Color.lerp(a.screenShareColor, b.screenShareColor, t),
    );
  }

  CallDurationBadgeStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? contentHeight,
    double? spacing,
    double? indicatorSpacing,
    double? indicatorSize,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
    Color? elapsedTextColor,
    Color? encryptedColor,
    Color? recordingColor,
    Color? screenShareColor,
  }) {
    final _this = (this as CallDurationBadgeStyle);

    return CallDurationBadgeStyle(
      padding: padding ?? _this.padding,
      contentHeight: contentHeight ?? _this.contentHeight,
      spacing: spacing ?? _this.spacing,
      indicatorSpacing: indicatorSpacing ?? _this.indicatorSpacing,
      indicatorSize: indicatorSize ?? _this.indicatorSize,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      textStyle: textStyle ?? _this.textStyle,
      elapsedTextColor: elapsedTextColor ?? _this.elapsedTextColor,
      encryptedColor: encryptedColor ?? _this.encryptedColor,
      recordingColor: recordingColor ?? _this.recordingColor,
      screenShareColor: screenShareColor ?? _this.screenShareColor,
    );
  }

  CallDurationBadgeStyle merge(CallDurationBadgeStyle? other) {
    final _this = (this as CallDurationBadgeStyle);

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
      indicatorSpacing: other.indicatorSpacing,
      indicatorSize: other.indicatorSize,
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      elapsedTextColor: other.elapsedTextColor,
      encryptedColor: other.encryptedColor,
      recordingColor: other.recordingColor,
      screenShareColor: other.screenShareColor,
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

    final _this = (this as CallDurationBadgeStyle);
    final _other = (other as CallDurationBadgeStyle);

    return _other.padding == _this.padding &&
        _other.contentHeight == _this.contentHeight &&
        _other.spacing == _this.spacing &&
        _other.indicatorSpacing == _this.indicatorSpacing &&
        _other.indicatorSize == _this.indicatorSize &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.textStyle == _this.textStyle &&
        _other.elapsedTextColor == _this.elapsedTextColor &&
        _other.encryptedColor == _this.encryptedColor &&
        _other.recordingColor == _this.recordingColor &&
        _other.screenShareColor == _this.screenShareColor;
  }

  @override
  int get hashCode {
    final _this = (this as CallDurationBadgeStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.contentHeight,
      _this.spacing,
      _this.indicatorSpacing,
      _this.indicatorSize,
      _this.backgroundColor,
      _this.borderRadius,
      _this.textStyle,
      _this.elapsedTextColor,
      _this.encryptedColor,
      _this.recordingColor,
      _this.screenShareColor,
    );
  }
}
