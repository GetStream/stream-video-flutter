import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_button_badge_theme.g.theme.dart';

/// Applies a call button badge theme to descendant [StreamCallButtonBadge]
/// widgets.
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
/// The badge is a [StreamErrorBadge] pinned to the top-end corner of a call
/// control. This style selects which badge is drawn and where; its colors come
/// from [StreamErrorBadgeTheme] rather than being repeated here, so an app that
/// wants different badge colors themes [StreamErrorBadge] itself.
///
/// Size is the exception: [StreamCallButtonBadge] always passes it, so it comes
/// from here and [StreamErrorBadgeThemeData.size] never reaches this badge.
/// [StreamErrorBadgeThemeData.border] applies only when [showBorder] is set
/// here.
@themeGen
@immutable
class StreamCallButtonBadgeStyle with _$StreamCallButtonBadgeStyle {
  /// Creates a badge style with optional property overrides.
  const StreamCallButtonBadgeStyle({
    this.badgeStyle,
    this.size,
    this.showBorder,
    this.overhang,
  });

  /// The severity the badge conveys.
  ///
  /// If null, [StreamCallButtonBadge] uses [StreamErrorBadgeStyle.warning],
  /// which the design system specifies for call controls.
  final StreamErrorBadgeStyle? badgeStyle;

  /// The diameter of the badge.
  ///
  /// If null, [StreamCallButtonBadge] uses [StreamErrorBadgeSize.sm].
  final StreamErrorBadgeSize? size;

  /// Whether a border is drawn around the badge.
  ///
  /// If null, no border is drawn. Note that [StreamErrorBadge] draws one by
  /// default, so this is a departure from the core badge.
  final bool? showBorder;

  /// How far the badge overhangs the button's top-end corner, in logical
  /// pixels.
  ///
  /// Applied upwards and towards the end edge, so the horizontal half follows
  /// the text direction. If null, 4.
  final double? overhang;

  /// Linearly interpolate between two styles.
  static StreamCallButtonBadgeStyle? lerp(
    StreamCallButtonBadgeStyle? a,
    StreamCallButtonBadgeStyle? b,
    double t,
  ) => _$StreamCallButtonBadgeStyle.lerp(a, b, t);
}
