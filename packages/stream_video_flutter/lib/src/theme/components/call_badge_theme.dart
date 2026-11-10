import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_badge_theme.g.theme.dart';

/// Applies a shared style to every call badge in a subtree:
/// [StreamCallDurationBadge], [StreamCallParticipantsBadge] and
/// [StreamCallLatencyBadge].
///
/// A field a badge's own theme or style sets wins over the one here.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallBadgeTheme(
///   data: StreamCallBadgeThemeData(
///     style: StreamCallBadgeStyle(backgroundColor: Colors.black54),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallBadgeThemeData], which describes the theme.
///  * [StreamCallBadgeStyle], the visual style it carries.
class StreamCallBadgeTheme extends InheritedTheme {
  /// Creates a shared badge theme.
  const StreamCallBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The shared badge theme data for descendant badges.
  final StreamCallBadgeThemeData data;

  /// Returns the [StreamCallBadgeThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamCallBadgeTheme] ancestor take
  /// precedence over the global values from [StreamVideoTheme.callBadgeTheme].
  static StreamCallBadgeThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallBadgeTheme>();
    return StreamVideoTheme.of(context).callBadgeTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallBadgeTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data shared by every call badge.
///
/// See also:
///
///  * [StreamCallBadgeStyle], the style embedded here.
///  * [StreamCallBadgeTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallBadgeThemeData with _$StreamCallBadgeThemeData {
  /// Creates shared badge theme data.
  const StreamCallBadgeThemeData({this.style});

  /// Visual styling shared by the badges.
  final StreamCallBadgeStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallBadgeThemeData? lerp(
    StreamCallBadgeThemeData? a,
    StreamCallBadgeThemeData? b,
    double t,
  ) => _$StreamCallBadgeThemeData.lerp(a, b, t);
}

/// Visual styling shared by every call badge.
///
/// Each field applies to every badge unless the badge's own style sets it —
/// [StreamCallDurationBadgeStyle], [StreamCallParticipantsBadgeStyle] or
/// [StreamCallLatencyBadgeStyle].
@themeGen
@immutable
class StreamCallBadgeStyle with _$StreamCallBadgeStyle {
  /// Creates a shared badge style with optional property overrides.
  const StreamCallBadgeStyle({
    this.padding,
    this.contentHeight,
    this.spacing,
    this.iconSize,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
  });

  /// The padding between a pill's edge and its content.
  ///
  /// Defaults to `spacing.xs` horizontally and `spacing.xxs + spacing.xxxs`
  /// vertically, which puts a 20 tall row in a 32 tall pill.
  final EdgeInsetsGeometry? padding;

  /// The height a badge's content is held to. Defaults to 20.
  final double? contentHeight;

  /// The gap between a badge's icon and its text.
  ///
  /// Defaults to `spacing.xxs` on desktop and web and `spacing.xs` on mobile;
  /// the latency badge's dot keeps `spacing.xs` everywhere.
  final double? spacing;

  /// The size of a badge's icons.
  ///
  /// Defaults to 16 on desktop and web and 20 on mobile. The latency badge's
  /// dot is sized by [StreamCallLatencyBadgeStyle.dotSize] instead.
  final double? iconSize;

  /// A pill's fill. Defaults to `colorScheme.backgroundSurface`.
  final Color? backgroundColor;

  /// A pill's corners. Defaults to `radius.xxxl` on every corner.
  final BorderRadiusGeometry? borderRadius;

  /// Merged onto each badge's text style.
  ///
  /// The badges default to `textTheme.captionEmphasis` on desktop and web and
  /// `textTheme.bodyEmphasis` on mobile, at `height: 1` and with tabular
  /// figures; a colour set here replaces each badge's own text colour.
  final TextStyle? textStyle;

  /// Linearly interpolate between two styles.
  static StreamCallBadgeStyle? lerp(
    StreamCallBadgeStyle? a,
    StreamCallBadgeStyle? b,
    double t,
  ) => _$StreamCallBadgeStyle.lerp(a, b, t);
}
