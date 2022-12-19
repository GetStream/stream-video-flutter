import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template avatarThemeData}
/// A style that overrides the default appearance of user avatar widget.
/// {@endtemplate}
class StreamAvatarTheme with Diagnosticable {
  /// {@macro avatarThemeData}
  const StreamAvatarTheme({
    this.constraints = const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.initialsTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.selectionColor = const Color(0xff005FFF),
    this.selectionThickness = 4,
  });

  /// Sizing constraints of the avatar.
  final BoxConstraints constraints;

  /// [BorderRadius] of the image.
  final BorderRadius borderRadius;

  /// [TextStyle] for the initials text.
  final TextStyle initialsTextStyle;

  /// Color of the selection.
  final Color selectionColor;

  /// Selection thickness around the avatar.
  final double selectionThickness;

  copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    TextStyle? initialsTextStyle,
    Color? selectionColor,
    double? selectionThickness,
  }) {
    return StreamAvatarTheme(
      constraints: constraints ?? this.constraints,
      borderRadius: borderRadius ?? this.borderRadius,
      initialsTextStyle: initialsTextStyle ?? this.initialsTextStyle,
      selectionColor: selectionColor ?? this.selectionColor,
      selectionThickness: selectionThickness ?? this.selectionThickness,
    );
  }

  /// Linearly interpolate between two [UserAvatar] themes.
  ///
  /// All the properties must be non-null.
  StreamAvatarTheme lerp(StreamAvatarTheme other, double t) {
    return StreamAvatarTheme(
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      constraints: BoxConstraints.lerp(constraints, other.constraints, t)!,
      initialsTextStyle:
          TextStyle.lerp(initialsTextStyle, other.initialsTextStyle, t)!,
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t)!,
      selectionThickness:
          lerpDouble(selectionThickness, other.selectionThickness, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAvatarTheme &&
          runtimeType == other.runtimeType &&
          constraints == other.constraints &&
          borderRadius == other.borderRadius &&
          initialsTextStyle == other.initialsTextStyle &&
          selectionColor == other.selectionColor &&
          selectionThickness == other.selectionThickness;

  @override
  int get hashCode =>
      constraints.hashCode ^
      borderRadius.hashCode ^
      initialsTextStyle.hashCode ^
      selectionColor.hashCode ^
      selectionThickness.hashCode;

  /// Merges one [StreamAvatarTheme] with the another
  StreamAvatarTheme merge(StreamAvatarTheme? other) {
    if (other == null) return this;
    return copyWith(
      constraints: other.constraints,
      borderRadius: other.borderRadius,
      initialsTextStyle: other.initialsTextStyle,
      selectionColor: other.selectionColor,
      selectionThickness: other.selectionThickness,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('initialsTextStyle', initialsTextStyle))
      ..add(DiagnosticsProperty('selectionColor', selectionColor))
      ..add(DiagnosticsProperty('selectionThickness', selectionThickness));
  }
}
