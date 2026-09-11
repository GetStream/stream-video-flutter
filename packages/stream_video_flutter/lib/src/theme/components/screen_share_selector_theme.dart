import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'screen_share_selector_theme.g.theme.dart';

/// Applies a screen share selector theme to descendant
/// [StreamScreenShareSelector] widgets.
///
/// Wrap a subtree with [StreamScreenShareSelectorTheme] to override the
/// styling of the grid a desktop user picks a screen or window from.
///
/// {@tool snippet}
///
/// Draw the sources two to a row, in taller tiles:
///
/// ```dart
/// StreamScreenShareSelectorTheme(
///   data: StreamScreenShareSelectorThemeData(
///     style: StreamScreenShareSelectorStyle(
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
///  * [StreamScreenShareSelectorThemeData], which describes the theme.
///  * [StreamScreenShareSelectorStyle], the visual style it carries.
class StreamScreenShareSelectorTheme extends InheritedTheme {
  /// Creates a screen share selector theme.
  const StreamScreenShareSelectorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The selector theme data for descendant widgets.
  final StreamScreenShareSelectorThemeData data;

  /// Returns the [StreamScreenShareSelectorThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamScreenShareSelectorTheme] ancestor
  /// take precedence over the global values from
  /// [StreamVideoTheme.screenShareSelectorTheme]. This allows partial
  /// overrides: setting only [StreamScreenShareSelectorStyle.crossAxisCount]
  /// leaves the remaining properties coming from the global theme.
  static StreamScreenShareSelectorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamScreenShareSelectorTheme>();
    return StreamVideoTheme.of(
      context,
    ).screenShareSelectorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamScreenShareSelectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamScreenShareSelectorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamScreenShareSelector] widgets.
///
/// Wraps a [StreamScreenShareSelectorStyle] so it can be served by
/// [StreamScreenShareSelectorTheme] and slotted into [StreamVideoTheme]
/// alongside the other component theme data classes.
///
/// See also:
///
///  * [StreamScreenShareSelectorStyle], the style embedded here.
///  * [StreamScreenShareSelectorTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamScreenShareSelectorThemeData
    with _$StreamScreenShareSelectorThemeData {
  /// Creates screen share selector theme data.
  const StreamScreenShareSelectorThemeData({this.style});

  /// Visual styling for the selector.
  final StreamScreenShareSelectorStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamScreenShareSelectorThemeData? lerp(
    StreamScreenShareSelectorThemeData? a,
    StreamScreenShareSelectorThemeData? b,
    double t,
  ) => _$StreamScreenShareSelectorThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamScreenShareSelector].
///
/// The selector is a grid of thumbnails, one per screen or window the platform
/// offers, with the picked one outlined in the accent color.
@themeGen
@immutable
class StreamScreenShareSelectorStyle with _$StreamScreenShareSelectorStyle {
  /// Creates a selector style with optional property overrides.
  const StreamScreenShareSelectorStyle({
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
    this.thumbnailSize,
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

  /// The resolution asked of the platform for each thumbnail.
  ///
  /// Defaults to 480x300. The platform captures and encodes one bitmap per
  /// screen and window at this size, and the grid decodes all of them, so a
  /// larger value costs on both sides for detail a tile this size cannot
  /// show.
  final Size? thumbnailSize;

  /// Linearly interpolate between two styles.
  static StreamScreenShareSelectorStyle? lerp(
    StreamScreenShareSelectorStyle? a,
    StreamScreenShareSelectorStyle? b,
    double t,
  ) => _$StreamScreenShareSelectorStyle.lerp(a, b, t);
}
