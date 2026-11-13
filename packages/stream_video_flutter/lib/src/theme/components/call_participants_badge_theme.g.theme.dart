// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_participants_badge_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallParticipantsBadgeThemeData {
  bool get canMerge => true;

  static StreamCallParticipantsBadgeThemeData? lerp(
    StreamCallParticipantsBadgeThemeData? a,
    StreamCallParticipantsBadgeThemeData? b,
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

    return StreamCallParticipantsBadgeThemeData(
      style: StreamCallParticipantsBadgeStyle.lerp(a.style, b.style, t),
    );
  }

  StreamCallParticipantsBadgeThemeData copyWith({
    StreamCallParticipantsBadgeStyle? style,
  }) {
    final _this = (this as StreamCallParticipantsBadgeThemeData);

    return StreamCallParticipantsBadgeThemeData(style: style ?? _this.style);
  }

  StreamCallParticipantsBadgeThemeData merge(
    StreamCallParticipantsBadgeThemeData? other,
  ) {
    final _this = (this as StreamCallParticipantsBadgeThemeData);

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

    final _this = (this as StreamCallParticipantsBadgeThemeData);
    final _other = (other as StreamCallParticipantsBadgeThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsBadgeThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamCallParticipantsBadgeStyle {
  bool get canMerge => true;

  static StreamCallParticipantsBadgeStyle? lerp(
    StreamCallParticipantsBadgeStyle? a,
    StreamCallParticipantsBadgeStyle? b,
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

    return StreamCallParticipantsBadgeStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      contentHeight: lerpDouble$(a.contentHeight, b.contentHeight, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  StreamCallParticipantsBadgeStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? contentHeight,
    double? spacing,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
  }) {
    final _this = (this as StreamCallParticipantsBadgeStyle);

    return StreamCallParticipantsBadgeStyle(
      padding: padding ?? _this.padding,
      contentHeight: contentHeight ?? _this.contentHeight,
      spacing: spacing ?? _this.spacing,
      iconSize: iconSize ?? _this.iconSize,
      iconColor: iconColor ?? _this.iconColor,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      textStyle: textStyle ?? _this.textStyle,
    );
  }

  StreamCallParticipantsBadgeStyle merge(
    StreamCallParticipantsBadgeStyle? other,
  ) {
    final _this = (this as StreamCallParticipantsBadgeStyle);

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
      iconColor: other.iconColor,
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

    final _this = (this as StreamCallParticipantsBadgeStyle);
    final _other = (other as StreamCallParticipantsBadgeStyle);

    return _other.padding == _this.padding &&
        _other.contentHeight == _this.contentHeight &&
        _other.spacing == _this.spacing &&
        _other.iconSize == _this.iconSize &&
        _other.iconColor == _this.iconColor &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.textStyle == _this.textStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsBadgeStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.contentHeight,
      _this.spacing,
      _this.iconSize,
      _this.iconColor,
      _this.backgroundColor,
      _this.borderRadius,
      _this.textStyle,
    );
  }
}
