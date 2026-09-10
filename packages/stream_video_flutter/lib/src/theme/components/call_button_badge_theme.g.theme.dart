// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_button_badge_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallButtonBadgeThemeData {
  bool get canMerge => true;

  static StreamCallButtonBadgeThemeData? lerp(
    StreamCallButtonBadgeThemeData? a,
    StreamCallButtonBadgeThemeData? b,
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

    return StreamCallButtonBadgeThemeData(
      style: StreamCallButtonBadgeStyle.lerp(a.style, b.style, t),
    );
  }

  StreamCallButtonBadgeThemeData copyWith({StreamCallButtonBadgeStyle? style}) {
    final _this = (this as StreamCallButtonBadgeThemeData);

    return StreamCallButtonBadgeThemeData(style: style ?? _this.style);
  }

  StreamCallButtonBadgeThemeData merge(StreamCallButtonBadgeThemeData? other) {
    final _this = (this as StreamCallButtonBadgeThemeData);

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

    final _this = (this as StreamCallButtonBadgeThemeData);
    final _other = (other as StreamCallButtonBadgeThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallButtonBadgeThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamCallButtonBadgeStyle {
  bool get canMerge => true;

  static StreamCallButtonBadgeStyle? lerp(
    StreamCallButtonBadgeStyle? a,
    StreamCallButtonBadgeStyle? b,
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

    return StreamCallButtonBadgeStyle(
      badgeStyle: t < 0.5 ? a.badgeStyle : b.badgeStyle,
      size: t < 0.5 ? a.size : b.size,
      showBorder: t < 0.5 ? a.showBorder : b.showBorder,
      alignmentOffset: lerpDouble$(a.alignmentOffset, b.alignmentOffset, t),
    );
  }

  StreamCallButtonBadgeStyle copyWith({
    StreamErrorBadgeStyle? badgeStyle,
    StreamErrorBadgeSize? size,
    bool? showBorder,
    double? alignmentOffset,
  }) {
    final _this = (this as StreamCallButtonBadgeStyle);

    return StreamCallButtonBadgeStyle(
      badgeStyle: badgeStyle ?? _this.badgeStyle,
      size: size ?? _this.size,
      showBorder: showBorder ?? _this.showBorder,
      alignmentOffset: alignmentOffset ?? _this.alignmentOffset,
    );
  }

  StreamCallButtonBadgeStyle merge(StreamCallButtonBadgeStyle? other) {
    final _this = (this as StreamCallButtonBadgeStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      badgeStyle: other.badgeStyle,
      size: other.size,
      showBorder: other.showBorder,
      alignmentOffset: other.alignmentOffset,
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

    final _this = (this as StreamCallButtonBadgeStyle);
    final _other = (other as StreamCallButtonBadgeStyle);

    return _other.badgeStyle == _this.badgeStyle &&
        _other.size == _this.size &&
        _other.showBorder == _this.showBorder &&
        _other.alignmentOffset == _this.alignmentOffset;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallButtonBadgeStyle);

    return Object.hash(
      runtimeType,
      _this.badgeStyle,
      _this.size,
      _this.showBorder,
      _this.alignmentOffset,
    );
  }
}
