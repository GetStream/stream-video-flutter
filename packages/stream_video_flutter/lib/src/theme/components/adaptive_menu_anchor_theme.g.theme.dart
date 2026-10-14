// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'adaptive_menu_anchor_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamAdaptiveMenuAnchorThemeData {
  bool get canMerge => true;

  static StreamAdaptiveMenuAnchorThemeData? lerp(
    StreamAdaptiveMenuAnchorThemeData? a,
    StreamAdaptiveMenuAnchorThemeData? b,
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

    return StreamAdaptiveMenuAnchorThemeData(
      style: StreamAdaptiveMenuAnchorStyle.lerp(a.style, b.style, t),
    );
  }

  StreamAdaptiveMenuAnchorThemeData copyWith({
    StreamAdaptiveMenuAnchorStyle? style,
  }) {
    final _this = (this as StreamAdaptiveMenuAnchorThemeData);

    return StreamAdaptiveMenuAnchorThemeData(style: style ?? _this.style);
  }

  StreamAdaptiveMenuAnchorThemeData merge(
    StreamAdaptiveMenuAnchorThemeData? other,
  ) {
    final _this = (this as StreamAdaptiveMenuAnchorThemeData);

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

    final _this = (this as StreamAdaptiveMenuAnchorThemeData);
    final _other = (other as StreamAdaptiveMenuAnchorThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamAdaptiveMenuAnchorThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamAdaptiveMenuAnchorStyle {
  bool get canMerge => true;

  static StreamAdaptiveMenuAnchorStyle? lerp(
    StreamAdaptiveMenuAnchorStyle? a,
    StreamAdaptiveMenuAnchorStyle? b,
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

    return StreamAdaptiveMenuAnchorStyle(
      sheetTileStyle: StreamListTileThemeData.lerp(
        a.sheetTileStyle,
        b.sheetTileStyle,
        t,
      ),
      menuItemStyle: StreamContextMenuActionStyle.lerp(
        a.menuItemStyle,
        b.menuItemStyle,
        t,
      ),
    );
  }

  StreamAdaptiveMenuAnchorStyle copyWith({
    StreamListTileThemeData? sheetTileStyle,
    StreamContextMenuActionStyle? menuItemStyle,
  }) {
    final _this = (this as StreamAdaptiveMenuAnchorStyle);

    return StreamAdaptiveMenuAnchorStyle(
      sheetTileStyle: sheetTileStyle ?? _this.sheetTileStyle,
      menuItemStyle: menuItemStyle ?? _this.menuItemStyle,
    );
  }

  StreamAdaptiveMenuAnchorStyle merge(StreamAdaptiveMenuAnchorStyle? other) {
    final _this = (this as StreamAdaptiveMenuAnchorStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      sheetTileStyle:
          _this.sheetTileStyle?.merge(other.sheetTileStyle) ??
          other.sheetTileStyle,
      menuItemStyle:
          _this.menuItemStyle?.merge(other.menuItemStyle) ??
          other.menuItemStyle,
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

    final _this = (this as StreamAdaptiveMenuAnchorStyle);
    final _other = (other as StreamAdaptiveMenuAnchorStyle);

    return _other.sheetTileStyle == _this.sheetTileStyle &&
        _other.menuItemStyle == _this.menuItemStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamAdaptiveMenuAnchorStyle);

    return Object.hash(runtimeType, _this.sheetTileStyle, _this.menuItemStyle);
  }
}
