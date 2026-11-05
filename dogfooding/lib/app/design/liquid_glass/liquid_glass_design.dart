import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'liquid_glass_button.dart';
import 'liquid_glass_icons.dart';
import 'liquid_glass_split_button.dart';
import 'liquid_glass_text_input.dart';

/// Apple's Liquid Glass, through liquid_glass_widgets: refracting glass
/// controls, the system blue and SF Symbols-style icons.
///
/// Each control draws its own glass layer, as the SDK places them one by one.
class LiquidGlassDesign extends AppDesignSpec {
  const LiquidGlassDesign();

  @override
  List<String> get packages => const ['liquid_glass_widgets'];

  @override
  Color defaultAccent(Brightness brightness) => switch (brightness) {
    Brightness.light => const Color(0xFF007AFF),
    Brightness.dark => const Color(0xFF0A84FF),
  };

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final light = brightness == Brightness.light;
    final colorScheme = designColorScheme(
      brightness: brightness,
      accent: accent,
      defaultAccent: defaultAccent(brightness),
      accentSuccess: light ? const Color(0xFF34C759) : const Color(0xFF30D158),
      accentWarning: light ? const Color(0xFFFF9500) : const Color(0xFFFF9F0A),
      accentError: light ? const Color(0xFFFF3B30) : const Color(0xFFFF453A),
      backgroundApp: light ? const Color(0xFFF2F2F7) : null,
    );

    return StreamTheme(
      brightness: brightness,
      icons: liquidGlassStreamIcons,
      colorScheme: colorScheme,
    );
  }

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => LiquidGlassStreamButton(props: props),
    splitButton: (context, props) => LiquidGlassStreamSplitButton(props: props),
    toggleSwitch: (context, props) => GlassSwitch(
      value: props.value,
      onChanged: props.onChanged ?? (_) {},
      activeColor: context.streamColorScheme.accentPrimary,
      semanticLabel: props.semanticLabel,
      useOwnLayer: true,
    ),
    textInput: (context, props) => LiquidGlassStreamTextInput(props: props),
    progressBar: (context, props) => GlassProgressIndicator.linear(
      value: props.value,
      height: props.minHeight ?? 4,
      // Clear glass barely shows against the content, so progress is drawn in
      // the accent color.
      color: props.fillColor ?? context.streamColorScheme.accentPrimary,
      backgroundColor: props.trackColor,
      useOwnLayer: true,
    ),
    loadingSpinner: (context, props) {
      final dimension = spinnerDimension(props.size);
      return GlassProgressIndicator.circular(
        value: props.value,
        size: dimension,
        strokeWidth: (props.size ?? StreamLoadingSpinnerSize.md).strokeWidth,
        color: props.color ?? context.streamColorScheme.accentPrimary,
        backgroundColor: props.trackColor,
        useOwnLayer: true,
      );
    },
    extensions: extensions,
  );

  @override
  Widget wrap(BuildContext context, AppAccentColor accent, Widget child) =>
      LiquidGlassWidgets.wrap(
        theme: const GlassThemeData.ios27(),
        // Follows the app's theme mode rather than the device's.
        brightnessResolver: Theme.maybeBrightnessOf,
        child: child,
      );
}
