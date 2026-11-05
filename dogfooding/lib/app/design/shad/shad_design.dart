import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shad/shad.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'shad_button.dart';
import 'shad_icons.dart';
import 'shad_split_button.dart';
import 'shad_text_input.dart';

/// shadcn/ui, through the `shad` package: the monochrome zinc palette, hairline
/// borders, the Geist font and 6px corners.
class ShadDesign extends AppDesignSpec {
  const ShadDesign();

  @override
  List<String> get packages => const ['shad', 'google_fonts'];

  static ShadColorScheme _zinc(Brightness brightness) => switch (brightness) {
    Brightness.light => const ShadZincColorScheme.light(),
    Brightness.dark => const ShadZincColorScheme.dark(),
  };

  @override
  Color defaultAccent(Brightness brightness) => _zinc(brightness).primary;

  /// The shad color scheme, with the picked accent as its primary color.
  ShadColorScheme colorScheme(Brightness brightness, AppAccentColor accent) {
    final zinc = _zinc(brightness);
    final picked = accent.paletteColor(brightness);
    if (picked == null) return zinc;

    final onPicked =
        ThemeData.estimateBrightnessForColor(picked) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return zinc.copyWith(
      primary: picked,
      primaryForeground: onPicked,
      ring: picked,
    );
  }

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final shad = _zinc(brightness);
    final colorScheme = designColorScheme(
      brightness: brightness,
      accent: accent,
      defaultAccent: shad.primary,
      // Zinc is a neutral, so its scale stays grey.
      defaultAccentChroma: 0,
      textOnDefaultAccent: shad.primaryForeground,
      accentError: shad.destructive,
      textPrimary: shad.foreground,
      textSecondary: shad.mutedForeground,
      backgroundApp: shad.background,
      backgroundElevation1: shad.card,
      backgroundSurfaceCard: shad.card,
      backgroundSurfaceSubtle: shad.muted,
      borderDefault: shad.border,
      borderSubtle: shad.border,
    );

    return StreamTheme(
      brightness: brightness,
      icons: shadStreamIcons,
      colorScheme: colorScheme,
      textTheme: designTextTheme(
        colorScheme.textPrimary,
        fontFamily: designGoogleFontsEnabled
            ? GoogleFonts.geist().fontFamily
            : null,
      ),
      radius: const StreamRadius(
        xxs: Radius.circular(4),
        xs: Radius.circular(6),
        md: Radius.circular(6),
        lg: Radius.circular(8),
        xl: Radius.circular(10),
        xxl: Radius.circular(12),
        xxxl: Radius.circular(12),
        xxxxl: Radius.circular(12),
      ),
    );
  }

  @override
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) => designMaterialTheme(
    streamTheme,
    textTheme: designGoogleFontsEnabled
        ? GoogleFonts.geistTextTheme(
            ThemeData(brightness: brightness).textTheme,
          )
        : null,
  );

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => ShadStreamButton(props: props),
    splitButton: (context, props) => ShadStreamSplitButton(props: props),
    checkbox: (context, props) => Semantics(
      checked: props.value,
      label: props.semanticLabel,
      child: ShadCheckbox(
        value: props.value,
        enabled: props.onChanged != null,
        onChanged: props.onChanged,
      ),
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: ShadSwitch(
        value: props.value,
        enabled: props.onChanged != null,
        onChanged: props.onChanged,
      ),
    ),
    textInput: (context, props) => ShadStreamTextInput(props: props),
    progressBar: (context, props) => ShadProgress(
      value: props.value,
      color: props.fillColor,
      backgroundColor: props.trackColor,
      minHeight: props.minHeight,
    ),
    loadingSpinner: (context, props) => ShadSpinner(
      size: spinnerDimension(props.size),
      color: props.color,
      trackColor: props.trackColor,
    ),
    extensions: extensions,
  );

  @override
  Widget wrap(BuildContext context, AppAccentColor accent, Widget child) {
    final brightness = Theme.of(context).brightness;
    return ShadTheme(
      data: ShadThemeData(
        brightness: brightness,
        colorScheme: colorScheme(brightness, accent),
        textTheme: designGoogleFontsEnabled
            ? ShadTextTheme.fromGoogleFont(GoogleFonts.geist)
            : null,
      ),
      child: child,
    );
  }
}
