import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_duration_badge_theme.g.theme.dart';

/// Applies a badge theme to descendant [StreamCallDurationBadge] widgets.
///
/// Wrap a subtree with [StreamCallDurationBadgeTheme] to override how the call's
/// elapsed time is drawn.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallDurationBadgeTheme(
///   data: StreamCallDurationBadgeThemeData(
///     style: StreamCallDurationBadgeStyle(recordingColor: Colors.orange),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallDurationBadgeThemeData], which describes the theme.
///  * [StreamCallDurationBadgeStyle], the visual style it carries.
class StreamCallDurationBadgeTheme extends InheritedTheme {
  /// Creates a badge theme.
  const StreamCallDurationBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The badge theme data for descendant widgets.
  final StreamCallDurationBadgeThemeData data;

  /// Returns the [StreamCallDurationBadgeThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamCallDurationBadgeTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.callDurationBadgeTheme]. This allows partial overrides:
  /// setting only [StreamCallDurationBadgeStyle.backgroundColor] leaves the remaining
  /// properties coming from the global theme.
  static StreamCallDurationBadgeThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallDurationBadgeTheme>();
    return StreamVideoTheme.of(
      context,
    ).callDurationBadgeTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallDurationBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallDurationBadgeTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamCallDurationBadge] widgets.
///
/// See also:
///
///  * [StreamCallDurationBadgeStyle], the style embedded here.
///  * [StreamCallDurationBadgeTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallDurationBadgeThemeData with _$StreamCallDurationBadgeThemeData {
  /// Creates badge theme data.
  const StreamCallDurationBadgeThemeData({this.style});

  /// Visual styling for the badge.
  final StreamCallDurationBadgeStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamCallDurationBadgeThemeData? lerp(
    StreamCallDurationBadgeThemeData? a,
    StreamCallDurationBadgeThemeData? b,
    double t,
  ) => _$StreamCallDurationBadgeThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamCallDurationBadge].
@themeGen
@immutable
class StreamCallDurationBadgeStyle with _$StreamCallDurationBadgeStyle {
  /// Creates a badge style with optional property overrides.
  const StreamCallDurationBadgeStyle({
    this.padding,
    this.contentHeight,
    this.spacing,
    this.indicatorSpacing,
    this.indicatorSize,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
    this.elapsedTextColor,
    this.encryptedColor,
    this.recordingColor,
    this.screenShareColor,
  });

  /// The padding between the pill's edge and its content.
  ///
  /// Defaults to `spacing.xs` horizontally and `spacing.xxs + spacing.xxxs`
  /// vertically — 8 and 6, which puts a 20 tall row in a 32 tall pill.
  final EdgeInsetsGeometry? padding;

  /// The height the content is held to, whatever it is showing.
  ///
  /// Defaults to [indicatorSize]. The timestamp's own box is shorter than an
  /// icon, so without this a badge showing the time alone would be shorter than
  /// one carrying indicators.
  final double? contentHeight;

  /// The gap between the indicators and the timestamp. Defaults to
  /// `spacing.xs`.
  ///
  /// Charged only when there is an indicator to separate.
  final double? spacing;

  /// The gap between two indicators. Defaults to `spacing.xxxs`.
  final double? indicatorSpacing;

  /// The size of an indicator icon. Defaults to 20, the design system's medium
  /// icon.
  final double? indicatorSize;

  /// The pill's fill. Defaults to `colorScheme.backgroundSurface`.
  final Color? backgroundColor;

  /// The pill's corners. Defaults to `radius.xxxl` on every corner.
  final BorderRadiusGeometry? borderRadius;

  /// The timestamp's style, and the colour the time not yet elapsed takes.
  ///
  /// Defaults to `textTheme.bodyEmphasis` in `colorScheme.textTertiary`, at
  /// `height: 1` and with tabular figures — so the digits centre against the
  /// indicators and the pill holds still as the seconds tick.
  final TextStyle? textStyle;

  /// The colour of the time that has elapsed — everything from the unit the
  /// clock has reached on, the colon between units included.
  ///
  /// Defaults to `colorScheme.textPrimary`.
  final Color? elapsedTextColor;

  /// The colour of the end-to-end encryption indicator. Defaults to
  /// `colorScheme.accentSuccess`.
  final Color? encryptedColor;

  /// The colour of the recording indicator. Defaults to
  /// `colorScheme.accentError`.
  final Color? recordingColor;

  /// The colour of the screen share indicator. Defaults to
  /// `colorScheme.accentPrimary`.
  final Color? screenShareColor;

  /// Linearly interpolate between two styles.
  static StreamCallDurationBadgeStyle? lerp(
    StreamCallDurationBadgeStyle? a,
    StreamCallDurationBadgeStyle? b,
    double t,
  ) => _$StreamCallDurationBadgeStyle.lerp(a, b, t);
}
