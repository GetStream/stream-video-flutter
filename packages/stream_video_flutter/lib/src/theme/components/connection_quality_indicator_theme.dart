import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'connection_quality_indicator_theme.g.theme.dart';

/// Applies a connection quality indicator theme to descendant
/// `StreamConnectionQualityIndicator` widgets.
///
/// Wrap a subtree with [StreamConnectionQualityIndicatorTheme] to override the
/// indicator's styling.
///
/// {@tool snippet}
///
/// Paint the indicator's bars in a single color rather than one per level:
///
/// ```dart
/// StreamConnectionQualityIndicatorTheme(
///   data: StreamConnectionQualityIndicatorThemeData(
///     style: StreamConnectionQualityIndicatorStyle(
///       poorColor: Colors.white,
///       fairColor: Colors.white,
///       greatColor: Colors.white,
///     ),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamConnectionQualityIndicatorThemeData], which describes the theme.
///  * [StreamConnectionQualityIndicatorStyle], the visual style it carries.
class StreamConnectionQualityIndicatorTheme extends InheritedTheme {
  /// Creates a connection quality indicator theme.
  const StreamConnectionQualityIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The indicator theme data for descendant widgets.
  final StreamConnectionQualityIndicatorThemeData data;

  /// Returns the [StreamConnectionQualityIndicatorThemeData] merged from local
  /// and global themes.
  ///
  /// Local values from the nearest [StreamConnectionQualityIndicatorTheme]
  /// ancestor take precedence over the global values from
  /// [StreamVideoTheme.connectionQualityIndicatorTheme]. This allows partial
  /// overrides: setting only [StreamConnectionQualityIndicatorStyle.size]
  /// leaves the colors coming from the global theme.
  static StreamConnectionQualityIndicatorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<
          StreamConnectionQualityIndicatorTheme
        >();
    return StreamVideoTheme.of(
      context,
    ).connectionQualityIndicatorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamConnectionQualityIndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamConnectionQualityIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing `StreamConnectionQualityIndicator` widgets.
///
/// Wraps a [StreamConnectionQualityIndicatorStyle] so it can be served by
/// [StreamConnectionQualityIndicatorTheme] and slotted into [StreamVideoTheme]
/// alongside the other component theme data classes.
///
/// See also:
///
///  * [StreamConnectionQualityIndicatorStyle], the style embedded here.
///  * [StreamConnectionQualityIndicatorTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamConnectionQualityIndicatorThemeData
    with _$StreamConnectionQualityIndicatorThemeData {
  /// Creates connection quality indicator theme data.
  const StreamConnectionQualityIndicatorThemeData({this.style});

  /// Visual styling for the indicator.
  final StreamConnectionQualityIndicatorStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamConnectionQualityIndicatorThemeData? lerp(
    StreamConnectionQualityIndicatorThemeData? a,
    StreamConnectionQualityIndicatorThemeData? b,
    double t,
  ) => _$StreamConnectionQualityIndicatorThemeData.lerp(a, b, t);
}

/// Visual styling properties for a `StreamConnectionQualityIndicator`.
///
/// The indicator is a round chip holding three bars. How many bars are lit
/// reflects the reported quality, and the color of the lit bars reflects it as
/// well: [poorColor], [fairColor] and [greatColor] are separate so a glance at
/// the color is enough, without counting bars.
///
/// Exposed separately from [StreamConnectionQualityIndicatorThemeData] so other
/// theme data classes can embed an indicator style via a typed field — see
/// [StreamParticipantTileStyle.connectionQualityIndicatorStyle].
@themeGen
@immutable
class StreamConnectionQualityIndicatorStyle
    with _$StreamConnectionQualityIndicatorStyle {
  /// Creates an indicator style with optional property overrides.
  const StreamConnectionQualityIndicatorStyle({
    this.size,
    this.backgroundColor,
    this.iconSize,
    this.poorColor,
    this.fairColor,
    this.greatColor,
    this.inactiveColor,
  });

  /// The diameter of the chip.
  ///
  /// Defaults to 32.
  final double? size;

  /// The fill behind the bars.
  ///
  /// Defaults to `colorScheme.backgroundOverlayDarkStrong`, which stays legible
  /// on top of video.
  final Color? backgroundColor;

  /// The side length of the bars glyph inside the chip.
  ///
  /// Defaults to 24.
  final double? iconSize;

  /// The color of the lit bars at the weakest quality level.
  ///
  /// Defaults to `colorScheme.accentError`.
  final Color? poorColor;

  /// The color of the lit bars at the middle quality level.
  ///
  /// Defaults to `colorScheme.accentWarning`.
  final Color? fairColor;

  /// The color of the lit bars at the strongest quality level.
  ///
  /// Defaults to `colorScheme.accentSuccess`.
  final Color? greatColor;

  /// The color of the bars above the reported quality level.
  ///
  /// Defaults to `colorScheme.textOnAccent` at reduced opacity.
  final Color? inactiveColor;

  /// Linearly interpolate between two styles.
  static StreamConnectionQualityIndicatorStyle? lerp(
    StreamConnectionQualityIndicatorStyle? a,
    StreamConnectionQualityIndicatorStyle? b,
    double t,
  ) => _$StreamConnectionQualityIndicatorStyle.lerp(a, b, t);
}
