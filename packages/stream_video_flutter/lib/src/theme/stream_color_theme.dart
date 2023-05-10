import 'dart:ui';

import 'package:flutter/material.dart';

/// {@template color_theme}
/// Theme that holds colors
/// {@endtemplate}
class StreamColorTheme {
  /// Initialise with light theme
  const StreamColorTheme.light({
    this.textHighEmphasis = const Color(0xff000000),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xffB4B7BB),
    this.borders = const Color(0xffecebeb),
    this.inputBg = const Color(0xfff2f2f2),
    this.appBg = const Color(0xfffcfcfc),
    this.barsBg = const Color(0xffffffff),
    this.linkBg = const Color(0xffe9f2ff),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3842),
    this.accentInfo = const Color(0xff20E070),
    this.highlight = const Color(0xfffbf4dd),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.2),
    this.overlayDark = const Color.fromRGBO(0, 0, 0, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xfff7f7f7), Color(0xfffcfcfc)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff000000),
      blur: 0,
      opacity: 0.08,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff000000),
      blur: 0,
      opacity: 0.08,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      opacity: 0.5,
      blur: 4,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      opacity: 1,
      blur: 8,
    ),
  });

  /// Initialise with dark theme
  const StreamColorTheme.dark({
    this.textHighEmphasis = const Color(0xffffffff),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xff4C525C),
    this.borders = const Color(0xff1c1e22),
    this.inputBg = const Color(0xff13151b),
    this.appBg = const Color(0xff070A0D),
    this.barsBg = const Color(0xff101418),
    this.linkBg = const Color(0xff00193D),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3742),
    this.accentInfo = const Color(0xff20E070),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff141924),
      blur: 0,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff141924),
      blur: 0,
      opacity: 1,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      opacity: 0.5,
      blur: 4,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      opacity: 1,
      blur: 8,
    ),
    this.highlight = const Color(0xff302d22),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.4),
    this.overlayDark = const Color.fromRGBO(255, 255, 255, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff101214),
        Color(0xff070a0d),
      ],
      stops: [0, 1],
    ),
  });

  /// Raw theme initialization
  const StreamColorTheme.raw({
    required this.textHighEmphasis,
    required this.textLowEmphasis,
    required this.disabled,
    required this.borders,
    required this.inputBg,
    required this.appBg,
    required this.barsBg,
    required this.linkBg,
    required this.accentPrimary,
    required this.accentError,
    required this.accentInfo,
    required this.borderTop,
    required this.borderBottom,
    required this.shadowIconButton,
    required this.modalShadow,
    required this.highlight,
    required this.overlay,
    required this.overlayDark,
    required this.bgGradient,
  });

  ///
  final Color textHighEmphasis;

  ///
  final Color textLowEmphasis;

  ///
  final Color disabled;

  ///
  final Color borders;

  ///
  final Color inputBg;

  ///
  final Color appBg;

  ///
  final Color barsBg;

  ///
  final Color linkBg;

  ///
  final Color accentPrimary;

  ///
  final Color accentError;

  ///
  final Color accentInfo;

  ///
  final Effect borderTop;

  ///
  final Effect borderBottom;

  ///
  final Effect shadowIconButton;

  ///
  final Effect modalShadow;

  ///
  final Color highlight;

  ///
  final Color overlay;

  ///
  final Color overlayDark;

  ///
  final Gradient bgGradient;

  /// Copy with theme
  StreamColorTheme copyWith({
    Color? textHighEmphasis,
    Color? textLowEmphasis,
    Color? disabled,
    Color? borders,
    Color? inputBg,
    Color? appBg,
    Color? barsBg,
    Color? linkBg,
    Color? accentPrimary,
    Color? accentError,
    Color? accentInfo,
    Effect? borderTop,
    Effect? borderBottom,
    Effect? shadowIconButton,
    Effect? modalShadow,
    Color? highlight,
    Color? overlay,
    Color? overlayDark,
    Gradient? bgGradient,
  }) {
    return StreamColorTheme.raw(
      textHighEmphasis: textHighEmphasis ?? this.textHighEmphasis,
      textLowEmphasis: textLowEmphasis ?? this.textLowEmphasis,
      disabled: disabled ?? this.disabled,
      borders: borders ?? this.borders,
      inputBg: inputBg ?? this.inputBg,
      appBg: appBg ?? this.appBg,
      barsBg: barsBg ?? this.barsBg,
      linkBg: linkBg ?? this.linkBg,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentError: accentError ?? this.accentError,
      accentInfo: accentInfo ?? this.accentInfo,
      borderTop: borderTop ?? this.borderTop,
      borderBottom: borderBottom ?? this.borderBottom,
      shadowIconButton: shadowIconButton ?? this.shadowIconButton,
      modalShadow: modalShadow ?? this.modalShadow,
      highlight: highlight ?? this.highlight,
      overlay: overlay ?? this.overlay,
      overlayDark: overlayDark ?? this.overlayDark,
      bgGradient: bgGradient ?? this.bgGradient,
    );
  }

  /// Merge color theme
  StreamColorTheme merge(StreamColorTheme? other) {
    if (other == null) return this;
    return copyWith(
      textHighEmphasis: other.textHighEmphasis,
      textLowEmphasis: other.textLowEmphasis,
      disabled: other.disabled,
      borders: other.borders,
      inputBg: other.inputBg,
      appBg: other.appBg,
      barsBg: other.barsBg,
      linkBg: other.linkBg,
      accentPrimary: other.accentPrimary,
      accentError: other.accentError,
      accentInfo: other.accentInfo,
      highlight: other.highlight,
      overlay: other.overlay,
      overlayDark: other.overlayDark,
      bgGradient: other.bgGradient,
      borderTop: other.borderTop,
      borderBottom: other.borderBottom,
      shadowIconButton: other.shadowIconButton,
      modalShadow: other.modalShadow,
    );
  }

  StreamColorTheme lerp(StreamColorTheme? other, double t) {
    if (other == null) return this;
    return copyWith(
      textHighEmphasis: Color.lerp(textHighEmphasis, other.textHighEmphasis, t),
      textLowEmphasis: Color.lerp(textLowEmphasis, other.textLowEmphasis, t),
      disabled: Color.lerp(disabled, other.disabled, t),
      borders: Color.lerp(borders, other.borders, t),
      inputBg: Color.lerp(inputBg, other.inputBg, t),
      appBg: Color.lerp(appBg, other.appBg, t),
      barsBg: Color.lerp(barsBg, other.barsBg, t),
      linkBg: Color.lerp(linkBg, other.linkBg, t),
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t),
      accentError: Color.lerp(accentError, other.accentError, t),
      accentInfo: Color.lerp(accentInfo, other.accentInfo, t),
      highlight: Color.lerp(highlight, other.highlight, t),
      overlay: Color.lerp(overlay, other.overlay, t),
      overlayDark: Color.lerp(overlayDark, other.overlayDark, t),
      bgGradient: Gradient.lerp(bgGradient, other.bgGradient, t),
      borderTop: borderTop.lerp(other.borderTop, t),
      borderBottom: borderBottom.lerp(other.borderBottom, t),
      shadowIconButton: shadowIconButton.lerp(other.shadowIconButton, t),
      modalShadow: modalShadow.lerp(other.modalShadow, t),
    );
  }
}

/// Effect store
class Effect {
  /// Constructor for creating [Effect]
  const Effect({
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.opacity,
    this.blur,
  });

  ///
  final double? sigmaX;

  ///
  final double? sigmaY;

  ///
  final Color? color;

  ///
  final double? opacity;

  ///
  final double? blur;

  /// Copy with new effect
  Effect copyWith({
    double? sigmaX,
    double? sigmaY,
    Color? color,
    double? opacity,
    double? blur,
  }) {
    return Effect(
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
    );
  }

  Effect lerp(Effect other, double t) {
    return Effect(
      sigmaX: lerpDouble(sigmaX, other.sigmaX, t),
      sigmaY: lerpDouble(sigmaY, other.sigmaY, t),
      color: Color.lerp(color, other.color, t),
      opacity: lerpDouble(opacity, other.opacity, t),
      blur: lerpDouble(blur, other.blur, t),
    );
  }
}
