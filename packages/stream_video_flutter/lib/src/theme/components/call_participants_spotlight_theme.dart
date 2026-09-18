import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_participants_spotlight_theme.g.theme.dart';

/// Applies a spotlight theme to descendant [CallParticipantsSpotlightView]
/// widgets.
///
/// Wrap a subtree with [StreamCallParticipantsSpotlightTheme] to override how
/// the speaker layouts are arranged.
///
/// {@tool snippet}
///
/// Give the bar taller tiles than the default on a phone:
///
/// ```dart
/// StreamCallParticipantsSpotlightTheme(
///   data: StreamCallParticipantsSpotlightThemeData(
///     style: StreamCallParticipantsSpotlightStyle(
///       compactBarTileSize: Size(212, 159),
///     ),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallParticipantsSpotlightThemeData], which describes the theme.
///  * [StreamCallParticipantsSpotlightStyle], the visual style it carries.
class StreamCallParticipantsSpotlightTheme extends InheritedTheme {
  /// Creates a spotlight theme.
  const StreamCallParticipantsSpotlightTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The spotlight theme data for descendant widgets.
  final StreamCallParticipantsSpotlightThemeData data;

  /// Returns the [StreamCallParticipantsSpotlightThemeData] merged from local
  /// and global themes.
  ///
  /// Local values from the nearest [StreamCallParticipantsSpotlightTheme]
  /// ancestor take precedence over the global values from
  /// [StreamVideoTheme.callParticipantsSpotlightTheme]. This allows partial
  /// overrides: setting only
  /// [StreamCallParticipantsSpotlightStyle.maxSpotlightAspectRatio] leaves the
  /// remaining properties coming from the global theme.
  static StreamCallParticipantsSpotlightThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<
          StreamCallParticipantsSpotlightTheme
        >();
    return StreamVideoTheme.of(
      context,
    ).callParticipantsSpotlightTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallParticipantsSpotlightTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallParticipantsSpotlightTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [CallParticipantsSpotlightView] widgets.
///
/// See also:
///
///  * [StreamCallParticipantsSpotlightStyle], the style embedded here.
///  * [StreamCallParticipantsSpotlightTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallParticipantsSpotlightThemeData
    with _$StreamCallParticipantsSpotlightThemeData {
  /// Creates spotlight theme data.
  const StreamCallParticipantsSpotlightThemeData({this.style});

  /// Visual styling for the speaker layouts.
  final StreamCallParticipantsSpotlightStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallParticipantsSpotlightThemeData? lerp(
    StreamCallParticipantsSpotlightThemeData? a,
    StreamCallParticipantsSpotlightThemeData? b,
    double t,
  ) => _$StreamCallParticipantsSpotlightThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [CallParticipantsSpotlightView].
///
/// The layout is a stage and a bar of the participants who are not on it. The
/// bar's tile size follows the window's [StreamScreenSize], so it comes in one
/// property per breakpoint; the stage takes whatever the bar leaves.
///
/// Deliberately small. The tiles are `StreamParticipantTile`s, so their
/// surface, corner radius and name pill come from `StreamParticipantTileTheme`
/// like every other tile's. What is left is the layout's own geometry.
@themeGen
@immutable
class StreamCallParticipantsSpotlightStyle
    with _$StreamCallParticipantsSpotlightStyle {
  /// Creates a spotlight style with optional property overrides.
  const StreamCallParticipantsSpotlightStyle({
    this.padding,
    this.spacing,
    this.maxSpotlightAspectRatio,
    this.compactBarTileSize,
    this.barTileSize,
    this.expandedBarTileSize,
  });

  /// Padding around the stage and the bar together.
  ///
  /// Horizontal only by default: the stage sits flush under whatever is above
  /// it and the bar flush on whatever is below, so the call's own chrome
  /// provides the vertical breathing room.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: StreamSpacing.xs)`.
  final EdgeInsetsGeometry? padding;

  /// The gap between the stage and the bar, and between the bar's tiles.
  ///
  /// Defaults to `StreamSpacing.xs`.
  final double? spacing;

  /// The widest the stage is drawn, as a width-to-height ratio.
  ///
  /// The stage fills whatever the bar leaves at every size; this is the one
  /// thing that holds it back. A view wider than this keeps the stage centred
  /// in it rather than stretching it, so nobody is drawn letterboxed into a
  /// strip. A view narrower than it — a phone held upright — gets a stage
  /// taller than the ratio, which is what the room allows.
  ///
  /// Defaults to `16 / 9`.
  final double? maxSpotlightAspectRatio;

  /// The size of a bar tile at [StreamScreenSize.small].
  ///
  /// Defaults to `Size(188, 141)`.
  final Size? compactBarTileSize;

  /// The size of a bar tile at [StreamScreenSize.medium].
  ///
  /// Defaults to `Size(284, 160)`.
  final Size? barTileSize;

  /// The size of a bar tile at [StreamScreenSize.large].
  ///
  /// Defaults to `Size(295, 166)`.
  final Size? expandedBarTileSize;

  /// Linearly interpolate between two styles.
  static StreamCallParticipantsSpotlightStyle? lerp(
    StreamCallParticipantsSpotlightStyle? a,
    StreamCallParticipantsSpotlightStyle? b,
    double t,
  ) => _$StreamCallParticipantsSpotlightStyle.lerp(a, b, t);
}
