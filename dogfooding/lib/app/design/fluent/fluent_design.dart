import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'fluent_button.dart';
import 'fluent_icons.dart';
import 'fluent_split_button.dart';
import 'fluent_text_input.dart';

const _fluentFontFamily = 'Segoe UI Variable';
const _fluentFontFamilyFallback = ['Segoe UI', 'SF Pro Text', 'Roboto'];

/// Windows 11's Fluent: the Windows accent blue, Mica-like greys, Segoe UI
/// and the Fluent System icons, with fluent_ui's controls.
class FluentDesign extends AppDesignSpec {
  const FluentDesign();

  @override
  List<String> get packages => const ['fluent_ui', 'fluentui_system_icons'];

  @override
  Color defaultAccent(Brightness brightness) => switch (brightness) {
    Brightness.light => const Color(0xFF005FB8),
    Brightness.dark => const Color(0xFF60CDFF),
  };

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final light = brightness == Brightness.light;
    final colorScheme = designColorScheme(
      brightness: brightness,
      accent: accent,
      defaultAccent: defaultAccent(brightness),
      textOnDefaultAccent: light ? null : Colors.black,
      accentSuccess: light ? const Color(0xFF0F7B0F) : const Color(0xFF6CCB5F),
      accentWarning: light ? const Color(0xFF9D5D00) : const Color(0xFFFCE100),
      accentError: light ? const Color(0xFFC42B1C) : const Color(0xFFFF99A4),
      textPrimary: light ? const Color(0xE4000000) : null,
      textSecondary: light ? const Color(0x9E000000) : null,
      backgroundApp: light ? const Color(0xFFF3F3F3) : const Color(0xFF202020),
      backgroundElevation1: light
          ? const Color(0xFFFBFBFB)
          : const Color(0xFF2B2B2B),
      backgroundSurfaceCard: light ? Colors.white : const Color(0xFF2D2D2D),
      borderDefault: light ? const Color(0xFFE5E5E5) : const Color(0x12FFFFFF),
      borderSubtle: light ? const Color(0x0F000000) : const Color(0x0FFFFFFF),
    );

    return StreamTheme(
      brightness: brightness,
      icons: fluentStreamIcons,
      colorScheme: colorScheme,
      textTheme: designTextTheme(
        colorScheme.textPrimary,
        fontFamily: _fluentFontFamily,
        fontFamilyFallback: _fluentFontFamilyFallback,
      ),
      // Fluent controls round to 4px, flyouts and dialogs to 8px.
      radius: const StreamRadius(
        sm: Radius.circular(4),
        md: Radius.circular(4),
        lg: Radius.circular(8),
        xl: Radius.circular(8),
        xxl: Radius.circular(8),
        xxxl: Radius.circular(8),
        xxxxl: Radius.circular(8),
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
    fontFamily: _fluentFontFamily,
    fontFamilyFallback: _fluentFontFamilyFallback,
  );

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => FluentStreamButton(props: props),
    splitButton: (context, props) => FluentStreamSplitButton(props: props),
    checkbox: (context, props) => fluent.Checkbox(
      checked: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: switch (props.onChanged) {
        final onChanged? => (value) => onChanged(value ?? false),
        null => null,
      },
    ),
    toggleSwitch: (context, props) => fluent.ToggleSwitch(
      checked: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: props.onChanged,
    ),
    textInput: (context, props) => FluentStreamTextInput(props: props),
    // fluent_ui's progress runs from 0 to 100.
    progressBar: (context, props) => fluent.ProgressBar(
      value: switch (props.value) {
        final value? => value * 100,
        null => null,
      },
      activeColor: props.fillColor,
      backgroundColor: props.trackColor,
    ),
    loadingSpinner: (context, props) {
      final dimension = spinnerDimension(props.size);
      return SizedBox.square(
        dimension: dimension,
        child: fluent.ProgressRing(
          value: switch (props.value) {
            final value? => value * 100,
            null => null,
          },
          strokeWidth: dimension / 8,
          activeColor: props.color,
          backgroundColor: props.trackColor,
        ),
      );
    },
    extensions: extensions,
  );

  @override
  Widget wrap(BuildContext context, AppAccentColor accent, Widget child) {
    final brightness = Theme.of(context).brightness;
    return fluent.FluentTheme(
      data: fluent.FluentThemeData(
        brightness: brightness,
        accentColor: accentColor(brightness, accent).toAccentColor(),
        fontFamily: _fluentFontFamily,
        visualDensity: fluent.VisualDensity.standard,
      ),
      child: child,
    );
  }
}
