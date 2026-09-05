import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_control_bar_theme.g.theme.dart';

/// Applies a control bar theme to descendant [CallControlBar] widgets.
///
/// Wrap a subtree with [CallControlBarTheme] to override how the bar along the
/// bottom of a call is drawn.
///
/// {@tool snippet}
///
/// Float the bar over the call rather than docking it under one:
///
/// ```dart
/// CallControlBarTheme(
///   data: CallControlBarThemeData(
///     style: CallControlBarStyle(surfaceStyle: StreamSurfaceStyle.floating),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [CallControlBarThemeData], which describes the theme.
///  * [CallControlBarStyle], the visual style it carries.
class CallControlBarTheme extends InheritedTheme {
  /// Creates a control bar theme.
  const CallControlBarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The control bar theme data for descendant widgets.
  final CallControlBarThemeData data;

  /// Returns the [CallControlBarThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [CallControlBarTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.callControlBarTheme]. This allows partial overrides:
  /// setting only [CallControlBarStyle.backgroundColor] leaves the remaining
  /// properties coming from the global theme.
  static CallControlBarThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<CallControlBarTheme>();
    return StreamVideoTheme.of(
      context,
    ).callControlBarTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CallControlBarTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(CallControlBarTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [CallControlBar] widgets.
///
/// See also:
///
///  * [CallControlBarStyle], the style embedded here.
///  * [CallControlBarTheme], for overriding it in a subtree.
@themeGen
@immutable
class CallControlBarThemeData with _$CallControlBarThemeData {
  /// Creates control bar theme data.
  const CallControlBarThemeData({this.style});

  /// Visual styling for the control bar.
  final CallControlBarStyle? style;

  /// Linearly interpolate between two theme data objects.
  static CallControlBarThemeData? lerp(
    CallControlBarThemeData? a,
    CallControlBarThemeData? b,
    double t,
  ) => _$CallControlBarThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [CallControlBar].
///
/// Deliberately small. The bar draws no buttons of its own, so a control's
/// appearance belongs to `StreamButtonTheme` and the tone it is given; what is
/// left is the bar's own geometry and surface.
///
/// None of it varies by screen size: only *which* controls are drawn does. A
/// bar that changed height or padding across a breakpoint jumped as a desktop
/// window was dragged over it, for no gain.
@themeGen
@immutable
class CallControlBarStyle with _$CallControlBarStyle {
  /// Creates a control bar style with optional property overrides.
  const CallControlBarStyle({
    this.height,
    this.padding,
    this.slotSpacing,
    this.controlSpacing,
    this.surfaceStyle,
    this.backgroundColor,
    this.floatingBackgroundColor,
  });

  /// The bar's height, at every screen size. Defaults to
  /// `kStreamToolbarHeight` (72).
  ///
  /// The slots are centred in it rather than padded to it, so this has to
  /// clear the tallest control the bar is given — 48 for the icon buttons the
  /// design system draws, which is the button's tap target rather than its
  /// visible 40.
  final double? height;

  /// The padding along the bar's start and end edges, at every screen size.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: spacing.sm)` — 12, which
  /// puts the visible edge of a control on the design's 16 once its tap
  /// target's own 4 is added.
  ///
  /// Vertical padding narrows the band the slots are centred in rather than
  /// moving them, since the bar is [height] tall either way.
  final EdgeInsetsGeometry? padding;

  /// The minimum gap kept between the centre slot and either side slot.
  ///
  /// Defaults to `spacing.md`. The centre is centred in the bar's full width,
  /// so this is reserved on both sides of it whichever side is populated.
  final double? slotSpacing;

  /// The gap between two controls within the same slot. Defaults to
  /// `spacing.none`.
  ///
  /// Zero because the design system's icon buttons already carry a 48 tap
  /// target around a 40 visual, which is where the 8 the design shows between
  /// two buttons comes from. Raising this adds to that gap rather than
  /// creating it.
  final double? controlSpacing;

  /// Whether the bar is docked under the call or floating over it.
  ///
  /// Defaults to the ambient `StreamSurfaceStyle`. A docked bar is opaque and
  /// separated from the content by a hairline; a floating one fades into it.
  final StreamSurfaceStyle? surfaceStyle;

  /// The bar's background while docked. Defaults to
  /// `colorScheme.backgroundApp`, which is what the call surface and
  /// `CallAppBar` are painted with, so the two ends of a call screen match.
  final Color? backgroundColor;

  /// The colour the bar fades from while floating.
  ///
  /// Defaults to `colorScheme.backgroundApp`, as [backgroundColor] does — a
  /// bar floating over a call fades into the call's own ground. Separate from
  /// [backgroundColor] so an app can tint the fade without repainting the
  /// docked fill.
  final Color? floatingBackgroundColor;

  /// Linearly interpolate between two styles.
  static CallControlBarStyle? lerp(
    CallControlBarStyle? a,
    CallControlBarStyle? b,
    double t,
  ) => _$CallControlBarStyle.lerp(a, b, t);
}
