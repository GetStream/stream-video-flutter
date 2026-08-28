// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'participant_label_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamParticipantLabelThemeData {
  bool get canMerge => true;

  static StreamParticipantLabelThemeData? lerp(
    StreamParticipantLabelThemeData? a,
    StreamParticipantLabelThemeData? b,
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

    return StreamParticipantLabelThemeData(
      style: StreamParticipantLabelStyle.lerp(a.style, b.style, t),
    );
  }

  StreamParticipantLabelThemeData copyWith({
    StreamParticipantLabelStyle? style,
  }) {
    final _this = (this as StreamParticipantLabelThemeData);

    return StreamParticipantLabelThemeData(style: style ?? _this.style);
  }

  StreamParticipantLabelThemeData merge(
    StreamParticipantLabelThemeData? other,
  ) {
    final _this = (this as StreamParticipantLabelThemeData);

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

    final _this = (this as StreamParticipantLabelThemeData);
    final _other = (other as StreamParticipantLabelThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamParticipantLabelThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamParticipantLabelStyle {
  bool get canMerge => true;

  static StreamParticipantLabelStyle? lerp(
    StreamParticipantLabelStyle? a,
    StreamParticipantLabelStyle? b,
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

    return StreamParticipantLabelStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      blurSigma: lerpDouble$(a.blurSigma, b.blurSigma, t),
      nameTextStyle: TextStyle.lerp(a.nameTextStyle, b.nameTextStyle, t),
      videoOffIconColor: Color.lerp(
        a.videoOffIconColor,
        b.videoOffIconColor,
        t,
      ),
      videoOffIconSize: lerpDouble$(a.videoOffIconSize, b.videoOffIconSize, t),
      audioIndicatorSize: lerpDouble$(
        a.audioIndicatorSize,
        b.audioIndicatorSize,
        t,
      ),
      audioIndicatorBorderRadius: BorderRadius.lerp(
        a.audioIndicatorBorderRadius,
        b.audioIndicatorBorderRadius,
        t,
      ),
      audioIndicatorBackgroundColor: Color.lerp(
        a.audioIndicatorBackgroundColor,
        b.audioIndicatorBackgroundColor,
        t,
      ),
      audioIndicatorIconSize: lerpDouble$(
        a.audioIndicatorIconSize,
        b.audioIndicatorIconSize,
        t,
      ),
      speakingColor: Color.lerp(a.speakingColor, b.speakingColor, t),
      microphoneOnColor: Color.lerp(
        a.microphoneOnColor,
        b.microphoneOnColor,
        t,
      ),
      microphoneOffColor: Color.lerp(
        a.microphoneOffColor,
        b.microphoneOffColor,
        t,
      ),
    );
  }

  StreamParticipantLabelStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? blurSigma,
    TextStyle? nameTextStyle,
    Color? videoOffIconColor,
    double? videoOffIconSize,
    double? audioIndicatorSize,
    BorderRadius? audioIndicatorBorderRadius,
    Color? audioIndicatorBackgroundColor,
    double? audioIndicatorIconSize,
    Color? speakingColor,
    Color? microphoneOnColor,
    Color? microphoneOffColor,
  }) {
    final _this = (this as StreamParticipantLabelStyle);

    return StreamParticipantLabelStyle(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      padding: padding ?? _this.padding,
      spacing: spacing ?? _this.spacing,
      blurSigma: blurSigma ?? _this.blurSigma,
      nameTextStyle: nameTextStyle ?? _this.nameTextStyle,
      videoOffIconColor: videoOffIconColor ?? _this.videoOffIconColor,
      videoOffIconSize: videoOffIconSize ?? _this.videoOffIconSize,
      audioIndicatorSize: audioIndicatorSize ?? _this.audioIndicatorSize,
      audioIndicatorBorderRadius:
          audioIndicatorBorderRadius ?? _this.audioIndicatorBorderRadius,
      audioIndicatorBackgroundColor:
          audioIndicatorBackgroundColor ?? _this.audioIndicatorBackgroundColor,
      audioIndicatorIconSize:
          audioIndicatorIconSize ?? _this.audioIndicatorIconSize,
      speakingColor: speakingColor ?? _this.speakingColor,
      microphoneOnColor: microphoneOnColor ?? _this.microphoneOnColor,
      microphoneOffColor: microphoneOffColor ?? _this.microphoneOffColor,
    );
  }

  StreamParticipantLabelStyle merge(StreamParticipantLabelStyle? other) {
    final _this = (this as StreamParticipantLabelStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      padding: other.padding,
      spacing: other.spacing,
      blurSigma: other.blurSigma,
      nameTextStyle:
          _this.nameTextStyle?.merge(other.nameTextStyle) ??
          other.nameTextStyle,
      videoOffIconColor: other.videoOffIconColor,
      videoOffIconSize: other.videoOffIconSize,
      audioIndicatorSize: other.audioIndicatorSize,
      audioIndicatorBorderRadius: other.audioIndicatorBorderRadius,
      audioIndicatorBackgroundColor: other.audioIndicatorBackgroundColor,
      audioIndicatorIconSize: other.audioIndicatorIconSize,
      speakingColor: other.speakingColor,
      microphoneOnColor: other.microphoneOnColor,
      microphoneOffColor: other.microphoneOffColor,
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

    final _this = (this as StreamParticipantLabelStyle);
    final _other = (other as StreamParticipantLabelStyle);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.padding == _this.padding &&
        _other.spacing == _this.spacing &&
        _other.blurSigma == _this.blurSigma &&
        _other.nameTextStyle == _this.nameTextStyle &&
        _other.videoOffIconColor == _this.videoOffIconColor &&
        _other.videoOffIconSize == _this.videoOffIconSize &&
        _other.audioIndicatorSize == _this.audioIndicatorSize &&
        _other.audioIndicatorBorderRadius == _this.audioIndicatorBorderRadius &&
        _other.audioIndicatorBackgroundColor ==
            _this.audioIndicatorBackgroundColor &&
        _other.audioIndicatorIconSize == _this.audioIndicatorIconSize &&
        _other.speakingColor == _this.speakingColor &&
        _other.microphoneOnColor == _this.microphoneOnColor &&
        _other.microphoneOffColor == _this.microphoneOffColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamParticipantLabelStyle);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.borderRadius,
      _this.padding,
      _this.spacing,
      _this.blurSigma,
      _this.nameTextStyle,
      _this.videoOffIconColor,
      _this.videoOffIconSize,
      _this.audioIndicatorSize,
      _this.audioIndicatorBorderRadius,
      _this.audioIndicatorBackgroundColor,
      _this.audioIndicatorIconSize,
      _this.speakingColor,
      _this.microphoneOnColor,
      _this.microphoneOffColor,
    );
  }
}
