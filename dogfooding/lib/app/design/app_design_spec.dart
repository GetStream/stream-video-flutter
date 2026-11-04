import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_core_flutter/core.dart' as core show StreamTextTheme;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_accent_color.dart';

/// What a design supplies to restyle the app: the [StreamTheme] the SDK's
/// components read, the Material theme around it, the component builders that
/// swap the core components for the design library's own, and any scope the
/// library's widgets need above them.
abstract class AppDesignSpec {
  const AppDesignSpec();

  /// The accent color the design uses when no accent color is picked.
  Color defaultAccent(Brightness brightness);

  /// The accent color for [accent] in a theme of [brightness]: the picked
  /// palette's, or the design's own for [AppAccentColor.designDefault].
  Color accentColor(Brightness brightness, AppAccentColor accent) =>
      accent.paletteColor(brightness) ?? defaultAccent(brightness);

  /// The theme the SDK's components read.
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent);

  /// The Material theme the app is built on, before the Stream themes are
  /// added to it.
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) => designMaterialTheme(streamTheme);

  /// The component builders, with [extensions] for the app's own chat and
  /// video components.
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(extensions: extensions);

  /// Wraps [child], below the [MaterialApp], in any scope the design's widgets
  /// read.
  Widget wrap(BuildContext context, AppAccentColor accent, Widget child) =>
      child;
}

/// A [StreamColorScheme] for a design: its own neutrals, with the picked
/// accent's palette as the brand, or [defaultAccent] for
/// [AppAccentColor.designDefault].
StreamColorScheme designColorScheme({
  required Brightness brightness,
  required AppAccentColor accent,
  required Color defaultAccent,
  double? defaultAccentChroma,
  Color? textOnDefaultAccent,
  Color? accentSuccess,
  Color? accentWarning,
  Color? accentError,
  Color? textPrimary,
  Color? textSecondary,
  Color? backgroundApp,
  Color? backgroundElevation1,
  Color? backgroundSurfaceCard,
  Color? backgroundSurfaceSubtle,
  Color? borderDefault,
  Color? borderSubtle,
}) {
  final picked = accent.brand(brightness);
  final brand =
      picked ??
      StreamColorSwatch.fromColor(
        defaultAccent,
        brightness: brightness,
        chroma: defaultAccentChroma,
      );
  // A picked palette derives the accent from the brand, as the Stream design
  // does.
  final accentPrimary = picked == null ? defaultAccent : null;
  final textOnAccent = picked == null ? textOnDefaultAccent : null;

  return switch (brightness) {
    Brightness.light => StreamColorScheme.light(
      brand: brand,
      accentPrimary: accentPrimary,
      accentSuccess: accentSuccess,
      accentWarning: accentWarning,
      accentError: accentError,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textOnAccent: textOnAccent,
      backgroundApp: backgroundApp,
      backgroundElevation0: backgroundApp,
      backgroundElevation1: backgroundElevation1,
      backgroundSurfaceCard: backgroundSurfaceCard,
      backgroundSurfaceSubtle: backgroundSurfaceSubtle,
      borderDefault: borderDefault,
      borderSubtle: borderSubtle,
    ),
    Brightness.dark => StreamColorScheme.dark(
      brand: brand,
      accentPrimary: accentPrimary,
      accentSuccess: accentSuccess,
      accentWarning: accentWarning,
      accentError: accentError,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textOnAccent: textOnAccent,
      backgroundApp: backgroundApp,
      backgroundElevation0: backgroundApp,
      backgroundElevation1: backgroundElevation1,
      backgroundSurfaceCard: backgroundSurfaceCard,
      backgroundSurfaceSubtle: backgroundSurfaceSubtle,
      borderDefault: borderDefault,
      borderSubtle: borderSubtle,
    ),
  };
}

/// A Material theme in the colors of [streamTheme], for the Material widgets
/// the app still uses, with [textTheme] or [fontFamily] for its text.
///
/// The Material color scheme is seeded from the accent unless
/// [materialColorScheme] is given.
ThemeData designMaterialTheme(
  StreamTheme streamTheme, {
  ColorScheme? materialColorScheme,
  TextTheme? textTheme,
  String? fontFamily,
  List<String>? fontFamilyFallback,
}) {
  final colorScheme = streamTheme.colorScheme;
  final base = ThemeData(
    brightness: colorScheme.brightness,
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
  );
  final baseTextTheme = textTheme ?? base.textTheme;

  return base.copyWith(
    scaffoldBackgroundColor: colorScheme.backgroundApp,
    colorScheme:
        materialColorScheme ??
        ColorScheme.fromSeed(
          seedColor: colorScheme.accentPrimary,
          brightness: colorScheme.brightness,
          primary: colorScheme.accentPrimary,
          onPrimary: colorScheme.textOnAccent,
          error: colorScheme.accentError,
          surface: colorScheme.backgroundApp,
        ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: colorScheme.textPrimary),
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: colorScheme.backgroundElevation0,
      dragHandleColor: colorScheme.textPrimary,
    ),
    textTheme: baseTextTheme.copyWith(
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: colorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: colorScheme.textPrimary,
      ),
    ),
  );
}

/// Whether the designs take their fonts from Google Fonts, which they fetch
/// at runtime. Tests turn it off, as they have no network to fetch them from.
bool designGoogleFontsEnabled = true;

/// The SDK's text styles in [color], in [fontFamily] when given.
core.StreamTextTheme designTextTheme(
  Color color, {
  String? fontFamily,
  List<String>? fontFamilyFallback,
}) => core.StreamTextTheme().apply(
  color: color,
  fontFamily: fontFamily,
  fontFamilyFallback: fontFamilyFallback,
);

/// Lays [child] out in a box at least [kMinInteractiveDimension] square, with
/// [child] centered, as the SDK's own buttons are on every platform.
///
/// The extra room is the tap target around the painted button, and taps on it
/// reach the button. It is also what spaces a row of buttons apart, such as the
/// call controls, and what centers a small button against a taller field, such
/// as the composer's. The constraints from the parent reach [child] unchanged,
/// so a button its parent stretches still stretches.
Widget padToTapTarget(BuildContext context, Widget child) =>
    _TapTargetPadding(child: child);

class _TapTargetPadding extends SingleChildRenderObjectWidget {
  const _TapTargetPadding({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTapTargetPadding();
}

class _RenderTapTargetPadding extends RenderShiftedBox {
  _RenderTapTargetPadding() : super(null);

  static const _minSize = Size.square(kMinInteractiveDimension);

  @override
  double computeMinIntrinsicWidth(double height) => math.max(
    child?.getMinIntrinsicWidth(height) ?? 0,
    _minSize.width,
  );

  @override
  double computeMaxIntrinsicWidth(double height) => math.max(
    child?.getMaxIntrinsicWidth(height) ?? 0,
    _minSize.width,
  );

  @override
  double computeMinIntrinsicHeight(double width) => math.max(
    child?.getMinIntrinsicHeight(width) ?? 0,
    _minSize.height,
  );

  @override
  double computeMaxIntrinsicHeight(double width) => math.max(
    child?.getMaxIntrinsicHeight(width) ?? 0,
    _minSize.height,
  );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childSize = child?.getDryLayout(constraints) ?? Size.zero;
    return constraints.constrain(
      Size(
        math.max(childSize.width, _minSize.width),
        math.max(childSize.height, _minSize.height),
      ),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(_minSize);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(
        math.max(child.size.width, _minSize.width),
        math.max(child.size.height, _minSize.height),
      ),
    );
    (child.parentData! as BoxParentData).offset = Alignment.center.alongOffset(
      size - child.size as Offset,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) return true;
    // A tap in the padding goes to the button, at its center.
    final child = this.child;
    if (child == null || !size.contains(position)) return false;
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => child.hitTest(result, position: center),
    );
  }
}

/// The height a split button paints, which is a medium button's.
final double designSplitButtonHeight = StreamButtonSize.medium.value;

/// Lays a design's split button out as the SDK's own: [child] painted
/// [designSplitButtonHeight] high, in a tap target as tall as a padded
/// button's, with the same room at its sides.
///
/// [scale] fits a library's split button that has a fixed height of its own to
/// that height.
Widget designSplitFrame(Widget child, {bool scale = false}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 4),
  child: ConstrainedBox(
    constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
    child: Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox(
        height: designSplitButtonHeight,
        child: scale ? FittedBox(fit: BoxFit.fitHeight, child: child) : child,
      ),
    ),
  ),
);

/// The diameter of a loading spinner of [size].
double spinnerDimension(StreamLoadingSpinnerSize? size) =>
    (size ?? StreamLoadingSpinnerSize.md).value;

/// [field] with the label above it and the helper text below it, as the SDK's
/// own text input lays them out.
class DesignLabeledField extends StatelessWidget {
  const DesignLabeledField({
    required this.field,
    this.label,
    this.helper,
    this.helperState,
    super.key,
  });

  final Widget field;
  final String? label;
  final String? helper;
  final StreamHelperState? helperState;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final helper = this.helper;
    if (label == null && helper == null) return field;

    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.streamSpacing.xs,
      children: [
        if (label != null)
          Text(
            label,
            style: textTheme.captionEmphasis.copyWith(
              color: colorScheme.textPrimary,
            ),
          ),
        field,
        if (helper != null)
          Text(
            helper,
            style: textTheme.captionDefault.copyWith(
              color: switch (helperState) {
                StreamHelperState.error => colorScheme.accentError,
                StreamHelperState.success => colorScheme.accentSuccess,
                _ => colorScheme.textSecondary,
              },
            ),
          ),
      ],
    );
  }
}
