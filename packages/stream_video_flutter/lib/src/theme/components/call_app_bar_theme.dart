import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_app_bar_theme.g.theme.dart';

/// Applies an app bar theme to descendant [CallAppBar] widgets.
///
/// Wrap a subtree with [CallAppBarTheme] to override how the bar along the top
/// of a call is drawn.
///
/// {@tool snippet}
///
/// Float the bar over the call rather than docking it above one:
///
/// ```dart
/// CallAppBarTheme(
///   data: CallAppBarThemeData(
///     style: CallAppBarStyle(surfaceStyle: StreamSurfaceStyle.floating),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [CallAppBarThemeData], which describes the theme.
///  * [CallAppBarStyle], the visual style it carries.
///  * [CallControlBarTheme], the same thing for the bar along the bottom.
class CallAppBarTheme extends InheritedTheme {
  /// Creates an app bar theme.
  const CallAppBarTheme({super.key, required this.data, required super.child});

  /// The app bar theme data for descendant widgets.
  final CallAppBarThemeData data;

  /// Returns the [CallAppBarThemeData] merged from local and global themes.
  ///
  /// Local values from the nearest [CallAppBarTheme] ancestor take precedence
  /// over the global values from [StreamVideoTheme.callAppBarTheme]. This
  /// allows partial overrides: setting only [CallAppBarStyle.backgroundColor]
  /// leaves the remaining properties coming from the global theme.
  static CallAppBarThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<CallAppBarTheme>();
    return StreamVideoTheme.of(context).callAppBarTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CallAppBarTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(CallAppBarTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [CallAppBar] widgets.
///
/// See also:
///
///  * [CallAppBarStyle], the style embedded here.
///  * [CallAppBarTheme], for overriding it in a subtree.
@themeGen
@immutable
class CallAppBarThemeData with _$CallAppBarThemeData {
  /// Creates app bar theme data.
  const CallAppBarThemeData({this.style});

  /// Visual styling for the app bar.
  final CallAppBarStyle? style;

  /// Linearly interpolate between two theme data objects.
  static CallAppBarThemeData? lerp(
    CallAppBarThemeData? a,
    CallAppBarThemeData? b,
    double t,
  ) => _$CallAppBarThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [CallAppBar].
///
/// The mirror of [CallControlBarStyle], and deliberately as small: the bar
/// draws no controls of its own, so a control's appearance belongs to
/// `StreamButtonTheme` and the tone it is given. What is left is the bar's own
/// geometry and surface, plus the style of the title it falls back to.
@themeGen
@immutable
class CallAppBarStyle with _$CallAppBarStyle {
  /// Creates an app bar style with optional property overrides.
  const CallAppBarStyle({
    this.height,
    this.padding,
    this.slotSpacing,
    this.controlSpacing,
    this.surfaceStyle,
    this.backgroundColor,
    this.floatingBackgroundColor,
    this.titleTextStyle,
  });

  /// The bar's height, below the top safe-area inset. Defaults to
  /// `kStreamToolbarHeight` (72), as [CallControlBarStyle.height] does.
  ///
  /// The slots are centred in it rather than padded to it, so this has to clear
  /// the tallest control the bar is given — 48 for the icon buttons the design
  /// system draws, which is the button's tap target rather than its visible 40.
  final double? height;

  /// The padding around all three slots.
  ///
  /// Defaults to `EdgeInsets.all(spacing.sm)` — 12, which puts the visible edge
  /// of a control on the design's 16 once its tap target's own 4 is added. The
  /// same inset the control bar along the bottom uses, so the two ends of a
  /// call line up.
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
  /// two buttons comes from. Raising this adds to that gap rather than creating
  /// it.
  final double? controlSpacing;

  /// Whether the bar is docked above the call or floating over it.
  ///
  /// Defaults to the ambient `StreamSurfaceStyle`. A docked bar is opaque and a
  /// floating one fades into the call below it.
  final StreamSurfaceStyle? surfaceStyle;

  /// The bar's background while docked. Defaults to
  /// `colorScheme.backgroundApp`, which is what the call surface and
  /// [CallControlBar] are painted with, so the two ends of a call screen match.
  final Color? backgroundColor;

  /// The colour the bar fades from while floating.
  ///
  /// Defaults to `colorScheme.backgroundApp`, as [backgroundColor] does — a bar
  /// floating over a call fades into the call's own ground. Separate from
  /// [backgroundColor] so an app can tint the fade without repainting the
  /// docked fill.
  final Color? floatingBackgroundColor;

  /// The style of the title the bar falls back to when it is given none.
  ///
  /// Defaults to `textTheme.headingSm` in `colorScheme.textPrimary`. A title
  /// passed to [CallAppBar.title] is drawn in this too, and can override it
  /// with a style of its own.
  final TextStyle? titleTextStyle;

  /// Linearly interpolate between two styles.
  static CallAppBarStyle? lerp(
    CallAppBarStyle? a,
    CallAppBarStyle? b,
    double t,
  ) => _$CallAppBarStyle.lerp(a, b, t);
}
