import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:yaru/yaru.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import '../material_text_input.dart';
import 'yaru_button.dart';
import 'yaru_icons.dart';
import 'yaru_split_button.dart';

/// Yaru's bundled Ubuntu font.
const _yaruFontFamily = 'packages/yaru/Ubuntu';

/// Ubuntu's Yaru: the Ubuntu orange accent, warm greys, the Ubuntu font and
/// GTK-style controls.
class YaruDesign extends AppDesignSpec {
  const YaruDesign();

  @override
  List<String> get packages => const ['yaru'];

  @override
  Color defaultAccent(Brightness brightness) => YaruColors.orange;

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final yaruColors = YaruColors.from(brightness);
    final light = brightness == Brightness.light;
    final colorScheme = designColorScheme(
      brightness: brightness,
      accent: accent,
      defaultAccent: YaruColors.orange,
      accentSuccess: yaruColors.success,
      accentWarning: yaruColors.warning,
      accentError: yaruColors.error,
      textPrimary: light ? YaruColors.jet : null,
      backgroundApp: light ? YaruColors.porcelain : YaruColors.jet,
      backgroundElevation1: light ? null : const Color(0xFF2B2B2B),
      borderDefault: light ? const Color(0xFFDEDEDE) : const Color(0xFF444444),
      borderSubtle: light ? const Color(0xFFEBEBEB) : const Color(0xFF363636),
    );

    return StreamTheme(
      brightness: brightness,
      icons: yaruStreamIcons,
      colorScheme: colorScheme,
      textTheme: designTextTheme(
        colorScheme.textPrimary,
        fontFamily: _yaruFontFamily,
      ),
      // Yaru controls round to 6px, cards and dialogs to 8-12px.
      radius: const StreamRadius(
        xxs: Radius.circular(4),
        xs: Radius.circular(6),
        md: Radius.circular(6),
        lg: Radius.circular(8),
        xl: Radius.circular(12),
        xxl: Radius.circular(12),
        xxxl: Radius.circular(12),
        xxxxl: Radius.circular(12),
      ),
    );
  }

  /// Yaru's own Material theme, which styles the Material buttons and fields
  /// the component builders use, in the picked accent.
  @override
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) {
    final primaryColor = accentColor(brightness, accent);
    final theme = switch (brightness) {
      Brightness.light => createYaruLightTheme(primaryColor: primaryColor),
      Brightness.dark => createYaruDarkTheme(primaryColor: primaryColor),
    };
    final listTileTheme = theme.listTileTheme;
    // Over the type geometry, as Material resolves the text theme, so the
    // styles animate into another design's.
    final geometry = Typography.material2021().englishLike;
    return theme.copyWith(
      listTileTheme: listTileTheme.copyWith(
        titleTextStyle: geometry.bodyLarge!.merge(listTileTheme.titleTextStyle),
        subtitleTextStyle: geometry.bodyMedium!.merge(
          listTileTheme.subtitleTextStyle,
        ),
        leadingAndTrailingTextStyle: geometry.labelSmall!.merge(
          listTileTheme.leadingAndTrailingTextStyle,
        ),
      ),
    );
  }

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => YaruStreamButton(props: props),
    splitButton: (context, props) => YaruStreamSplitButton(props: props),
    checkbox: (context, props) => Semantics(
      checked: props.value,
      label: props.semanticLabel,
      child: YaruCheckbox(
        value: props.value,
        onChanged: switch (props.onChanged) {
          final onChanged? => (value) => onChanged(value ?? false),
          null => null,
        },
      ),
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: YaruSwitch(value: props.value, onChanged: props.onChanged),
    ),
    textInput: (context, props) => MaterialStreamTextInput(props: props),
    progressBar: (context, props) => YaruLinearProgressIndicator(
      value: props.value,
      color: props.fillColor,
      trackColor: props.trackColor,
    ),
    loadingSpinner: (context, props) {
      final dimension = spinnerDimension(props.size);
      return SizedBox.square(
        dimension: dimension,
        child: YaruCircularProgressIndicator(
          value: props.value,
          color: props.color,
          trackColor: props.trackColor,
          strokeWidth: dimension / 8,
        ),
      );
    },
    extensions: extensions,
  );
}
