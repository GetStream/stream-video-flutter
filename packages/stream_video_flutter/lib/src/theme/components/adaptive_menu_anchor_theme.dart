import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'adaptive_menu_anchor_theme.g.theme.dart';

/// Applies a [StreamAdaptiveMenuAnchorThemeData] to descendant
/// [StreamAdaptiveMenuAnchor]s.
///
/// Values set here override the ones on [StreamVideoTheme.adaptiveMenuAnchorTheme]
/// for this subtree, and any left null are inherited from it.
class StreamAdaptiveMenuAnchorTheme extends InheritedTheme {
  /// Creates a theme for the [StreamAdaptiveMenuAnchor]s below it.
  const StreamAdaptiveMenuAnchorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme for descendant menu anchors.
  final StreamAdaptiveMenuAnchorThemeData data;

  /// The theme for the menu anchors at [context]: the app-wide one from
  /// [StreamVideoTheme], with the nearest [StreamAdaptiveMenuAnchorTheme]
  /// merged on top.
  static StreamAdaptiveMenuAnchorThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamAdaptiveMenuAnchorTheme>();
    return StreamVideoTheme.of(
      context,
    ).adaptiveMenuAnchorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamAdaptiveMenuAnchorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamAdaptiveMenuAnchorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for [StreamAdaptiveMenuAnchor].
@themeGen
@immutable
class StreamAdaptiveMenuAnchorThemeData
    with _$StreamAdaptiveMenuAnchorThemeData {
  /// Creates theme data for [StreamAdaptiveMenuAnchor].
  const StreamAdaptiveMenuAnchorThemeData({this.style});

  /// The visual style of the menu's rows.
  final StreamAdaptiveMenuAnchorStyle? style;

  /// Linearly interpolates between two [StreamAdaptiveMenuAnchorThemeData]s.
  static StreamAdaptiveMenuAnchorThemeData? lerp(
    StreamAdaptiveMenuAnchorThemeData? a,
    StreamAdaptiveMenuAnchorThemeData? b,
    double t,
  ) => _$StreamAdaptiveMenuAnchorThemeData.lerp(a, b, t);
}

/// The visual style of a [StreamAdaptiveMenuAnchor]'s rows, in each of its
/// two presentations.
@themeGen
@immutable
class StreamAdaptiveMenuAnchorStyle with _$StreamAdaptiveMenuAnchorStyle {
  /// Creates a style for [StreamAdaptiveMenuAnchor].
  const StreamAdaptiveMenuAnchorStyle({
    this.sheetTileStyle,
    this.menuItemStyle,
  });

  /// The rows of the bottom sheet the menu opens on Android and iOS.
  ///
  /// Applies on top of the app's list tile theme, so a row keeps its colors
  /// and text styles. Its padding comes from here rather than from the app's
  /// list tile theme: defaults to `spacing.sm` across and `spacing.xxs` down,
  /// which makes a row 48 tall.
  final StreamListTileThemeData? sheetTileStyle;

  /// The rows of the anchored menu the menu opens on desktop and web.
  ///
  /// [StreamAdaptiveMenuAnchor.menuItemStyle] wins over this.
  final StreamContextMenuActionStyle? menuItemStyle;

  /// Linearly interpolates between two [StreamAdaptiveMenuAnchorStyle]s.
  static StreamAdaptiveMenuAnchorStyle? lerp(
    StreamAdaptiveMenuAnchorStyle? a,
    StreamAdaptiveMenuAnchorStyle? b,
    double t,
  ) => _$StreamAdaptiveMenuAnchorStyle.lerp(a, b, t);
}
