// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'ringing_call_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamIncomingCallThemeData {
  bool get canMerge => true;

  static StreamIncomingCallThemeData? lerp(
    StreamIncomingCallThemeData? a,
    StreamIncomingCallThemeData? b,
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

    return StreamIncomingCallThemeData(
      style: StreamRingingCallStyle.lerp(a.style, b.style, t),
    );
  }

  StreamIncomingCallThemeData copyWith({StreamRingingCallStyle? style}) {
    final _this = (this as StreamIncomingCallThemeData);

    return StreamIncomingCallThemeData(style: style ?? _this.style);
  }

  StreamIncomingCallThemeData merge(StreamIncomingCallThemeData? other) {
    final _this = (this as StreamIncomingCallThemeData);

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

    final _this = (this as StreamIncomingCallThemeData);
    final _other = (other as StreamIncomingCallThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamIncomingCallThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamOutgoingCallThemeData {
  bool get canMerge => true;

  static StreamOutgoingCallThemeData? lerp(
    StreamOutgoingCallThemeData? a,
    StreamOutgoingCallThemeData? b,
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

    return StreamOutgoingCallThemeData(
      style: StreamRingingCallStyle.lerp(a.style, b.style, t),
    );
  }

  StreamOutgoingCallThemeData copyWith({StreamRingingCallStyle? style}) {
    final _this = (this as StreamOutgoingCallThemeData);

    return StreamOutgoingCallThemeData(style: style ?? _this.style);
  }

  StreamOutgoingCallThemeData merge(StreamOutgoingCallThemeData? other) {
    final _this = (this as StreamOutgoingCallThemeData);

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

    final _this = (this as StreamOutgoingCallThemeData);
    final _other = (other as StreamOutgoingCallThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamOutgoingCallThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamRingingCallStyle {
  bool get canMerge => true;

  static StreamRingingCallStyle? lerp(
    StreamRingingCallStyle? a,
    StreamRingingCallStyle? b,
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

    return StreamRingingCallStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      scrimColor: Color.lerp(a.scrimColor, b.scrimColor, t),
      blurSigma: lerpDouble$(a.blurSigma, b.blurSigma, t),
      avatarTheme: StreamAvatarThemeData.lerp(a.avatarTheme, b.avatarTheme, t),
      avatarGroupSize: t < 0.5 ? a.avatarGroupSize : b.avatarGroupSize,
      contentSpacing: lerpDouble$(a.contentSpacing, b.contentSpacing, t),
      titleSpacing: lerpDouble$(a.titleSpacing, b.titleSpacing, t),
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      statusTextStyle: TextStyle.lerp(a.statusTextStyle, b.statusTextStyle, t),
      controlsSpacing: lerpDouble$(a.controlsSpacing, b.controlsSpacing, t),
      controlsPadding: EdgeInsetsGeometry.lerp(
        a.controlsPadding,
        b.controlsPadding,
        t,
      ),
      secondaryControlsSpacing: lerpDouble$(
        a.secondaryControlsSpacing,
        b.secondaryControlsSpacing,
        t,
      ),
    );
  }

  StreamRingingCallStyle copyWith({
    Color? backgroundColor,
    Color? scrimColor,
    double? blurSigma,
    StreamAvatarThemeData? avatarTheme,
    StreamAvatarGroupSize? avatarGroupSize,
    double? contentSpacing,
    double? titleSpacing,
    TextStyle? titleTextStyle,
    TextStyle? statusTextStyle,
    double? controlsSpacing,
    EdgeInsetsGeometry? controlsPadding,
    double? secondaryControlsSpacing,
  }) {
    final _this = (this as StreamRingingCallStyle);

    return StreamRingingCallStyle(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      scrimColor: scrimColor ?? _this.scrimColor,
      blurSigma: blurSigma ?? _this.blurSigma,
      avatarTheme: avatarTheme ?? _this.avatarTheme,
      avatarGroupSize: avatarGroupSize ?? _this.avatarGroupSize,
      contentSpacing: contentSpacing ?? _this.contentSpacing,
      titleSpacing: titleSpacing ?? _this.titleSpacing,
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      statusTextStyle: statusTextStyle ?? _this.statusTextStyle,
      controlsSpacing: controlsSpacing ?? _this.controlsSpacing,
      controlsPadding: controlsPadding ?? _this.controlsPadding,
      secondaryControlsSpacing:
          secondaryControlsSpacing ?? _this.secondaryControlsSpacing,
    );
  }

  StreamRingingCallStyle merge(StreamRingingCallStyle? other) {
    final _this = (this as StreamRingingCallStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      scrimColor: other.scrimColor,
      blurSigma: other.blurSigma,
      avatarTheme:
          _this.avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      avatarGroupSize: other.avatarGroupSize,
      contentSpacing: other.contentSpacing,
      titleSpacing: other.titleSpacing,
      titleTextStyle:
          _this.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      statusTextStyle:
          _this.statusTextStyle?.merge(other.statusTextStyle) ??
          other.statusTextStyle,
      controlsSpacing: other.controlsSpacing,
      controlsPadding: other.controlsPadding,
      secondaryControlsSpacing: other.secondaryControlsSpacing,
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

    final _this = (this as StreamRingingCallStyle);
    final _other = (other as StreamRingingCallStyle);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.scrimColor == _this.scrimColor &&
        _other.blurSigma == _this.blurSigma &&
        _other.avatarTheme == _this.avatarTheme &&
        _other.avatarGroupSize == _this.avatarGroupSize &&
        _other.contentSpacing == _this.contentSpacing &&
        _other.titleSpacing == _this.titleSpacing &&
        _other.titleTextStyle == _this.titleTextStyle &&
        _other.statusTextStyle == _this.statusTextStyle &&
        _other.controlsSpacing == _this.controlsSpacing &&
        _other.controlsPadding == _this.controlsPadding &&
        _other.secondaryControlsSpacing == _this.secondaryControlsSpacing;
  }

  @override
  int get hashCode {
    final _this = (this as StreamRingingCallStyle);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.scrimColor,
      _this.blurSigma,
      _this.avatarTheme,
      _this.avatarGroupSize,
      _this.contentSpacing,
      _this.titleSpacing,
      _this.titleTextStyle,
      _this.statusTextStyle,
      _this.controlsSpacing,
      _this.controlsPadding,
      _this.secondaryControlsSpacing,
    );
  }
}
