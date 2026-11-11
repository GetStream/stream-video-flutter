import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'livestream_tile_theme.g.theme.dart';

/// Overrides the [StreamLivestreamTileStyle] of every [StreamLivestreamTile]
/// below it.
class StreamLivestreamTileTheme extends InheritedTheme {
  /// Creates a [StreamLivestreamTileTheme].
  const StreamLivestreamTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme applied to the tiles below this widget.
  final StreamLivestreamTileThemeData data;

  /// The theme of the closest [StreamLivestreamTileTheme] above [context],
  /// merged onto [StreamVideoTheme.livestreamTileTheme].
  static StreamLivestreamTileThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamLivestreamTileTheme>();
    return StreamVideoTheme.of(
      context,
    ).livestreamTileTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamLivestreamTileTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamLivestreamTileTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for [StreamLivestreamTile].
@themeGen
@immutable
class StreamLivestreamTileThemeData with _$StreamLivestreamTileThemeData {
  /// Creates a [StreamLivestreamTileThemeData].
  const StreamLivestreamTileThemeData({this.style});

  /// The style applied to every [StreamLivestreamTile].
  final StreamLivestreamTileStyle? style;

  /// Linearly interpolates between two [StreamLivestreamTileThemeData]s.
  static StreamLivestreamTileThemeData? lerp(
    StreamLivestreamTileThemeData? a,
    StreamLivestreamTileThemeData? b,
    double t,
  ) => _$StreamLivestreamTileThemeData.lerp(a, b, t);
}

/// Visual properties of a [StreamLivestreamTile].
///
/// Anything left null falls back to the design-system tokens.
@themeGen
@immutable
class StreamLivestreamTileStyle with _$StreamLivestreamTileStyle {
  /// Creates a [StreamLivestreamTileStyle].
  const StreamLivestreamTileStyle({
    this.toolbarPadding,
    this.toolbarSpacing,
    this.leadingSpacing,
    this.trailingSpacing,
    this.buttonSize,
  });

  /// Padding around the toolbar at the bottom of the tile.
  final EdgeInsetsGeometry? toolbarPadding;

  /// Gap between the leading indicators and the trailing buttons.
  final double? toolbarSpacing;

  /// Gap between the live indicator and the spectators indicator.
  final double? leadingSpacing;

  /// Gap between the speakerphone and fullscreen buttons.
  final double? trailingSpacing;

  /// Size of the speakerphone and fullscreen buttons.
  final StreamButtonSize? buttonSize;

  /// Linearly interpolates between two [StreamLivestreamTileStyle]s.
  static StreamLivestreamTileStyle? lerp(
    StreamLivestreamTileStyle? a,
    StreamLivestreamTileStyle? b,
    double t,
  ) => _$StreamLivestreamTileStyle.lerp(a, b, t);
}
