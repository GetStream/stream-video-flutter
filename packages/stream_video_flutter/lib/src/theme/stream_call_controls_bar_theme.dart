import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

class StreamCallControlsBarTheme with Diagnosticable {
  const StreamCallControlsBarTheme.raw({
    required this.borderRadius,
    required this.backgroundColor,
    required this.elevation,
    required this.padding,
    required this.spacing,
    required this.optionIconColor,
    required this.inactiveOptionIconColor,
    required this.optionElevation,
    required this.inactiveOptionElevation,
    required this.optionBackgroundColor,
    required this.inactiveOptionBackgroundColor,
    required this.optionShape,
    required this.optionPadding,
  });

  factory StreamCallControlsBarTheme.fromColorAndTextTheme(
    StreamColorTheme colorTheme,
    StreamTextTheme textTheme,
  ) {
    return StreamCallControlsBarTheme.raw(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      backgroundColor: colorTheme.appBg,
      elevation: 8,
      padding: const EdgeInsets.all(14.0),
      spacing: 10,
      optionIconColor: Colors.black,
      inactiveOptionIconColor: Colors.black,
      optionElevation: 2,
      inactiveOptionElevation: 2,
      optionBackgroundColor: Colors.white,
      inactiveOptionBackgroundColor: Colors.white,
      optionShape: const CircleBorder(),
      optionPadding: const EdgeInsets.all(16),
    );
  }

  /// The border radius of the call controls bar.
  final BorderRadius borderRadius;

  /// The background color of the call controls bar.
  final Color backgroundColor;

  /// The elevation of the call controls bar.
  final double elevation;

  /// The padding applied to the call controls bar.
  final EdgeInsets padding;

  /// The spacing between the call controls.
  final double spacing;

  /// The color of the icon of the call control option.
  final Color optionIconColor;

  /// The color of the icon of the call control option when it is inactive.
  final Color inactiveOptionIconColor;

  /// The elevation of the call control option.
  final double optionElevation;

  /// The elevation of the call control option when it is inactive.
  final double inactiveOptionElevation;

  /// The background color of the call control option.
  final Color optionBackgroundColor;

  /// The background color of the call control option when it is inactive.
  final Color inactiveOptionBackgroundColor;

  /// The shape of the call control option.
  final OutlinedBorder optionShape;

  /// The padding applied to the call control option.
  final EdgeInsetsGeometry optionPadding;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  StreamCallControlsBarTheme copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
    EdgeInsets? padding,
    double? spacing,
    Color? optionIconColor,
    Color? inactiveOptionIconColor,
    double? optionElevation,
    double? inactiveOptionElevation,
    Color? optionBackgroundColor,
    Color? inactiveOptionBackgroundColor,
    OutlinedBorder? optionShape,
    EdgeInsetsGeometry? optionPadding,
  }) {
    return StreamCallControlsBarTheme.raw(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      optionIconColor: optionIconColor ?? this.optionIconColor,
      inactiveOptionIconColor:
          inactiveOptionIconColor ?? this.inactiveOptionIconColor,
      optionElevation: optionElevation ?? this.optionElevation,
      inactiveOptionElevation:
          inactiveOptionElevation ?? this.inactiveOptionElevation,
      optionBackgroundColor:
          optionBackgroundColor ?? this.optionBackgroundColor,
      inactiveOptionBackgroundColor:
          inactiveOptionBackgroundColor ?? this.inactiveOptionBackgroundColor,
      optionShape: optionShape ?? this.optionShape,
      optionPadding: optionPadding ?? this.optionPadding,
    );
  }

  /// Merge another [StreamCallControlsBarTheme] into this one.
  StreamCallControlsBarTheme merge(StreamCallControlsBarTheme? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      borderRadius: other.borderRadius,
      backgroundColor: other.backgroundColor,
      elevation: other.elevation,
      padding: other.padding,
      spacing: other.spacing,
      optionIconColor: other.optionIconColor,
      inactiveOptionIconColor: other.inactiveOptionIconColor,
      optionElevation: other.optionElevation,
      inactiveOptionElevation: other.inactiveOptionElevation,
      optionBackgroundColor: other.optionBackgroundColor,
      inactiveOptionBackgroundColor: other.inactiveOptionBackgroundColor,
      optionShape: other.optionShape,
      optionPadding: other.optionPadding,
    );
  }

  /// Linearly interpolate between two [UserAvatar] themes.
  ///
  /// All the properties must be non-null.
  StreamCallControlsBarTheme lerp(StreamCallControlsBarTheme other, double t) {
    return StreamCallControlsBarTheme.raw(
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      optionIconColor: Color.lerp(optionIconColor, other.optionIconColor, t)!,
      inactiveOptionIconColor: Color.lerp(
          inactiveOptionIconColor, other.inactiveOptionIconColor, t)!,
      optionElevation: lerpDouble(optionElevation, other.optionElevation, t)!,
      inactiveOptionElevation: lerpDouble(
          inactiveOptionElevation, other.inactiveOptionElevation, t)!,
      optionBackgroundColor:
          Color.lerp(optionBackgroundColor, other.optionBackgroundColor, t)!,
      inactiveOptionBackgroundColor: Color.lerp(inactiveOptionBackgroundColor,
          other.inactiveOptionBackgroundColor, t)!,
      optionShape: OutlinedBorder.lerp(optionShape, other.optionShape, t)!,
      optionPadding:
          EdgeInsetsGeometry.lerp(optionPadding, other.optionPadding, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(ColorProperty('optionIconColor', optionIconColor));
    properties
        .add(ColorProperty('inactiveOptionIconColor', inactiveOptionIconColor));
    properties.add(DoubleProperty('optionElevation', optionElevation));
    properties.add(
        DoubleProperty('inactiveOptionElevation', inactiveOptionElevation));
    properties
        .add(ColorProperty('optionBackgroundColor', optionBackgroundColor));
    properties.add(ColorProperty(
        'inactiveOptionBackgroundColor', inactiveOptionBackgroundColor));
    properties
        .add(DiagnosticsProperty<OutlinedBorder>('optionShape', optionShape));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>(
        'optionPadding', optionPadding));
  }
}
