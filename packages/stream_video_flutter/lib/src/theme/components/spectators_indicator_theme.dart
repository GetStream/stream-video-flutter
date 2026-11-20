import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'spectators_indicator_theme.g.theme.dart';

/// Overrides the [StreamSpectatorsIndicatorStyle] of every
/// [StreamSpectatorsIndicator] below it.
class StreamSpectatorsIndicatorTheme extends InheritedTheme {
  /// Creates a [StreamSpectatorsIndicatorTheme].
  const StreamSpectatorsIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme applied to the indicators below this widget.
  final StreamSpectatorsIndicatorThemeData data;

  /// The theme of the closest [StreamSpectatorsIndicatorTheme] above
  /// [context], merged onto [StreamVideoTheme.spectatorsIndicatorTheme].
  static StreamSpectatorsIndicatorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamSpectatorsIndicatorTheme>();
    return StreamVideoTheme.of(
      context,
    ).spectatorsIndicatorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamSpectatorsIndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamSpectatorsIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for [StreamSpectatorsIndicator].
@themeGen
@immutable
class StreamSpectatorsIndicatorThemeData
    with _$StreamSpectatorsIndicatorThemeData {
  /// Creates a [StreamSpectatorsIndicatorThemeData].
  const StreamSpectatorsIndicatorThemeData({this.style});

  /// The style applied to every [StreamSpectatorsIndicator].
  final StreamSpectatorsIndicatorStyle? style;

  /// Linearly interpolates between two [StreamSpectatorsIndicatorThemeData]s.
  static StreamSpectatorsIndicatorThemeData? lerp(
    StreamSpectatorsIndicatorThemeData? a,
    StreamSpectatorsIndicatorThemeData? b,
    double t,
  ) => _$StreamSpectatorsIndicatorThemeData.lerp(a, b, t);
}

/// Visual properties of a [StreamSpectatorsIndicator].
///
/// Anything left null falls back to the design-system tokens.
@themeGen
@immutable
class StreamSpectatorsIndicatorStyle with _$StreamSpectatorsIndicatorStyle {
  /// Creates a [StreamSpectatorsIndicatorStyle].
  const StreamSpectatorsIndicatorStyle({
    this.padding,
    this.spacing,
    this.iconSize,
    this.borderRadius,
    this.backgroundColor,
    this.iconColor,
    this.textStyle,
  });

  /// Padding around the icon and the count.
  final EdgeInsetsGeometry? padding;

  /// Gap between the icon and the count.
  final double? spacing;

  /// Size of the eye icon.
  final double? iconSize;

  /// Corner radius of the pill.
  final BorderRadiusGeometry? borderRadius;

  /// Pill colour.
  final Color? backgroundColor;

  /// Colour of the eye icon.
  final Color? iconColor;

  /// Style of the count.
  final TextStyle? textStyle;

  /// Linearly interpolates between two [StreamSpectatorsIndicatorStyle]s.
  static StreamSpectatorsIndicatorStyle? lerp(
    StreamSpectatorsIndicatorStyle? a,
    StreamSpectatorsIndicatorStyle? b,
    double t,
  ) => _$StreamSpectatorsIndicatorStyle.lerp(a, b, t);
}
