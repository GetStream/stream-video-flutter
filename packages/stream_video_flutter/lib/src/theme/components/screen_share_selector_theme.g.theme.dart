// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'screen_share_selector_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamScreenShareSelectorThemeData {
  bool get canMerge => true;

  static StreamScreenShareSelectorThemeData? lerp(
    StreamScreenShareSelectorThemeData? a,
    StreamScreenShareSelectorThemeData? b,
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

    return StreamScreenShareSelectorThemeData(
      style: StreamScreenShareSelectorStyle.lerp(a.style, b.style, t),
    );
  }

  StreamScreenShareSelectorThemeData copyWith({
    StreamScreenShareSelectorStyle? style,
  }) {
    final _this = (this as StreamScreenShareSelectorThemeData);

    return StreamScreenShareSelectorThemeData(style: style ?? _this.style);
  }

  StreamScreenShareSelectorThemeData merge(
    StreamScreenShareSelectorThemeData? other,
  ) {
    final _this = (this as StreamScreenShareSelectorThemeData);

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

    final _this = (this as StreamScreenShareSelectorThemeData);
    final _other = (other as StreamScreenShareSelectorThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScreenShareSelectorThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamScreenShareSelectorStyle {
  bool get canMerge => true;

  static StreamScreenShareSelectorStyle? lerp(
    StreamScreenShareSelectorStyle? a,
    StreamScreenShareSelectorStyle? b,
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

    return StreamScreenShareSelectorStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      crossAxisCount: t < 0.5 ? a.crossAxisCount : b.crossAxisCount,
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      tileHeight: lerpDouble$(a.tileHeight, b.tileHeight, t),
      tilePadding: EdgeInsetsGeometry.lerp(a.tilePadding, b.tilePadding, t),
      tileSpacing: lerpDouble$(a.tileSpacing, b.tileSpacing, t),
      tileBorderRadius: BorderRadius.lerp(
        a.tileBorderRadius,
        b.tileBorderRadius,
        t,
      ),
      imageBorderRadius: BorderRadius.lerp(
        a.imageBorderRadius,
        b.imageBorderRadius,
        t,
      ),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble$(a.borderWidth, b.borderWidth, t),
      selectedBorderColor: Color.lerp(
        a.selectedBorderColor,
        b.selectedBorderColor,
        t,
      ),
      selectedBorderWidth: lerpDouble$(
        a.selectedBorderWidth,
        b.selectedBorderWidth,
        t,
      ),
      placeholderColor: Color.lerp(a.placeholderColor, b.placeholderColor, t),
      labelTextStyle: TextStyle.lerp(a.labelTextStyle, b.labelTextStyle, t),
      labelColor: Color.lerp(a.labelColor, b.labelColor, t),
      selectedLabelColor: Color.lerp(
        a.selectedLabelColor,
        b.selectedLabelColor,
        t,
      ),
      thumbnailSize: Size.lerp(a.thumbnailSize, b.thumbnailSize, t),
    );
  }

  StreamScreenShareSelectorStyle copyWith({
    EdgeInsetsGeometry? padding,
    int? crossAxisCount,
    double? spacing,
    double? tileHeight,
    EdgeInsetsGeometry? tilePadding,
    double? tileSpacing,
    BorderRadius? tileBorderRadius,
    BorderRadius? imageBorderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? selectedBorderColor,
    double? selectedBorderWidth,
    Color? placeholderColor,
    TextStyle? labelTextStyle,
    Color? labelColor,
    Color? selectedLabelColor,
    Size? thumbnailSize,
  }) {
    final _this = (this as StreamScreenShareSelectorStyle);

    return StreamScreenShareSelectorStyle(
      padding: padding ?? _this.padding,
      crossAxisCount: crossAxisCount ?? _this.crossAxisCount,
      spacing: spacing ?? _this.spacing,
      tileHeight: tileHeight ?? _this.tileHeight,
      tilePadding: tilePadding ?? _this.tilePadding,
      tileSpacing: tileSpacing ?? _this.tileSpacing,
      tileBorderRadius: tileBorderRadius ?? _this.tileBorderRadius,
      imageBorderRadius: imageBorderRadius ?? _this.imageBorderRadius,
      borderColor: borderColor ?? _this.borderColor,
      borderWidth: borderWidth ?? _this.borderWidth,
      selectedBorderColor: selectedBorderColor ?? _this.selectedBorderColor,
      selectedBorderWidth: selectedBorderWidth ?? _this.selectedBorderWidth,
      placeholderColor: placeholderColor ?? _this.placeholderColor,
      labelTextStyle: labelTextStyle ?? _this.labelTextStyle,
      labelColor: labelColor ?? _this.labelColor,
      selectedLabelColor: selectedLabelColor ?? _this.selectedLabelColor,
      thumbnailSize: thumbnailSize ?? _this.thumbnailSize,
    );
  }

  StreamScreenShareSelectorStyle merge(StreamScreenShareSelectorStyle? other) {
    final _this = (this as StreamScreenShareSelectorStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      crossAxisCount: other.crossAxisCount,
      spacing: other.spacing,
      tileHeight: other.tileHeight,
      tilePadding: other.tilePadding,
      tileSpacing: other.tileSpacing,
      tileBorderRadius: other.tileBorderRadius,
      imageBorderRadius: other.imageBorderRadius,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      selectedBorderColor: other.selectedBorderColor,
      selectedBorderWidth: other.selectedBorderWidth,
      placeholderColor: other.placeholderColor,
      labelTextStyle:
          _this.labelTextStyle?.merge(other.labelTextStyle) ??
          other.labelTextStyle,
      labelColor: other.labelColor,
      selectedLabelColor: other.selectedLabelColor,
      thumbnailSize: other.thumbnailSize,
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

    final _this = (this as StreamScreenShareSelectorStyle);
    final _other = (other as StreamScreenShareSelectorStyle);

    return _other.padding == _this.padding &&
        _other.crossAxisCount == _this.crossAxisCount &&
        _other.spacing == _this.spacing &&
        _other.tileHeight == _this.tileHeight &&
        _other.tilePadding == _this.tilePadding &&
        _other.tileSpacing == _this.tileSpacing &&
        _other.tileBorderRadius == _this.tileBorderRadius &&
        _other.imageBorderRadius == _this.imageBorderRadius &&
        _other.borderColor == _this.borderColor &&
        _other.borderWidth == _this.borderWidth &&
        _other.selectedBorderColor == _this.selectedBorderColor &&
        _other.selectedBorderWidth == _this.selectedBorderWidth &&
        _other.placeholderColor == _this.placeholderColor &&
        _other.labelTextStyle == _this.labelTextStyle &&
        _other.labelColor == _this.labelColor &&
        _other.selectedLabelColor == _this.selectedLabelColor &&
        _other.thumbnailSize == _this.thumbnailSize;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScreenShareSelectorStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.crossAxisCount,
      _this.spacing,
      _this.tileHeight,
      _this.tilePadding,
      _this.tileSpacing,
      _this.tileBorderRadius,
      _this.imageBorderRadius,
      _this.borderColor,
      _this.borderWidth,
      _this.selectedBorderColor,
      _this.selectedBorderWidth,
      _this.placeholderColor,
      _this.labelTextStyle,
      _this.labelColor,
      _this.selectedLabelColor,
      _this.thumbnailSize,
    );
  }
}
