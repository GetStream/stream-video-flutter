// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:yaru/yaru.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import '../material_text_input.dart';
import 'yaru_icons.dart';

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

/// A [StreamButton] drawn as the Material button the Yaru theme styles for
/// its type: elevated (the accent fill) for solid primary, filled for other
/// solid buttons, outlined and text buttons for the outline and ghost types.
class YaruStreamButton extends StatelessWidget {
  const YaruStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final destructive = props.style == StreamButtonStyle.destructive;
    final height = props.size.value;

    Widget button;
    if (props.child == null) {
      final icon = props.iconLeft ?? props.iconRight ?? const SizedBox.shrink();
      // Yaru's icon button theme caps the size and uses a compact density,
      // which would shrink the button below the size the SDK asks for.
      final style = IconButton.styleFrom(
        fixedSize: Size.square(height),
        minimumSize: Size.square(height),
        maximumSize: Size.square(height),
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: destructive && props.type != StreamButtonType.solid
            ? colorScheme.error
            : null,
        backgroundColor: destructive && props.type == StreamButtonType.solid
            ? colorScheme.error
            : null,
      );
      // Secondary buttons take the neutral fill of Yaru's filled buttons,
      // primary and selected ones the accent.
      final neutralFill = Theme.of(
        context,
      ).filledButtonTheme.style?.backgroundColor?.resolve(const {});
      button = switch ((props.type, props.style, props.isSelected ?? false)) {
        (StreamButtonType.solid, StreamButtonStyle.secondary, false) =>
          IconButton.filled(
            onPressed: props.onPressed,
            autofocus: props.autofocus,
            style: style.copyWith(
              backgroundColor: WidgetStatePropertyAll(
                neutralFill ?? colorScheme.surfaceContainerHighest,
              ),
              foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
            ),
            icon: icon,
          ),
        (StreamButtonType.solid, _, _) || (_, _, true) => IconButton.filled(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.outline, _, _) => IconButton.outlined(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.ghost, _, _) => IconButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
      };
    } else {
      final child = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          ?props.iconLeft,
          Flexible(child: props.child!),
          ?props.iconRight,
        ],
      );
      final minimumSize = Size(0, height);
      button = switch ((props.type, props.style)) {
        (StreamButtonType.solid, StreamButtonStyle.primary) => ElevatedButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: ElevatedButton.styleFrom(minimumSize: minimumSize),
          child: child,
        ),
        (StreamButtonType.solid, StreamButtonStyle.destructive) =>
          ElevatedButton(
            onPressed: props.onPressed,
            autofocus: props.autofocus,
            style: ElevatedButton.styleFrom(
              minimumSize: minimumSize,
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: child,
          ),
        (StreamButtonType.solid, _) => FilledButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: FilledButton.styleFrom(minimumSize: minimumSize),
          child: child,
        ),
        (StreamButtonType.outline, _) => OutlinedButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: destructive ? colorScheme.error : null,
          ),
          child: child,
        ),
        (StreamButtonType.ghost, _) => TextButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: destructive ? colorScheme.error : null,
          ),
          child: child,
        ),
      };
    }

    if (props.tooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }
    return Semantics(
      selected: props.isSelected,
      child: padToTapTarget(context, button),
    );
  }
}

/// A `StreamSplitButton` drawn as a [YaruSplitButton]: outlined, or filled in
/// the error color for the destructive variant.
class YaruStreamSplitButton extends StatelessWidget {
  const YaruStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  @override
  Widget build(BuildContext context) {
    Widget button;
    if (props.variant == StreamSplitButtonVariant.destructive) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      button = Theme(
        data: theme.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            // Over Yaru's own style, which sets the button's size and shape.
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ).merge(theme.elevatedButtonTheme.style),
          ),
        ),
        child: YaruSplitButton(
          onPressed: props.onLeadingPressed,
          onOptionsPressed: props.onTrailingPressed,
          icon: props.trailingIcon,
          iconSemanticLabel: props.trailingTooltip,
          child: props.leadingIcon,
        ),
      );
    } else {
      button = YaruSplitButton.outlined(
        onPressed: props.onLeadingPressed,
        onOptionsPressed: props.onTrailingPressed,
        icon: props.trailingIcon,
        iconSemanticLabel: props.trailingTooltip,
        child: props.leadingIcon,
      );
    }

    if (props.leadingTooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }
    // The library draws its split button at a height of its own.
    return designSplitFrame(button, scale: true);
  }
}
