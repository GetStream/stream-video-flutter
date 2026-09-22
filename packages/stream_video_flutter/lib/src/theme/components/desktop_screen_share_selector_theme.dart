import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'desktop_screen_share_selector_theme.g.theme.dart';

/// Applies a desktop screen share selector theme to descendant
/// [StreamDesktopScreenShareSelector] widgets.
///
/// Wrap a subtree with [StreamDesktopScreenShareSelectorTheme] to override the
/// styling of the grid a desktop user picks a screen or window from.
///
/// {@tool snippet}
///
/// Draw the sources two to a row, in taller tiles:
///
/// ```dart
/// StreamDesktopScreenShareSelectorTheme(
///   data: StreamDesktopScreenShareSelectorThemeData(
///     style: StreamDesktopScreenShareSelectorStyle(
///       crossAxisCount: 2,
///       tileHeight: 220,
///     ),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamDesktopScreenShareSelectorThemeData], which describes the theme.
///  * [StreamDesktopScreenShareSelectorStyle], the visual style it carries.
class StreamDesktopScreenShareSelectorTheme extends InheritedTheme {
  /// Creates a screen share selector theme.
  const StreamDesktopScreenShareSelectorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The selector theme data for descendant widgets.
  final StreamDesktopScreenShareSelectorThemeData data;

  /// Returns the [StreamDesktopScreenShareSelectorThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamDesktopScreenShareSelectorTheme] ancestor
  /// take precedence over the global values from
  /// [StreamVideoTheme.desktopScreenShareSelectorTheme]. This allows partial
  /// overrides: setting only [StreamDesktopScreenShareSelectorStyle.crossAxisCount]
  /// leaves the remaining properties coming from the global theme.
  static StreamDesktopScreenShareSelectorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<
          StreamDesktopScreenShareSelectorTheme
        >();
    return StreamVideoTheme.of(
      context,
    ).desktopScreenShareSelectorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamDesktopScreenShareSelectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamDesktopScreenShareSelectorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamDesktopScreenShareSelector] widgets.
///
/// Wraps a [StreamDesktopScreenShareSelectorStyle] so it can be served by
/// [StreamDesktopScreenShareSelectorTheme] and slotted into [StreamVideoTheme]
/// alongside the other component theme data classes.
///
/// See also:
///
///  * [StreamDesktopScreenShareSelectorStyle], the style embedded here.
///  * [StreamDesktopScreenShareSelectorTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamDesktopScreenShareSelectorThemeData
    with _$StreamDesktopScreenShareSelectorThemeData {
  /// Creates screen share selector theme data.
  const StreamDesktopScreenShareSelectorThemeData({this.style});

  /// Visual styling for the selector.
  final StreamDesktopScreenShareSelectorStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamDesktopScreenShareSelectorThemeData? lerp(
    StreamDesktopScreenShareSelectorThemeData? a,
    StreamDesktopScreenShareSelectorThemeData? b,
    double t,
  ) => _$StreamDesktopScreenShareSelectorThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamDesktopScreenShareSelector].
///
/// The selector is a grid of thumbnails, one per screen or window the platform
/// offers, with the picked one outlined in the accent color.
@themeGen
@immutable
class StreamDesktopScreenShareSelectorStyle
    with _$StreamDesktopScreenShareSelectorStyle {
  /// Creates a selector style with optional property overrides.
  const StreamDesktopScreenShareSelectorStyle({
    this.padding,
    this.crossAxisCount,
    this.spacing,
    this.tileHeight,
    this.tilePadding,
    this.tileSpacing,
    this.tileBorderRadius,
    this.imageBorderRadius,
    this.borderColor,
    this.borderWidth,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.placeholderColor,
    this.labelTextStyle,
    this.labelColor,
    this.selectedLabelColor,
  });

  /// The inset around the grid.
  ///
  /// Defaults to `spacing.xxl` on every side.
  final EdgeInsetsGeometry? padding;

  /// How many tiles fit in a row.
  ///
  /// Defaults to 3.
  final int? crossAxisCount;

  /// The gap between tiles, in both directions.
  ///
  /// Defaults to `spacing.md`.
  final double? spacing;

  /// The height of a tile, thumbnail and label together.
  ///
  /// Defaults to 164.
  final double? tileHeight;

  /// The inset between a tile's border and its contents.
  ///
  /// Defaults to `spacing.xs` on every side.
  final EdgeInsetsGeometry? tilePadding;

  /// The gap between a tile's thumbnail and its label.
  ///
  /// Defaults to `spacing.xs`.
  final double? tileSpacing;

  /// The corner radius of a tile.
  ///
  /// Defaults to `radius.xl`.
  final BorderRadius? tileBorderRadius;

  /// The corner radius of the thumbnail inside a tile.
  ///
  /// Defaults to `radius.md`.
  final BorderRadius? imageBorderRadius;

  /// The color of an unselected tile's border.
  ///
  /// Defaults to `colorScheme.borderDefault`.
  final Color? borderColor;

  /// The width of an unselected tile's border.
  ///
  /// Defaults to 1. Both border widths paint inside the tile, so a tile does
  /// not resize as it is selected.
  final double? borderWidth;

  /// The color of the selected tile's border.
  ///
  /// Defaults to `colorScheme.accentPrimary`.
  final Color? selectedBorderColor;

  /// The width of the selected tile's border.
  ///
  /// Defaults to 2.
  final double? selectedBorderWidth;

  /// The fill drawn where a source has no thumbnail yet.
  ///
  /// Defaults to `colorScheme.backgroundSurfaceSubtle`.
  final Color? placeholderColor;

  /// The text style of a tile's label.
  ///
  /// Defaults to `textTheme.captionEmphasis`.
  final TextStyle? labelTextStyle;

  /// The color of an unselected tile's label.
  ///
  /// Defaults to `colorScheme.textTertiary`.
  final Color? labelColor;

  /// The color of the selected tile's label.
  ///
  /// Defaults to `colorScheme.accentPrimary`.
  final Color? selectedLabelColor;

  /// Linearly interpolate between two styles.
  static StreamDesktopScreenShareSelectorStyle? lerp(
    StreamDesktopScreenShareSelectorStyle? a,
    StreamDesktopScreenShareSelectorStyle? b,
    double t,
  ) => _$StreamDesktopScreenShareSelectorStyle.lerp(a, b, t);
}
