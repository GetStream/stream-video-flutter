import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The design system's palettes the app can take its brand color from.
enum AppAccentColor {
  blue,
  purple,
  violet,
  red,
  yellow,
  lime,
  green,
  cyan;

  /// The palette, ordered light to dark.
  StreamColorSwatch get palette => switch (this) {
    blue => StreamColors.blue,
    purple => StreamColors.purple,
    violet => StreamColors.violet,
    red => StreamColors.red,
    yellow => StreamColors.yellow,
    lime => StreamColors.lime,
    green => StreamColors.green,
    cyan => StreamColors.cyan,
  };

  /// The color a swatch for this palette shows: the accent it gives the
  /// theme of [brightness].
  Color swatchColor(Brightness brightness) => switch (brightness) {
    Brightness.light => palette.shade500,
    Brightness.dark => palette.shade400,
  };

  /// The brand color for a theme of [brightness], or null for blue, which is
  /// the design system's own brand color.
  ///
  /// A dark theme runs the palette in reverse, as the default brand does.
  StreamColorSwatch? brand(Brightness brightness) {
    if (this == blue) return null;
    final palette = this.palette;

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
