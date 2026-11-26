import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_participants_badge_theme.g.theme.dart';

/// Applies a badge theme to descendant [StreamCallParticipantsBadge] widgets.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallParticipantsBadgeTheme(
///   data: StreamCallParticipantsBadgeThemeData(
///     style: StreamCallParticipantsBadgeStyle(iconColor: Colors.orange),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallParticipantsBadgeThemeData], which describes the theme.
///  * [StreamCallParticipantsBadgeStyle], the visual style it carries.
class StreamCallParticipantsBadgeTheme extends InheritedTheme {
  /// Creates a badge theme.
  const StreamCallParticipantsBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The badge theme data for descendant widgets.
  final StreamCallParticipantsBadgeThemeData data;

  /// Returns the [StreamCallParticipantsBadgeThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamCallParticipantsBadgeTheme] ancestor
  /// take precedence over the global values from
  /// [StreamVideoTheme.callParticipantsBadgeTheme].
  static StreamCallParticipantsBadgeThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallParticipantsBadgeTheme>();
    return StreamVideoTheme.of(
      context,
    ).callParticipantsBadgeTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallParticipantsBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallParticipantsBadgeTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamCallParticipantsBadge] widgets.
///
/// See also:
///
///  * [StreamCallParticipantsBadgeStyle], the style embedded here.
///  * [StreamCallParticipantsBadgeTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallParticipantsBadgeThemeData
    with _$StreamCallParticipantsBadgeThemeData {
  /// Creates badge theme data.
  const StreamCallParticipantsBadgeThemeData({this.style});

  /// Visual styling for the badge.
  final StreamCallParticipantsBadgeStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallParticipantsBadgeThemeData? lerp(
    StreamCallParticipantsBadgeThemeData? a,
    StreamCallParticipantsBadgeThemeData? b,
    double t,
  ) => _$StreamCallParticipantsBadgeThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamCallParticipantsBadge].
///
/// When null, [padding], [contentHeight], [spacing], [iconSize],
/// [backgroundColor], [borderRadius] and [textStyle] fall back to the shared
/// [StreamCallBadgeStyle] on [StreamCallBadgeTheme], so one theme can restyle
/// every call badge.
///
/// Defaults that differ between desktop and web on one side and mobile on the
/// other are noted per field.
@themeGen
@immutable
class StreamCallParticipantsBadgeStyle with _$StreamCallParticipantsBadgeStyle {
  /// Creates a badge style with optional property overrides.
  const StreamCallParticipantsBadgeStyle({
    this.padding,
    this.contentHeight,
    this.spacing,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
  });

  /// The padding between the pill's edge and its content.
  ///
  /// Defaults to `spacing.xs` horizontally and `spacing.xxs + spacing.xxxs`
  /// vertically, which puts a 20 tall row in a 32 tall pill.
  final EdgeInsetsGeometry? padding;

  /// The height the content is held to. Defaults to 20.
  final double? contentHeight;

  /// The gap between the icon and the count.
  ///
  /// Defaults to `spacing.xxs` on desktop and web and `spacing.xs` on mobile.
  final double? spacing;

  /// The size of the icon.
  ///
  /// Defaults to 16 on desktop and web and 20 on mobile.
  final double? iconSize;

  /// The colour of the icon. Defaults to `colorScheme.textPrimary`.
  final Color? iconColor;

  /// The pill's fill. Defaults to `colorScheme.backgroundSurface`.
  final Color? backgroundColor;

  /// The pill's corners. Defaults to `radius.xxxl` on every corner.
  final BorderRadiusGeometry? borderRadius;

  /// The count's style.
  ///
  /// Defaults to `textTheme.captionEmphasis` on desktop and web and
  /// `textTheme.bodyEmphasis` on mobile, in `colorScheme.textPrimary`, at
  /// `height: 1` and with tabular figures.
  final TextStyle? textStyle;

  /// Linearly interpolate between two styles.
  static StreamCallParticipantsBadgeStyle? lerp(
    StreamCallParticipantsBadgeStyle? a,
    StreamCallParticipantsBadgeStyle? b,
    double t,
  ) => _$StreamCallParticipantsBadgeStyle.lerp(a, b, t);
}
