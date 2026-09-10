import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_button_badge_theme.g.theme.dart';

/// Applies a call button badge theme to descendant [StreamCallButtonBadge] widgets.
///
/// Wrap a subtree with [StreamCallButtonBadgeTheme] to override how the badge
/// on a call control reads.
///
/// {@tool snippet}
///
/// Make the badge read as an error rather than a warning:
///
/// ```dart
/// StreamCallButtonBadgeTheme(
///   data: StreamCallButtonBadgeThemeData(
///     style: StreamCallButtonBadgeStyle(
///       badgeStyle: StreamErrorBadgeStyle.error,
///       showBorder: true,
///     ),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallButtonBadgeThemeData], which describes the theme.
///  * [StreamCallButtonBadgeStyle], the visual style it carries.
class StreamCallButtonBadgeTheme extends InheritedTheme {
  /// Creates a call button badge theme.
  const StreamCallButtonBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The badge theme data for descendant widgets.
  final StreamCallButtonBadgeThemeData data;

  /// Returns the [StreamCallButtonBadgeThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamCallButtonBadgeTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.callButtonBadgeTheme]. This allows partial overrides:
  /// setting only [StreamCallButtonBadgeStyle.size] leaves the severity coming
  /// from the global theme.
  static StreamCallButtonBadgeThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallButtonBadgeTheme>();
    return StreamVideoTheme.of(context).callButtonBadgeTheme.merge(
      localTheme?.data,
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallButtonBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallButtonBadgeTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamCallButtonBadge] widgets.
///
/// Wraps a [StreamCallButtonBadgeStyle] so it can be served by
/// [StreamCallButtonBadgeTheme] and slotted into [StreamVideoTheme] alongside
/// the other component theme data classes.
///
/// See also:
///
///  * [StreamCallButtonBadgeStyle], the style embedded here.
///  * [StreamCallButtonBadgeTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallButtonBadgeThemeData with _$StreamCallButtonBadgeThemeData {
  /// Creates call button badge theme data.
  const StreamCallButtonBadgeThemeData({this.style});

  /// Visual styling for the badge.
  final StreamCallButtonBadgeStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallButtonBadgeThemeData? lerp(
    StreamCallButtonBadgeThemeData? a,
    StreamCallButtonBadgeThemeData? b,
    double t,
  ) => _$StreamCallButtonBadgeThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamCallButtonBadge].
///
/// The badge is a `StreamErrorBadge` pinned to the top-end corner of a call
/// control. Its colors come from the core design system's
/// `StreamErrorBadgeTheme` rather than being repeated here, so this style
/// selects *which* badge is drawn and where, and an app that wants different
/// badge colors themes `StreamErrorBadge` itself.
@themeGen
@immutable
class StreamCallButtonBadgeStyle with _$StreamCallButtonBadgeStyle {
  /// Creates a badge style with optional property overrides.
  const StreamCallButtonBadgeStyle({
    this.badgeStyle,
    this.size,
    this.showBorder,
    this.alignmentOffset,
  });

  /// The severity the badge conveys.
  ///
  /// Defaults to [StreamErrorBadgeStyle.warning], which the design system
  /// specifies for call controls: the shared error badge is red with a dark
  /// border, which disappears into a red control and loses its edge over
  /// video, while the warning badge separates from whatever sits underneath.
  final StreamErrorBadgeStyle? badgeStyle;

  /// The diameter of the badge.
  ///
  /// Defaults to [StreamErrorBadgeSize.sm].
  final StreamErrorBadgeSize? size;

  /// Whether a border is drawn around the badge.
  ///
  /// Defaults to false. The warning badge is legible against a call control
  /// and over video without one, and a border on a badge this small reads as
  /// a smudge rather than a separation.
  final bool? showBorder;

  /// How far the badge overhangs the button's top-end corner.
  ///
  /// Applied as a directional offset, so it flips with the text direction.
  /// Defaults to 4 logical pixels up and towards the end edge.
  final double? alignmentOffset;

  /// Linearly interpolate between two styles.
  static StreamCallButtonBadgeStyle? lerp(
    StreamCallButtonBadgeStyle? a,
    StreamCallButtonBadgeStyle? b,
    double t,
  ) => _$StreamCallButtonBadgeStyle.lerp(a, b, t);
}
