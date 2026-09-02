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
/// Give the preview a narrower join button than the default 400:
///
/// ```dart
/// StreamLobbyViewTheme(
///   data: StreamLobbyViewThemeData(
///     style: StreamLobbyViewStyle(joinButtonWidth: 280),
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
  /// [StreamLobbyViewStyle.joinButtonWidth] leaves the remaining properties
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
/// Deliberately small. The preview is a `StreamParticipantTile`, so its
/// appearance belongs to `StreamParticipantTileTheme`; the gaps between the
/// lobby's rows come from `StreamSpacing` and the headings from
/// `StreamTextTheme`, so an app restyles them by restyling those rather than
/// by respelling them here. What is left is the lobby's own geometry.
@themeGen
@immutable
class StreamLobbyViewStyle with _$StreamLobbyViewStyle {
  /// Creates a lobby style with optional property overrides.
  const StreamLobbyViewStyle({
    this.previewTileStyle,
    this.compactPreviewAspectRatio,
    this.expandedPreviewSize,
    this.maxOverlaidControls,
    this.joinButtonWidth,
  });

  /// Overrides for the participant tile the preview is drawn with.
  ///
  /// The preview *is* a `StreamParticipantTile`, so its surface, corner
  /// radius, name pill and placeholder avatar come from
  /// `StreamParticipantTileTheme` like every other tile's, and theming the
  /// call's tiles themes the lobby with them. Set this only to make the
  /// preview differ from the tiles in the call it leads to.
  final StreamParticipantTileStyle? previewTileStyle;

  /// The preview's aspect below [StreamScreenSize.smallMaxWidth].
  ///
  /// Named for the layout rather than the breakpoint: this applies to
  /// [StreamScreenSize.small] only, while [expandedPreviewSize] covers both
  /// `medium` and `large`, so calling them small and large would have made
  /// `large` mean two different things across two public types.
  ///
  /// Defaults to `370 / 264`.
  final double? compactPreviewAspectRatio;

  /// The preview's maximum width, and its aspect, at
  /// [StreamScreenSize.smallMaxWidth] and above.
  ///
  /// A cap rather than a fixed size: a window past the breakpoint but
  /// narrower than this gets a smaller preview of the same shape. Its width
  /// also caps the settings row, so the fields line up under the preview.
  ///
  /// Defaults to `Size(640, 360)`. See [compactPreviewAspectRatio] on the
  /// naming.
  final Size? expandedPreviewSize;

  /// How many controls may be drawn on top of the preview.
  ///
  /// The overlaid row is centred on a preview whose bottom-start corner is
  /// already occupied by the participant label, so a long row runs into it.
  /// Past this count the row moves below the preview instead, whatever the
  /// screen size. Defaults to 3.
  ///
  /// Interpolates as a step, so a theme animation moves the row from overlaid
  /// to below partway through rather than sliding it.
  final int? maxOverlaidControls;

  /// The width of the join button at [StreamScreenSize.smallMaxWidth] and
  /// above.
  ///
  /// Below it the button is always full width. Defaults to 400.
  final double? joinButtonWidth;

  /// Linearly interpolate between two styles.
  static StreamLobbyViewStyle? lerp(
    StreamLobbyViewStyle? a,
    StreamLobbyViewStyle? b,
    double t,
  ) => _$StreamLobbyViewStyle.lerp(a, b, t);
}
