import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamCallControls] widgets.
@immutable
class StreamCallControlsThemeData with Diagnosticable {
  /// Creates a new instance of [StreamCallControlsThemeData].
  const StreamCallControlsThemeData({
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    ),
    this.backgroundColor = Colors.white,
    this.elevation = 8,
    this.padding = const EdgeInsets.all(14),
    this.spacing = 10,
    this.optionIconColor = Colors.black,
    this.inactiveOptionIconColor = Colors.white,
    this.optionElevation = 2,
    this.inactiveOptionElevation = 2,
    this.optionBackgroundColor = Colors.white,
    this.inactiveOptionBackgroundColor = const Color.fromRGBO(0, 0, 0, 0.4),
    this.optionShape = const CircleBorder(),
    this.optionPadding = const EdgeInsets.all(16),
    this.callReactions = const [
      CallReactionData(
        type: 'reaction',
        emojiCode: ':like:',
        custom: {},
        icon: '👍',
      ),
      CallReactionData(
        type: 'raised-hand',
        emojiCode: ':raise-hand:',
        custom: {},
        icon: '✋',
      ),
      CallReactionData(
        type: 'reaction',
        emojiCode: ':fireworks:',
        custom: {},
        icon: '🎉',
      ),
    ],
  });

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

  final List<CallReactionData> callReactions;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamCallControlsThemeData copyWith({
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
    List<CallReactionData>? callReactions,
  }) {
    return StreamCallControlsThemeData(
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
      callReactions: callReactions ?? this.callReactions,
    );
  }

  /// Linearly interpolate between two [StreamCallControlsThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamCallControlsThemeData lerp(
    StreamCallControlsThemeData other,
    double t,
  ) {
    return StreamCallControlsThemeData(
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      optionIconColor: Color.lerp(optionIconColor, other.optionIconColor, t)!,
      inactiveOptionIconColor: Color.lerp(
        inactiveOptionIconColor,
        other.inactiveOptionIconColor,
        t,
      )!,
      optionElevation: lerpDouble(optionElevation, other.optionElevation, t)!,
      inactiveOptionElevation: lerpDouble(
        inactiveOptionElevation,
        other.inactiveOptionElevation,
        t,
      )!,
      optionBackgroundColor:
          Color.lerp(optionBackgroundColor, other.optionBackgroundColor, t)!,
      inactiveOptionBackgroundColor: Color.lerp(
        inactiveOptionBackgroundColor,
        other.inactiveOptionBackgroundColor,
        t,
      )!,
      optionShape: OutlinedBorder.lerp(optionShape, other.optionShape, t)!,
      optionPadding:
          EdgeInsetsGeometry.lerp(optionPadding, other.optionPadding, t)!,
      callReactions: other.callReactions,
    );
  }

  @override
  int get hashCode => Object.hash(
        borderRadius,
        backgroundColor,
        elevation,
        padding,
        spacing,
        optionIconColor,
        inactiveOptionIconColor,
        optionElevation,
        inactiveOptionElevation,
        optionBackgroundColor,
        inactiveOptionBackgroundColor,
        optionShape,
        optionPadding,
        callReactions,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamCallControlsThemeData &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.spacing == spacing &&
        other.optionIconColor == optionIconColor &&
        other.inactiveOptionIconColor == inactiveOptionIconColor &&
        other.optionElevation == optionElevation &&
        other.inactiveOptionElevation == inactiveOptionElevation &&
        other.optionBackgroundColor == optionBackgroundColor &&
        other.inactiveOptionBackgroundColor == inactiveOptionBackgroundColor &&
        other.optionShape == optionShape &&
        other.optionPadding == optionPadding &&
        other.callReactions == callReactions;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(DoubleProperty('spacing', spacing))
      ..add(ColorProperty('optionIconColor', optionIconColor))
      ..add(ColorProperty('inactiveOptionIconColor', inactiveOptionIconColor))
      ..add(DoubleProperty('optionElevation', optionElevation))
      ..add(DoubleProperty('inactiveOptionElevation', inactiveOptionElevation))
      ..add(ColorProperty('optionBackgroundColor', optionBackgroundColor))
      ..add(
        ColorProperty(
          'inactiveOptionBackgroundColor',
          inactiveOptionBackgroundColor,
        ),
      )
      ..add(DiagnosticsProperty<OutlinedBorder>('optionShape', optionShape))
      ..add(
        DiagnosticsProperty<EdgeInsetsGeometry>(
          'optionPadding',
          optionPadding,
        ),
      )
      ..add(
        DiagnosticsProperty<List<CallReactionData>>(
          'callReactions',
          callReactions,
        ),
      );
  }

  /// Merges one [StreamCallControlsThemeData] with the another.
  StreamCallControlsThemeData merge(StreamCallControlsThemeData? other) {
    if (other == null) return this;
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
      callReactions: other.callReactions,
    );
  }
}

/// Applies a call controls theme to descendant [StreamCallControls]
/// widgets.
class StreamCallControlsTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallControlsTheme].
  const StreamCallControlsTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamCallControls] widgets.
  final StreamCallControlsThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallControlsTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.callControlsTheme].
  static StreamCallControlsThemeData of(BuildContext context) {
    final callControlsTheme =
        context.dependOnInheritedWidgetOfExactType<StreamCallControlsTheme>();
    return callControlsTheme?.data ??
        StreamVideoTheme.of(context).callControlsTheme;
  }

  @override
  bool updateShouldNotify(StreamCallControlsTheme oldWidget) {
    return data != oldWidget.data;
  }
}
