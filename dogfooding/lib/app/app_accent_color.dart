import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'app_design.dart';

/// The design system's palettes the app can take its brand color from.
enum AppAccentColor {
  /// No palette of its own: each design keeps its own default color.
  designDefault,
  blue,
  purple,
  violet,
  red,
  yellow,
  lime,
  green,
  cyan;

  /// The palette, ordered light to dark, or null for [designDefault].
  StreamColorSwatch? get palette => switch (this) {
    designDefault => null,
    blue => StreamColors.blue,
    purple => StreamColors.purple,
    violet => StreamColors.violet,
    red => StreamColors.red,
    yellow => StreamColors.yellow,
    lime => StreamColors.lime,
    green => StreamColors.green,
    cyan => StreamColors.cyan,
  };

  /// The color a swatch for this palette shows: the accent it gives a theme of
  /// [brightness] in [design].
  Color swatchColor(Brightness brightness, AppDesign design) =>
      switch (palette) {
        null => design.defaultAccent(brightness),
        final palette => switch (brightness) {
          Brightness.light => palette.shade500,
          Brightness.dark => palette.shade400,
        },
      };

  /// The brand color for a theme of [brightness], or null for
  /// [designDefault], which leaves it to the design system.
  ///
  /// A dark theme runs the palette in reverse, as the default brand does.
  StreamColorSwatch? brand(Brightness brightness) {
    final palette = this.palette;
    if (palette == null) return null;

    return switch (brightness) {
      Brightness.light => palette,
      Brightness.dark => StreamColorSwatch(palette.shade300.toARGB32(), {
        50: palette.shade900,
        100: palette.shade800,
        150: palette.shade700,
        200: palette.shade600,
        300: palette.shade500,
        400: palette.shade400,
        500: palette.shade300,
        600: palette.shade200,
        700: palette.shade150,
        800: palette.shade100,
        900: palette.shade50,
      }),
    };
  }
}
