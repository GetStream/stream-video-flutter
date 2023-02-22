import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamUserAvatar] widgets.
@immutable
class StreamUserAvatarThemeData with Diagnosticable {
  /// Creates a new instance of [StreamUserAvatarThemeData].
  const StreamUserAvatarThemeData({
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

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamUserAvatarThemeData copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    TextStyle? initialsTextStyle,
    Color? selectionColor,
    double? selectionThickness,
  }) {
    return StreamUserAvatarThemeData(
      constraints: constraints ?? this.constraints,
      borderRadius: borderRadius ?? this.borderRadius,
      initialsTextStyle: initialsTextStyle ?? this.initialsTextStyle,
      selectionColor: selectionColor ?? this.selectionColor,
      selectionThickness: selectionThickness ?? this.selectionThickness,
    );
  }

  /// Linearly interpolate between two [StreamUserAvatarThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamUserAvatarThemeData lerp(StreamUserAvatarThemeData other, double t) {
    return StreamUserAvatarThemeData(
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
  int get hashCode => Object.hash(
        constraints,
        borderRadius,
        initialsTextStyle,
        selectionColor,
        selectionThickness,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamUserAvatarThemeData &&
          runtimeType == other.runtimeType &&
          constraints == other.constraints &&
          borderRadius == other.borderRadius &&
          initialsTextStyle == other.initialsTextStyle &&
          selectionColor == other.selectionColor &&
          selectionThickness == other.selectionThickness;

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

  /// Merges one [StreamUserAvatarThemeData] with the another.
  StreamUserAvatarThemeData merge(StreamUserAvatarThemeData? other) {
    if (other == null) return this;
    return copyWith(
      constraints: other.constraints,
      borderRadius: other.borderRadius,
      initialsTextStyle: other.initialsTextStyle,
      selectionColor: other.selectionColor,
      selectionThickness: other.selectionThickness,
    );
  }
}

/// Applies a user avatar theme to descendant [StreamUserAvatar]
/// widgets.
class StreamUserAvatarTheme extends InheritedWidget {
  /// Creates a new instance of [StreamUserAvatarTheme].
  const StreamUserAvatarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamUserAvatar] widgets.
  final StreamUserAvatarThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamUserAvatarTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.userAvatarTheme].
  static StreamUserAvatarThemeData of(BuildContext context) {
    final userAvatarTheme =
        context.dependOnInheritedWidgetOfExactType<StreamUserAvatarTheme>();
    return userAvatarTheme?.data ??
        StreamVideoTheme.of(context).userAvatarTheme;
  }

  @override
  bool updateShouldNotify(StreamUserAvatarTheme oldWidget) {
    return data != oldWidget.data;
  }
}
