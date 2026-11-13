import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'live_indicator_theme.g.theme.dart';

/// Overrides the [StreamLiveIndicatorStyle] of every [StreamLiveIndicator]
/// below it.
class StreamLiveIndicatorTheme extends InheritedTheme {
  /// Creates a [StreamLiveIndicatorTheme].
  const StreamLiveIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme applied to the indicators below this widget.
  final StreamLiveIndicatorThemeData data;

  /// The theme of the closest [StreamLiveIndicatorTheme] above [context],
  /// merged onto [StreamVideoTheme.liveIndicatorTheme].
  static StreamLiveIndicatorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamLiveIndicatorTheme>();
    return StreamVideoTheme.of(
      context,
    ).liveIndicatorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamLiveIndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamLiveIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for [StreamLiveIndicator].
@themeGen
@immutable
class StreamLiveIndicatorThemeData with _$StreamLiveIndicatorThemeData {
  /// Creates a [StreamLiveIndicatorThemeData].
  const StreamLiveIndicatorThemeData({this.style});

  /// The style applied to every [StreamLiveIndicator].
  final StreamLiveIndicatorStyle? style;

  /// Linearly interpolates between two [StreamLiveIndicatorThemeData]s.
  static StreamLiveIndicatorThemeData? lerp(
    StreamLiveIndicatorThemeData? a,
    StreamLiveIndicatorThemeData? b,
    double t,
  ) => _$StreamLiveIndicatorThemeData.lerp(a, b, t);
}

/// Visual properties of a [StreamLiveIndicator].
///
/// Anything left null falls back to the design-system tokens.
@themeGen
@immutable
class StreamLiveIndicatorStyle with _$StreamLiveIndicatorStyle {
  /// Creates a [StreamLiveIndicatorStyle].
  const StreamLiveIndicatorStyle({
    this.padding,
    this.spacing,
    this.dotSize,
    this.borderRadius,
    this.textStyle,
    this.liveBackgroundColor,
    this.liveForegroundColor,
    this.backstageBackgroundColor,
    this.backstageForegroundColor,
  });

  /// Padding around the dot and the label.
  final EdgeInsetsGeometry? padding;

  /// Gap between the dot and the label.
  final double? spacing;

  /// Diameter of the dot shown while the call is live.
  final double? dotSize;

  /// Corner radius of the pill.
  final BorderRadiusGeometry? borderRadius;

  /// Style of the label.
  final TextStyle? textStyle;

  /// Pill colour while the call is live.
  final Color? liveBackgroundColor;

  /// Dot and label colour while the call is live.
  final Color? liveForegroundColor;

  /// Pill colour while the call is in backstage.
  final Color? backstageBackgroundColor;

  /// Label colour while the call is in backstage.
  final Color? backstageForegroundColor;

  /// Linearly interpolates between two [StreamLiveIndicatorStyle]s.
  static StreamLiveIndicatorStyle? lerp(
    StreamLiveIndicatorStyle? a,
    StreamLiveIndicatorStyle? b,
    double t,
  ) => _$StreamLiveIndicatorStyle.lerp(a, b, t);
}
