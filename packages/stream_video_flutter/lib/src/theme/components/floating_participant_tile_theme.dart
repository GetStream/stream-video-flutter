import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'floating_participant_tile_theme.g.theme.dart';

/// Applies a floating participant tile theme to descendant
/// `StreamFloatingParticipantTile` widgets.
///
/// See also:
///
///  * [StreamFloatingParticipantTileThemeData], which describes the theme.
///  * [StreamFloatingParticipantTileStyle], the visual style it carries.
class StreamFloatingParticipantTileTheme extends InheritedTheme {
  /// Creates a floating participant tile theme.
  const StreamFloatingParticipantTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The floating tile theme data for descendant widgets.
  final StreamFloatingParticipantTileThemeData data;

  /// Returns the [StreamFloatingParticipantTileThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamFloatingParticipantTileTheme]
  /// ancestor take precedence over the global values from
  /// [StreamVideoTheme.floatingParticipantTileTheme].
  static StreamFloatingParticipantTileThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<
          StreamFloatingParticipantTileTheme
        >();
    return StreamVideoTheme.of(
      context,
    ).floatingParticipantTileTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamFloatingParticipantTileTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamFloatingParticipantTileTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing `StreamFloatingParticipantTile` widgets.
///
/// See also:
///
///  * [StreamFloatingParticipantTileStyle], the style embedded here.
///  * [StreamFloatingParticipantTileTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamFloatingParticipantTileThemeData
    with _$StreamFloatingParticipantTileThemeData {
  /// Creates floating participant tile theme data.
  const StreamFloatingParticipantTileThemeData({this.style});

  /// Visual styling for the floating tile.
  final StreamFloatingParticipantTileStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamFloatingParticipantTileThemeData? lerp(
    StreamFloatingParticipantTileThemeData? a,
    StreamFloatingParticipantTileThemeData? b,
    double t,
  ) => _$StreamFloatingParticipantTileThemeData.lerp(a, b, t);
}

/// Visual styling properties for a `StreamFloatingParticipantTile`.
///
/// The floating tile is the draggable self-view that sits on top of the call.
/// It is a participant tile plus the state that only a floating surface has:
/// where it starts, whether it snaps to a corner, and how far it lifts off the
/// content below.
@themeGen
@immutable
class StreamFloatingParticipantTileStyle
    with _$StreamFloatingParticipantTileStyle {
  /// Creates a floating tile style with optional property overrides.
  const StreamFloatingParticipantTileStyle({
    this.size,
    this.padding,
    this.borderRadius,
    this.border,
    this.elevation,
    this.shadowColor,
    this.initialAlignment,
    this.enableSnapping,
    this.tileStyle,
  });

  /// The dimensions of the floating view.
  ///
  /// Defaults to 140x228.
  final Size? size;

  /// The inset between the floating view and the edges of its container.
  ///
  /// Defaults to `spacing.md`.
  final double? padding;

  /// The corner radius of the floating view.
  ///
  /// Smaller than a grid tile's — defaults to `radius.lg`.
  final BorderRadius? borderRadius;

  /// The hairline around the floating view.
  ///
  /// Translucent by default (`colorScheme.borderOpacitySubtle`) rather than the
  /// grid tile's opaque border, because the floating view sits on top of video
  /// rather than on a surface.
  final BoxBorder? border;

  /// How far the floating view lifts off the content below it.
  ///
  /// Rendered through a a `Material` rather than a hand-painted shadow, so it
  /// matches every other elevated Stream surface. Defaults to
  /// `elevation.level2`.
  final double? elevation;

  /// The color of the elevation shadow.
  ///
  /// Defaults to the host app's `ThemeData.shadowColor`.
  final Color? shadowColor;

  /// The corner the floating view starts in.
  ///
  /// Defaults to [FloatingViewAlignment.topRight].
  final FloatingViewAlignment? initialAlignment;

  /// Whether the floating view snaps to the nearest corner when released.
  ///
  /// Defaults to true.
  final bool? enableSnapping;

  /// Overrides applied to the participant tile rendered inside.
  ///
  /// Merged over the ambient [StreamParticipantTileTheme] style, so an app-wide
  /// tile customization still reaches the self-view. Defaults to a tile with no
  /// name pill, no overflow button and no speaking border — at this size only
  /// the connection quality indicator is legible.
  final StreamParticipantTileStyle? tileStyle;

  /// Linearly interpolate between two styles.
  static StreamFloatingParticipantTileStyle? lerp(
    StreamFloatingParticipantTileStyle? a,
    StreamFloatingParticipantTileStyle? b,
    double t,
  ) => _$StreamFloatingParticipantTileStyle.lerp(a, b, t);
}
