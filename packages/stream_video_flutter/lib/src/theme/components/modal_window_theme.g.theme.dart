// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'modal_window_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamModalWindowThemeData {
  bool get canMerge => true;

  static StreamModalWindowThemeData? lerp(
    StreamModalWindowThemeData? a,
    StreamModalWindowThemeData? b,
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

    return StreamModalWindowThemeData(
      style: StreamModalWindowStyle.lerp(a.style, b.style, t),
    );
  }

  StreamModalWindowThemeData copyWith({StreamModalWindowStyle? style}) {
    final _this = (this as StreamModalWindowThemeData);

    return StreamModalWindowThemeData(style: style ?? _this.style);
  }

  StreamModalWindowThemeData merge(StreamModalWindowThemeData? other) {
    final _this = (this as StreamModalWindowThemeData);

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

    final _this = (this as StreamModalWindowThemeData);
    final _other = (other as StreamModalWindowThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamModalWindowThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamModalWindowStyle {
  bool get canMerge => true;

  static StreamModalWindowStyle? lerp(
    StreamModalWindowStyle? a,
    StreamModalWindowStyle? b,
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

    return StreamModalWindowStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      sidebarWidth: lerpDouble$(a.sidebarWidth, b.sidebarWidth, t),
      sidebarBackgroundColor: Color.lerp(
        a.sidebarBackgroundColor,
        b.sidebarBackgroundColor,
        t,
      ),
      sidebarBorderColor: Color.lerp(
        a.sidebarBorderColor,
        b.sidebarBorderColor,
        t,
      ),
      navItemStyle: StreamListTileThemeData.lerp(
        a.navItemStyle,
        b.navItemStyle,
        t,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
    );
  }

  StreamModalWindowStyle copyWith({
    Color? backgroundColor,
    double? sidebarWidth,
    Color? sidebarBackgroundColor,
    Color? sidebarBorderColor,
    StreamListTileThemeData? navItemStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final _this = (this as StreamModalWindowStyle);

    return StreamModalWindowStyle(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      sidebarWidth: sidebarWidth ?? _this.sidebarWidth,
      sidebarBackgroundColor:
          sidebarBackgroundColor ?? _this.sidebarBackgroundColor,
      sidebarBorderColor: sidebarBorderColor ?? _this.sidebarBorderColor,
      navItemStyle: navItemStyle ?? _this.navItemStyle,
      contentPadding: contentPadding ?? _this.contentPadding,
    );
  }

  StreamModalWindowStyle merge(StreamModalWindowStyle? other) {
    final _this = (this as StreamModalWindowStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      sidebarWidth: other.sidebarWidth,
      sidebarBackgroundColor: other.sidebarBackgroundColor,
      sidebarBorderColor: other.sidebarBorderColor,
      navItemStyle:
          _this.navItemStyle?.merge(other.navItemStyle) ?? other.navItemStyle,
      contentPadding: other.contentPadding,
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

    final _this = (this as StreamModalWindowStyle);
    final _other = (other as StreamModalWindowStyle);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.sidebarWidth == _this.sidebarWidth &&
        _other.sidebarBackgroundColor == _this.sidebarBackgroundColor &&
        _other.sidebarBorderColor == _this.sidebarBorderColor &&
        _other.navItemStyle == _this.navItemStyle &&
        _other.contentPadding == _this.contentPadding;
  }

  @override
  int get hashCode {
    final _this = (this as StreamModalWindowStyle);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.sidebarWidth,
      _this.sidebarBackgroundColor,
      _this.sidebarBorderColor,
      _this.navItemStyle,
      _this.contentPadding,
    );
  }
}
