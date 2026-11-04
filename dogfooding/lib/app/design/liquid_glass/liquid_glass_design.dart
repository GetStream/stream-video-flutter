// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'liquid_glass_icons.dart';

/// Apple's Liquid Glass, through liquid_glass_widgets: refracting glass
/// controls, the system blue and SF Symbols-style icons.
///
/// Each control draws its own glass layer, as the SDK places them one by one.
class LiquidGlassDesign extends AppDesignSpec {
  const LiquidGlassDesign();

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

/// Glass tinted with [color], for buttons that carry a fill in the other
/// designs.
LiquidGlassSettings _tinted(Color color) =>
    LiquidGlassSettings(glassColor: color.withValues(alpha: 0.6));

/// A [StreamButton] drawn as a [GlassButton]: tinted with the accent when
/// solid primary or selected, with the error color when solid destructive,
/// and clear otherwise.
class LiquidGlassStreamButton extends StatelessWidget {
  const LiquidGlassStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final selected = props.isSelected ?? false;
    final solid = props.type == StreamButtonType.solid;
    final destructive = props.style == StreamButtonStyle.destructive;
    final height = props.size.value;

    final tint = switch (props.style) {
      _ when selected => colorScheme.accentPrimary,
      StreamButtonStyle.primary when solid => colorScheme.accentPrimary,
      StreamButtonStyle.destructive when solid => colorScheme.accentError,
      _ => null,
    };
    final foreground = switch (tint) {
      _? => colorScheme.textOnAccent,
      null when destructive => colorScheme.accentError,
      null => colorScheme.textPrimary,
    };
    final style = switch (props.type) {
      _ when tint != null => GlassButtonStyle.prominent,
      StreamButtonType.ghost => GlassButtonStyle.transparent,
      _ => GlassButtonStyle.filled,
    };
    final enabled = props.onPressed != null;
    final onTap = props.onPressed ?? () {};

    Widget button;
    if (props.child == null) {
      button = GlassButton(
        icon: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: props.iconLeft ?? props.iconRight ?? const SizedBox.shrink(),
        ),
        onTap: onTap,
        enabled: enabled,
        autofocus: props.autofocus,
        width: height,
        height: height,
        iconSize: 20,
        iconColor: foreground,
        style: style,
        settings: switch (tint) {
          final tint? => _tinted(tint),
          null => null,
        },
        useOwnLayer: true,
      );
    } else {
      button = GlassButton.custom(
        onTap: onTap,
        autofocus: props.autofocus,
        height: height,
        shape: LiquidRoundedSuperellipse(borderRadius: height / 2),
        settings: switch (tint) {
          final tint? => _tinted(tint),
          null => null,
        },
        useOwnLayer: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconTheme.merge(
            data: IconThemeData(color: foreground),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: foreground),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  ?props.iconLeft,
                  Flexible(child: props.child!),
                  ?props.iconRight,
                ],
              ),
            ),
          ),
        ),
      );
      if (!enabled) button = Opacity(opacity: 0.5, child: button);
    }

    if (props.tooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }
    return Semantics(
      button: true,
      enabled: enabled,
      selected: props.isSelected,
      child: padToTapTarget(context, button),
    );
  }
}

/// A `StreamSplitButton` drawn as a [GlassButtonGroup]: two clear glass halves
/// in one pill, split by a divider, tinted with the error color when
/// destructive.
class LiquidGlassStreamSplitButton extends StatelessWidget {
  const LiquidGlassStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final destructive = props.variant == StreamSplitButtonVariant.destructive;
    final foreground = destructive
        ? colorScheme.textOnAccent
        : colorScheme.textPrimary;

    Widget half(Widget icon, VoidCallback? onPressed, String? tooltip) {
      Widget button = GlassButton(
        icon: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: icon,
        ),
        onTap: onPressed ?? () {},
        enabled: onPressed != null,
        width: 44,
        height: 40,
        iconSize: 20,
        iconColor: foreground,
        style: GlassButtonStyle.transparent,
      );
      if (tooltip != null) button = Tooltip(message: tooltip, child: button);
      return button;
    }

    return designSplitFrame(
      GlassButtonGroup(
        useOwnLayer: true,
        borderRadius: 20,
        itemPadding: EdgeInsets.zero,
        settings: destructive ? _tinted(colorScheme.accentError) : null,
        children: [
          half(props.leadingIcon, props.onLeadingPressed, props.leadingTooltip),
          half(
            props.trailingIcon,
            props.onTrailingPressed,
            props.trailingTooltip,
          ),
        ],
      ),
    );
  }
}

/// A [StreamTextInput] drawn as a [GlassTextField], with the label above it
/// and the helper text below it.
class LiquidGlassStreamTextInput extends StatelessWidget {
  const LiquidGlassStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    // A GlassTextField takes its text from a controller only.
    if (props.controller == null && props.initialValue != null) {
      return DefaultStreamTextInput(props: props);
    }

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: GlassTextField(
        controller: props.controller,
        focusNode: props.focusNode,
        placeholder: props.hintText,
        prefixIcon: props.leading,
        suffixIcon: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines ?? 1,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onSubmitted: props.onSubmitted,
        // The SDK field's padding, so the glass field is as tall as the
        // others rather than taller.
        padding:
            props.style?.contentPadding?.resolve(Directionality.of(context)) ??
            EdgeInsets.symmetric(
              horizontal: context.streamSpacing.md,
              vertical: context.streamSpacing.sm,
            ),
        useOwnLayer: true,
      ),
    );
  }
}
