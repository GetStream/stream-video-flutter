import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'modal_window_theme.g.theme.dart';

/// Applies a [StreamModalWindowThemeData] to descendant [StreamModalWindow]s.
///
/// Values set here override the ones on [StreamVideoTheme.modalWindowTheme]
/// for this subtree, and any left null are inherited from it.
class StreamModalWindowTheme extends InheritedTheme {
  /// Creates a theme for the [StreamModalWindow]s below it.
  const StreamModalWindowTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme for descendant modal windows.
  final StreamModalWindowThemeData data;

  /// The theme for the modal windows at [context]: the app-wide one from
  /// [StreamVideoTheme], with the nearest [StreamModalWindowTheme] merged on
  /// top.
  static StreamModalWindowThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamModalWindowTheme>();
    return StreamVideoTheme.of(
      context,
    ).modalWindowTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamModalWindowTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamModalWindowTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for [StreamModalWindow].
@themeGen
@immutable
class StreamModalWindowThemeData with _$StreamModalWindowThemeData {
  /// Creates theme data for [StreamModalWindow].
  const StreamModalWindowThemeData({this.style});

  /// The visual style of the window.
  final StreamModalWindowStyle? style;

  /// Linearly interpolates between two [StreamModalWindowThemeData]s.
  static StreamModalWindowThemeData? lerp(
    StreamModalWindowThemeData? a,
    StreamModalWindowThemeData? b,
    double t,
  ) => _$StreamModalWindowThemeData.lerp(a, b, t);
}

/// The visual style of a [StreamModalWindow]: its surface, its sidebar of
/// tabs and the area the selected tab is drawn in.
@themeGen
@immutable
class StreamModalWindowStyle with _$StreamModalWindowStyle {
  /// Creates a style for [StreamModalWindow].
  const StreamModalWindowStyle({
    this.backgroundColor,
    this.sidebarWidth,
    this.sidebarBackgroundColor,
    this.sidebarBorderColor,
    this.navItemStyle,
    this.contentPadding,
  });

  /// The color of the window's surface.
  ///
  /// Defaults to `colorScheme.backgroundElevation1`.
  final Color? backgroundColor;

  /// The width of the sidebar while it shows the tabs' labels.
  ///
  /// Defaults to 200. A collapsed sidebar is as wide as its icons.
  final double? sidebarWidth;

  /// The color of the sidebar.
  ///
  /// Defaults to `colorScheme.backgroundElevation1`.
  final Color? sidebarBackgroundColor;

  /// The color of the line between the sidebar and the selected tab.
  ///
  /// Defaults to `colorScheme.borderSubtle`.
  final Color? sidebarBorderColor;

  /// The style of the sidebar's rows.
  ///
  /// Applies on top of the app's list tile theme, so a row keeps its colors
  /// and text styles. Its shape and padding come from here rather than from
  /// the app's list tile theme: defaults to `radius.md` corners and
  /// `spacing.sm` across and `spacing.xs` down, which makes a row 36 tall
  /// inside its 40.
  final StreamListTileThemeData? navItemStyle;

  /// The padding around the selected tab's content.
  ///
  /// Defaults to `spacing.xl` at the start and end and `spacing.xxl` at the
  /// bottom. The header above the content brings its own padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Linearly interpolates between two [StreamModalWindowStyle]s.
  static StreamModalWindowStyle? lerp(
    StreamModalWindowStyle? a,
    StreamModalWindowStyle? b,
    double t,
  ) => _$StreamModalWindowStyle.lerp(a, b, t);
}
