import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import '../material_text_input.dart';
import 'm3e_button.dart';
import 'm3e_icons.dart';
import 'm3e_split_button.dart';

/// Material 3 Expressive: a tonal palette seeded from the accent, large
/// rounded shapes, the Roboto Flex font and Material's rounded icons, with
/// the m3e component packages' shape-morphing buttons and wavy progress.
class M3EDesign extends AppDesignSpec {
  const M3EDesign();

  @override
  List<String> get packages => const [
    'm3e_collection',
    'dynamic_color',
    'google_fonts',
  ];

  /// Material's baseline seed.
  static const _baselineSeed = Color(0xFF6750A4);

  /// The device's accent color, which the design takes when no accent is
  /// picked, or null on a platform that has none.
  static Color? deviceAccent;

  /// Reads [deviceAccent]: the wallpaper's primary color on Android 12 and
  /// later, the system accent color on macOS, Windows and Linux.
  static Future<void> loadDeviceAccent() async {
    try {
      final palette = await DynamicColorPlugin.getCorePalette();
      if (palette != null) {
        deviceAccent = Color(palette.primary.get(40));
        return;
      }
      deviceAccent = await DynamicColorPlugin.getAccentColor();
    } catch (e) {
      // No device accent on this platform, so the baseline seed is used.
      debugPrint('No device accent color: $e');
      deviceAccent = null;
    }
  }

  /// A picked accent keeps its hue, so its primary matches the swatch. The
  /// device's accent is used as the system uses it. Without either, the
  /// expressive variant shifts the baseline seed's hue for the design's own
  /// colors.
  ColorScheme _materialColorScheme(
    Brightness brightness,
    AppAccentColor accent,
  ) {
    final picked = accent.paletteColor(brightness);
    final device = deviceAccent;
    return ColorScheme.fromSeed(
      seedColor: picked ?? device ?? _baselineSeed,
      brightness: brightness,
      dynamicSchemeVariant: switch ((picked, device)) {
        (_?, _) => DynamicSchemeVariant.fidelity,
        (null, _?) => DynamicSchemeVariant.tonalSpot,
        (null, null) => DynamicSchemeVariant.expressive,
      },
    );
  }

  @override
  Color defaultAccent(Brightness brightness) =>
      _materialColorScheme(brightness, AppAccentColor.designDefault).primary;

  // The tile's 28dp corner is 8dp rounder than the SDK default, so the
  // overflow button moves 8dp in to keep clear of it.
  @override
  StreamParticipantTileThemeData get participantTileTheme =>
      const StreamParticipantTileThemeData(
        style: StreamParticipantTileStyle(
          topToolbarPadding: EdgeInsets.all(8),
        ),
      );

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final material = _materialColorScheme(brightness, accent);
    final colorScheme = designColorScheme(
      brightness: brightness,
      // The tonal palette is seeded from the accent, so its primary is used
      // whichever accent is picked.
      accent: AppAccentColor.designDefault,
      defaultAccent: material.primary,
      textOnDefaultAccent: material.onPrimary,
      accentError: material.error,
      textPrimary: material.onSurface,
      textSecondary: material.onSurfaceVariant,
      backgroundApp: material.surface,
      backgroundElevation1: material.surfaceContainerLow,
      backgroundSurfaceCard: material.surfaceContainer,
      backgroundSurfaceSubtle: material.surfaceContainerHighest,
      borderDefault: material.outlineVariant,
      borderSubtle: material.outlineVariant,
    );

    return StreamTheme(
      brightness: brightness,
      icons: m3eStreamIcons,
      colorScheme: colorScheme,
      textTheme: designTextTheme(
        colorScheme.textPrimary,
        fontFamily: designGoogleFontsEnabled
            ? GoogleFonts.robotoFlex().fontFamily
            : null,
      ),
      // Expressive shapes run large: 12dp controls, 16-28dp containers.
      radius: const StreamRadius(
        xxs: Radius.circular(8),
        xs: Radius.circular(12),
        sm: Radius.circular(12),
        md: Radius.circular(16),
        lg: Radius.circular(20),
        xl: Radius.circular(28),
        xxl: Radius.circular(28),
        xxxl: Radius.circular(32),
      ),
    );
  }

  @override
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) {
    final colorScheme = _materialColorScheme(brightness, accent);
    final base = designMaterialTheme(
      streamTheme,
      materialColorScheme: colorScheme,
      textTheme: designGoogleFontsEnabled
          ? GoogleFonts.robotoFlexTextTheme(
              ThemeData(brightness: brightness).textTheme,
            )
          : null,
    );
    return base.copyWith(extensions: [M3ETheme.defaults(colorScheme)]);
  }

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => M3EStreamButton(props: props),
    splitButton: (context, props) => M3EStreamSplitButton(props: props),
    checkbox: (context, props) => Checkbox(
      value: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: switch (props.onChanged) {
        final onChanged? => (value) => onChanged(value ?? false),
        null => null,
      },
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: Switch(
        value: props.value,
        onChanged: props.onChanged,
        // Expressive switches carry a check on the thumb when on.
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check_rounded)
              : null,
        ),
      ),
    ),
    textInput: (context, props) =>
        MaterialStreamTextInput(props: props, outlined: true),
    progressBar: (context, props) => LinearProgressIndicatorM3E(
      value: props.value,
      activeColor: props.fillColor,
      trackColor: props.trackColor,
    ),
    loadingSpinner: (context, props) {
      final dimension = spinnerDimension(props.size);
      return SizedBox.square(
        dimension: dimension,
        child: FittedBox(
          child: switch (props.value) {
            // Without progress to show, the expressive loading indicator
            // morphs between shapes.
            null => LoadingIndicatorM3E(color: props.color),
            final value => CircularProgressIndicatorM3E(
              value: value,
              size: CircularProgressM3ESize.s,
              activeColor: props.color,
              trackColor: props.trackColor,
            ),
          },
        ),
      );
    },
    extensions: extensions,
  );
}
