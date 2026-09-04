// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'floating_participant_tile_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamFloatingParticipantTileThemeData {
  bool get canMerge => true;

  static StreamFloatingParticipantTileThemeData? lerp(
    StreamFloatingParticipantTileThemeData? a,
    StreamFloatingParticipantTileThemeData? b,
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

    return StreamFloatingParticipantTileThemeData(
      style: StreamFloatingParticipantTileStyle.lerp(a.style, b.style, t),
    );
  }

  StreamFloatingParticipantTileThemeData copyWith({
    StreamFloatingParticipantTileStyle? style,
  }) {
    final _this = (this as StreamFloatingParticipantTileThemeData);

    return StreamFloatingParticipantTileThemeData(style: style ?? _this.style);
  }

  StreamFloatingParticipantTileThemeData merge(
    StreamFloatingParticipantTileThemeData? other,
  ) {
    final _this = (this as StreamFloatingParticipantTileThemeData);

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

    final _this = (this as StreamFloatingParticipantTileThemeData);
    final _other = (other as StreamFloatingParticipantTileThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamFloatingParticipantTileThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamFloatingParticipantTileStyle {
  bool get canMerge => true;

  static StreamFloatingParticipantTileStyle? lerp(
    StreamFloatingParticipantTileStyle? a,
    StreamFloatingParticipantTileStyle? b,
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

    return StreamFloatingParticipantTileStyle(
      size: Size.lerp(a.size, b.size, t),
      padding: lerpDouble$(a.padding, b.padding, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      border: BoxBorder.lerp(a.border, b.border, t),
      elevation: lerpDouble$(a.elevation, b.elevation, t),
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t),
      initialAlignment: t < 0.5 ? a.initialAlignment : b.initialAlignment,
      enableSnapping: t < 0.5 ? a.enableSnapping : b.enableSnapping,
      tileStyle: StreamParticipantTileStyle.lerp(a.tileStyle, b.tileStyle, t),
    );
  }

  StreamFloatingParticipantTileStyle copyWith({
    Size? size,
    double? padding,
    BorderRadius? borderRadius,
    BoxBorder? border,
    double? elevation,
    Color? shadowColor,
    FloatingViewAlignment? initialAlignment,
    bool? enableSnapping,
    StreamParticipantTileStyle? tileStyle,
  }) {
    final _this = (this as StreamFloatingParticipantTileStyle);

    return StreamFloatingParticipantTileStyle(
      size: size ?? _this.size,
      padding: padding ?? _this.padding,
      borderRadius: borderRadius ?? _this.borderRadius,
      border: border ?? _this.border,
      elevation: elevation ?? _this.elevation,
      shadowColor: shadowColor ?? _this.shadowColor,
      initialAlignment: initialAlignment ?? _this.initialAlignment,
      enableSnapping: enableSnapping ?? _this.enableSnapping,
      tileStyle: tileStyle ?? _this.tileStyle,
    );
  }

  StreamFloatingParticipantTileStyle merge(
    StreamFloatingParticipantTileStyle? other,
  ) {
    final _this = (this as StreamFloatingParticipantTileStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      size: other.size,
      padding: other.padding,
      borderRadius: other.borderRadius,
      border: other.border,
      elevation: other.elevation,
      shadowColor: other.shadowColor,
      initialAlignment: other.initialAlignment,
      enableSnapping: other.enableSnapping,
      tileStyle: _this.tileStyle?.merge(other.tileStyle) ?? other.tileStyle,
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

    final _this = (this as StreamFloatingParticipantTileStyle);
    final _other = (other as StreamFloatingParticipantTileStyle);

    return _other.size == _this.size &&
        _other.padding == _this.padding &&
        _other.borderRadius == _this.borderRadius &&
        _other.border == _this.border &&
        _other.elevation == _this.elevation &&
        _other.shadowColor == _this.shadowColor &&
        _other.initialAlignment == _this.initialAlignment &&
        _other.enableSnapping == _this.enableSnapping &&
        _other.tileStyle == _this.tileStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamFloatingParticipantTileStyle);

    return Object.hash(
      runtimeType,
      _this.size,
      _this.padding,
      _this.borderRadius,
      _this.border,
      _this.elevation,
      _this.shadowColor,
      _this.initialAlignment,
      _this.enableSnapping,
      _this.tileStyle,
    );
  }
}
