import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_latency_badge_theme.g.theme.dart';

/// Applies a badge theme to descendant [StreamCallLatencyBadge] widgets.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallLatencyBadgeTheme(
///   data: StreamCallLatencyBadgeThemeData(
///     style: StreamCallLatencyBadgeStyle(poorColor: Colors.orange),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallLatencyBadgeThemeData], which describes the theme.
///  * [StreamCallLatencyBadgeStyle], the visual style it carries.
class StreamCallLatencyBadgeTheme extends InheritedTheme {
  /// Creates a badge theme.
  const StreamCallLatencyBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The badge theme data for descendant widgets.
  final StreamCallLatencyBadgeThemeData data;

  /// Returns the [StreamCallLatencyBadgeThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamCallLatencyBadgeTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.callLatencyBadgeTheme].
  static StreamCallLatencyBadgeThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallLatencyBadgeTheme>();
    return StreamVideoTheme.of(
      context,
    ).callLatencyBadgeTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallLatencyBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallLatencyBadgeTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamCallLatencyBadge] widgets.
///
/// See also:
///
///  * [StreamCallLatencyBadgeStyle], the style embedded here.
///  * [StreamCallLatencyBadgeTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallLatencyBadgeThemeData with _$StreamCallLatencyBadgeThemeData {
  /// Creates badge theme data.
  const StreamCallLatencyBadgeThemeData({this.style});

  /// Visual styling for the badge.
  final StreamCallLatencyBadgeStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallLatencyBadgeThemeData? lerp(
    StreamCallLatencyBadgeThemeData? a,
    StreamCallLatencyBadgeThemeData? b,
    double t,
  ) => _$StreamCallLatencyBadgeThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamCallLatencyBadge].
///
/// Defaults that differ between desktop and web on one side and mobile on the
/// other are noted per field.
@themeGen
@immutable
class StreamCallLatencyBadgeStyle with _$StreamCallLatencyBadgeStyle {
  /// Creates a badge style with optional property overrides.
  const StreamCallLatencyBadgeStyle({
    this.padding,
    this.contentHeight,
    this.spacing,
    this.dotSize,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
    this.unitTextColor,
    this.greatColor,
    this.fairColor,
    this.poorColor,
    this.unknownColor,
  });

  /// The padding between the pill's edge and its content.
  ///
  /// Defaults to `spacing.xs` horizontally and `spacing.xxs + spacing.xxxs`
  /// vertically, which puts a 20 tall row in a 32 tall pill.
  final EdgeInsetsGeometry? padding;

  /// The height the content is held to. Defaults to 20.
  final double? contentHeight;

  /// The gap between the dot and the reading. Defaults to `spacing.xs`.
  final double? spacing;

  /// The diameter of the dot. Defaults to 8.
  final double? dotSize;

  /// The pill's fill. Defaults to `colorScheme.backgroundSurface`.
  final Color? backgroundColor;

  /// The pill's corners. Defaults to `radius.xxxl` on every corner.
  final BorderRadiusGeometry? borderRadius;

  /// The reading's style.
  ///
  /// Defaults to `textTheme.captionEmphasis` on desktop and web and
  /// `textTheme.bodyEmphasis` on mobile, in `colorScheme.textPrimary`, at
  /// `height: 1` and with tabular figures.
  final TextStyle? textStyle;

  /// The colour of the `ms` unit. Defaults to `colorScheme.textTertiary`.
  final Color? unitTextColor;

  /// The dot's colour at a great latency. Defaults to
  /// `colorScheme.accentSuccess`.
  final Color? greatColor;

  /// The dot's colour at a fair latency. Defaults to
  /// `colorScheme.accentWarning`.
  final Color? fairColor;

  /// The dot's colour at a poor latency. Defaults to
  /// `colorScheme.accentError`.
  final Color? poorColor;

  /// The dot's colour before the first measurement. Defaults to
  /// `colorScheme.textTertiary`.
  final Color? unknownColor;

  /// Linearly interpolate between two styles.
  static StreamCallLatencyBadgeStyle? lerp(
    StreamCallLatencyBadgeStyle? a,
    StreamCallLatencyBadgeStyle? b,
    double t,
  ) => _$StreamCallLatencyBadgeStyle.lerp(a, b, t);
}
