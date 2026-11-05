// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shad/shad.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'shad_icons.dart';

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

/// The shad variant for a button of [type] and [style].
ShadButtonVariant _variant(StreamButtonType type, StreamButtonStyle style) =>
    switch ((type, style)) {
      (StreamButtonType.solid, StreamButtonStyle.primary) =>
        ShadButtonVariant.primary,
      (StreamButtonType.solid, StreamButtonStyle.destructive) =>
        ShadButtonVariant.destructive,
      (StreamButtonType.solid, _) => ShadButtonVariant.secondary,
      (StreamButtonType.outline, _) => ShadButtonVariant.outline,
      (StreamButtonType.ghost, _) => ShadButtonVariant.ghost,
    };

/// A [StreamButton] drawn as the matching [ShadButton] or [ShadIconButton].
class ShadStreamButton extends StatelessWidget {
  const ShadStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final selected = props.isSelected ?? false;
    // A selected button takes the primary fill, as a toggle that is on.
    final variant = selected
        ? ShadButtonVariant.primary
        : _variant(props.type, props.style);
    // An outline or ghost destructive button keeps its variant but reads red.
    final foreground =
        props.style == StreamButtonStyle.destructive &&
            props.type != StreamButtonType.solid
        ? ShadTheme.of(context).colorScheme.destructive
        : null;
    final height = props.size.value;
    // shad's secondary is the same color as its muted surfaces, such as a
    // participant tile, so a secondary button is lifted one step off it.
    final shadColors = ShadTheme.of(context).colorScheme;
    final background = variant == ShadButtonVariant.secondary
        ? Color.alphaBlend(
            shadColors.secondaryForeground.withValues(alpha: 0.1),
            shadColors.secondary,
          )
        : null;

    Widget button;
    if (props.child == null) {
      button = ShadIconButton.raw(
        variant: variant,
        icon: props.iconLeft ?? props.iconRight ?? const SizedBox.shrink(),
        onPressed: props.onPressed,
        enabled: props.onPressed != null,
        autofocus: props.autofocus,
        width: height,
        height: height,
        foregroundColor: foreground,
        backgroundColor: background,
        semanticLabel: props.tooltip,
      );
    } else {
      button = ShadButton.raw(
        variant: variant,
        leading: props.iconLeft,
        trailing: props.iconRight,
        onPressed: props.onPressed,
        enabled: props.onPressed != null,
        autofocus: props.autofocus,
        height: height,
        foregroundColor: foreground,
        backgroundColor: background,
        child: props.child,
      );
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

/// A `StreamSplitButton` drawn as a shadcn button group: two icon buttons in
/// one bordered surface, split by a separator.
///
/// shad has no button group yet, so it is put together here.
class ShadStreamSplitButton extends StatelessWidget {
  const ShadStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  @override
  Widget build(BuildContext context) {
    final shad = ShadTheme.of(context);
    final destructive = props.variant == StreamSplitButtonVariant.destructive;
    final radius = shad.radius;
    const height = 40.0;

    Widget half({
      required Widget icon,
      required VoidCallback? onPressed,
      required String? tooltip,
      required BorderRadius borderRadius,
    }) {
      Widget button = ShadIconButton.raw(
        variant: destructive
            ? ShadButtonVariant.destructive
            : ShadButtonVariant.ghost,
        icon: icon,
        onPressed: onPressed,
        enabled: onPressed != null,
        width: height,
        height: height,
        semanticLabel: tooltip,
        decoration: const ShadDecoration(border: ShadBorder.none),
        backgroundColor: destructive ? null : Colors.transparent,
        foregroundColor: destructive
            ? shad.colorScheme.destructiveForeground
            : null,
        hoverForegroundColor: destructive
            ? shad.colorScheme.destructiveForeground
            : null,
      );
      button = ClipRRect(borderRadius: borderRadius, child: button);
      if (tooltip != null) button = Tooltip(message: tooltip, child: button);
      return button;
    }

    return designSplitFrame(
      DecoratedBox(
        decoration: BoxDecoration(
          color: destructive
              ? shad.colorScheme.destructive
              : shad.colorScheme.background,
          borderRadius: radius,
          border: Border.all(
            color: destructive
                ? shad.colorScheme.destructive
                : shad.colorScheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            half(
              icon: props.leadingIcon,
              onPressed: props.onLeadingPressed,
              tooltip: props.leadingTooltip,
              borderRadius: BorderRadius.horizontal(
                left: radius.topLeft,
              ),
            ),
            SizedBox(
              height: height * 0.6,
              child: ShadSeparator.vertical(
                margin: EdgeInsets.zero,
                color: destructive
                    ? shad.colorScheme.destructiveForeground.withValues(
                        alpha: 0.4,
                      )
                    : shad.colorScheme.border,
              ),
            ),
            half(
              icon: props.trailingIcon,
              onPressed: props.onTrailingPressed,
              tooltip: props.trailingTooltip,
              borderRadius: BorderRadius.horizontal(
                right: radius.topRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A [StreamTextInput] drawn as a [ShadInput], with the label above it and the
/// helper text below it.
class ShadStreamTextInput extends StatelessWidget {
  const ShadStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    final hint = props.hintText;

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: ShadInput(
        controller: props.controller,
        initialValue: props.controller == null ? props.initialValue : null,
        focusNode: props.focusNode,
        placeholder: hint == null ? null : Text(hint),
        leading: props.leading,
        trailing: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        textCapitalization: props.textCapitalization,
        textAlign: props.textAlign,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onEditingComplete: props.onEditingComplete,
        onSubmitted: props.onSubmitted,
        onPressed: props.onTap,
      ),
    );
  }
}
