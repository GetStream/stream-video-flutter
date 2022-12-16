import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template avatarThemeData}
/// A style that overrides the default appearance of user avatar widget.
/// {@endtemplate}
class StreamAvatarThemeData with Diagnosticable {
  /// {@macro avatarThemeData}
  const StreamAvatarThemeData({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    TextStyle? initialsTextStyle,
  })  : _constraints = constraints,
        _borderRadius = borderRadius,
        _initialsTextStyle = initialsTextStyle;

  /// Sizing constraints of the avatar.
  final BoxConstraints? _constraints;

  /// [BorderRadius] of the image.
  final BorderRadius? _borderRadius;

  /// [TextStyle] for the initials text.
  final TextStyle? _initialsTextStyle;

  /// Get constraints for avatar.
  BoxConstraints get constraints =>
      _constraints ??
      const BoxConstraints.tightFor(
        height: 40,
        width: 40,
      );

  /// Get border radius.
  BorderRadius get borderRadius => _borderRadius ?? BorderRadius.circular(20);

  /// Get initials text style.
  TextStyle get initialsTextStyle =>
      _initialsTextStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  /// Copy this [StreamAvatarThemeData] to another.
  StreamAvatarThemeData copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    TextStyle? initialsTextStyle,
  }) {
    return StreamAvatarThemeData(
      constraints: constraints ?? _constraints,
      borderRadius: borderRadius ?? _borderRadius,
      initialsTextStyle: initialsTextStyle ?? _initialsTextStyle,
    );
  }

  /// Linearly interpolate between two [UserAvatar] themes.
  ///
  /// All the properties must be non-null.
  StreamAvatarThemeData lerp(
    StreamAvatarThemeData a,
    StreamAvatarThemeData b,
    double t,
  ) {
    return StreamAvatarThemeData(
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      initialsTextStyle:
          TextStyle.lerp(a.initialsTextStyle, b.initialsTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAvatarThemeData &&
          runtimeType == other.runtimeType &&
          _constraints == other._constraints &&
          _borderRadius == other._borderRadius &&
          _initialsTextStyle == other._initialsTextStyle;

  @override
  int get hashCode => _constraints.hashCode ^ _borderRadius.hashCode;

  /// Merges one [StreamAvatarThemeData] with the another
  StreamAvatarThemeData merge(StreamAvatarThemeData? other) {
    if (other == null) return this;
    return copyWith(
        constraints: other._constraints,
        borderRadius: other._borderRadius,
        initialsTextStyle: other._initialsTextStyle);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('initialsTextStyle', initialsTextStyle));
  }
}
