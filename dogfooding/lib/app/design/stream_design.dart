import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_accent_color.dart';
import 'app_design_spec.dart';

/// The SDK's own design system, in the Inter font.
class StreamDesign extends AppDesignSpec {
  const StreamDesign();

  @override
  Color defaultAccent(Brightness brightness) => switch (brightness) {
    Brightness.light => StreamColorScheme.light().accentPrimary,
    Brightness.dark => StreamColorScheme.dark().accentPrimary,
  };

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final brand = accent.brand(brightness);
    return StreamTheme(
      brightness: brightness,
      colorScheme: switch (brightness) {
        _ when brand == null => null,
        Brightness.light => StreamColorScheme.light(brand: brand),
        Brightness.dark => StreamColorScheme.dark(brand: brand),
      },
    );
  }

  @override
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) => designMaterialTheme(
    streamTheme,
    materialColorScheme: ColorScheme.fromSwatch().copyWith(
      primary: streamTheme.colorScheme.brand,
    ),
    textTheme: designGoogleFontsEnabled
        ? GoogleFonts.interTextTheme(
            ThemeData(brightness: brightness).textTheme,
          )
        : null,
  );
}
