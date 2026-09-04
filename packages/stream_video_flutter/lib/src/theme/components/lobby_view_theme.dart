import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'lobby_view_theme.g.theme.dart';

/// Applies a lobby theme to descendant [StreamLobbyView] widgets.
///
/// Wrap a subtree with [StreamLobbyViewTheme] to override how the waiting room
/// is drawn.
///
/// {@tool snippet}
///
/// Square the preview off and drop its accent border:
///
/// ```dart
/// StreamLobbyViewTheme(
///   data: StreamLobbyViewThemeData(
///     style: StreamLobbyViewStyle(
///       previewBorderRadius: BorderRadius.zero,
///       previewBorderWidth: 0,
///     ),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamLobbyViewThemeData], which describes the theme.
///  * [StreamLobbyViewStyle], the visual style it carries.
class StreamLobbyViewTheme extends InheritedTheme {
  /// Creates a lobby theme.
  const StreamLobbyViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The lobby theme data for descendant widgets.
  final StreamLobbyViewThemeData data;

  /// Returns the [StreamLobbyViewThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamLobbyViewTheme] ancestor take
  /// precedence over the global values from [StreamVideoTheme.lobbyViewTheme].
  /// This allows partial overrides: setting only
  /// [StreamLobbyViewStyle.previewBorderColor] leaves the remaining properties
  /// coming from the global theme.
  static StreamLobbyViewThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamLobbyViewTheme>();
    return StreamVideoTheme.of(context).lobbyViewTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamLobbyViewTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamLobbyViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamLobbyView] widgets.
///
/// See also:
///
///  * [StreamLobbyViewStyle], the style embedded here.
///  * [StreamLobbyViewTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamLobbyViewThemeData with _$StreamLobbyViewThemeData {
  /// Creates lobby theme data.
  const StreamLobbyViewThemeData({this.style});

  /// Visual styling for the lobby.
  final StreamLobbyViewStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamLobbyViewThemeData? lerp(
    StreamLobbyViewThemeData? a,
    StreamLobbyViewThemeData? b,
    double t,
  ) => _$StreamLobbyViewThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamLobbyView].
///
/// The lobby has two geometries, one for windows under
/// [StreamScreenSize.smallMaxWidth] and one for wider ones, so several
/// properties come in pairs. Which of the pair applies is the window's
/// business, not the theme's.
@themeGen
@immutable
class StreamLobbyViewStyle with _$StreamLobbyViewStyle {
  /// Creates a lobby style with optional property overrides.
  const StreamLobbyViewStyle({
    this.previewBorderRadius,
    this.previewBorderColor,
    this.previewBorderWidth,
    this.previewBackgroundColor,
    this.smallPreviewAspectRatio,
    this.largePreviewSize,
    this.sectionSpacing,
    this.headingSpacing,
    this.smallLaneSpacing,
    this.largeLaneSpacing,
    this.controlSpacing,
    this.settingSpacing,
    this.overlayControlInset,
    this.participantLabelInset,
    this.joinButtonWidth,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  /// The preview's corner radius.
  ///
  /// Defaults to `radius.xxl`.
  final BorderRadius? previewBorderRadius;

  /// The color of the accent ring around the preview.
  ///
  /// Defaults to `colorScheme.accentPrimary`.
  final Color? previewBorderColor;

  /// The thickness of the ring around the preview.
  ///
  /// Defaults to 2. Set to `0` to drop the ring; `null` means "no override"
  /// and leaves the default in place.
  final double? previewBorderWidth;

  /// What the preview shows behind the camera, or in place of it.
  ///
  /// Defaults to `colorScheme.backgroundSurface`.
  final Color? previewBackgroundColor;

  /// The preview's aspect below [StreamScreenSize.smallMaxWidth].
  ///
  /// Defaults to `370 / 264`.
  final double? smallPreviewAspectRatio;

  /// The preview's size at [StreamScreenSize.smallMaxWidth] and above.
  ///
  /// Its width also caps the settings row, so the fields line up under the
  /// preview. Defaults to `Size(640, 360)`.
  final Size? largePreviewSize;

  /// The gap between the heading, the preview block and the join button.
  ///
  /// Defaults to `spacing.xxl`.
  final double? sectionSpacing;

  /// The gap between the title and the subtitle.
  ///
  /// Defaults to `spacing.sm`.
  final double? headingSpacing;

  /// The gap between the preview, the control row and the settings row below
  /// [StreamScreenSize.smallMaxWidth].
  ///
  /// Defaults to `spacing.sm`.
  final double? smallLaneSpacing;

  /// The same gap at [StreamScreenSize.smallMaxWidth] and above.
  ///
  /// Defaults to `spacing.md`.
  final double? largeLaneSpacing;

  /// The gap between the buttons in the control row.
  ///
  /// Defaults to `spacing.xs`.
  final double? controlSpacing;

  /// The gap between the fields in the settings row.
  ///
  /// Defaults to `spacing.xs`.
  final double? settingSpacing;

  /// How far the overlaid control row sits above the preview's bottom edge.
  ///
  /// Only applies at [StreamScreenSize.smallMaxWidth] and above, where the
  /// controls are drawn on the preview. Defaults to `spacing.md`, which clears
  /// the participant label's band.
  final double? overlayControlInset;

  /// The inset of the participant label from the preview's bottom-start
  /// corner.
  ///
  /// Defaults to `spacing.sm`.
  final double? participantLabelInset;

  /// The width of the join button at [StreamScreenSize.smallMaxWidth] and
  /// above.
  ///
  /// Below it the button is always full width. Defaults to 400.
  final double? joinButtonWidth;

  /// The text style of the heading.
  ///
  /// Defaults to `textTheme.headingMd`.
  final TextStyle? titleTextStyle;

  /// The text style of the line below the heading.
  ///
  /// Defaults to `textTheme.bodyDefault`.
  final TextStyle? subtitleTextStyle;

  /// Linearly interpolate between two styles.
  static StreamLobbyViewStyle? lerp(
    StreamLobbyViewStyle? a,
    StreamLobbyViewStyle? b,
    double t,
  ) => _$StreamLobbyViewStyle.lerp(a, b, t);
}
