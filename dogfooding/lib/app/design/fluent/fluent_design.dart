// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import 'fluent_icons.dart';

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

/// A [StreamButton] drawn as the fluent_ui button for its type: filled for
/// solid primary and destructive, a hyperlink or icon button for ghost, and a
/// standard button otherwise.
class FluentStreamButton extends StatelessWidget {
  const FluentStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final destructive = props.style == StreamButtonStyle.destructive;
    final height = props.size.value;
    final iconOnly = props.child == null;
    final selected = props.isSelected ?? false;

    final style = destructive
        ? fluent.ButtonStyle(
            padding: iconOnly
                ? const WidgetStatePropertyAll(EdgeInsets.zero)
                : null,
            foregroundColor: WidgetStatePropertyAll(
              props.type == StreamButtonType.solid
                  ? colorScheme.textOnAccent
                  : colorScheme.accentError,
            ),
            backgroundColor: props.type == StreamButtonType.solid
                ? WidgetStatePropertyAll(colorScheme.accentError)
                : null,
          )
        // Fluent buttons pad their content for a label, which pushes an icon
        // off center in a square button.
        : iconOnly
        ? const fluent.ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          )
        : null;

    final content = iconOnly
        ? Center(
            child: props.iconLeft ?? props.iconRight ?? const SizedBox.shrink(),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              ?props.iconLeft,
              Flexible(child: props.child!),
              ?props.iconRight,
            ],
          );

    Widget button = switch (props.type) {
      _ when selected => fluent.FilledButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: style,
        child: content,
      ),
      StreamButtonType.solid when props.style != StreamButtonStyle.secondary =>
        fluent.FilledButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          child: content,
        ),
      StreamButtonType.ghost when iconOnly => fluent.IconButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: style,
        icon: content,
      ),
      StreamButtonType.ghost => fluent.HyperlinkButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: style,
        child: content,
      ),
      _ => fluent.Button(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: style,
        child: content,
      ),
    };

    button = iconOnly
        ? SizedBox.square(dimension: height, child: button)
        // A fluent_ui button fills the height it is given.
        : SizedBox(height: height, child: button);

    if (props.tooltip case final tooltip?) {
      button = fluent.Tooltip(message: tooltip, child: button);
    }
    return Semantics(
      button: true,
      selected: props.isSelected,
      child: padToTapTarget(context, button),
    );
  }
}

/// A `StreamSplitButton` drawn as a fluent_ui [fluent.SplitButton], whose
/// caret half runs the SDK's callback instead of opening a flyout. The
/// destructive variant is the checked split button in the error color.
class FluentStreamSplitButton extends StatelessWidget {
  const FluentStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  @override
  Widget build(BuildContext context) {
    final destructive = props.variant == StreamSplitButtonVariant.destructive;

    // Drawn like the library's own caret half, so a checked split button
    // fills both halves with the accent.
    Widget trailing(
      BuildContext context,
      VoidCallback showFlyout,
      fluent.FlyoutController controller,
    ) {
      final theme = fluent.FluentTheme.of(context);
      Widget button = fluent.HoverButton(
        onPressed: props.onTrailingPressed,
        builder: (context, states) => Container(
          color: destructive
              ? fluent.ButtonThemeData.checkedInputColor(theme, states)
              : fluent.ButtonThemeData.buttonColor(
                  context,
                  states,
                  transparentWhenNone: true,
                ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: IconTheme.merge(
            data: IconThemeData(
              color: destructive
                  ? fluent.FilledButton.foregroundColor(theme, states)
                  : null,
            ),
            child: props.trailingIcon,
          ),
        ),
      );
      if (props.trailingTooltip case final tooltip?) {
        button = fluent.Tooltip(message: tooltip, child: button);
      }
      return button;
    }

    Widget leading = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: props.leadingIcon,
    );
    if (props.leadingTooltip case final tooltip?) {
      leading = fluent.Tooltip(message: tooltip, child: leading);
    }

    Widget button = destructive
        ? fluent.SplitButton.toggle(
            checked: true,
            onInvoked: props.onLeadingPressed,
            secondaryBuilder: trailing,
            flyout: const SizedBox.shrink(),
            child: leading,
          )
        : fluent.SplitButton(
            onInvoked: props.onLeadingPressed,
            secondaryBuilder: trailing,
            flyout: const SizedBox.shrink(),
            child: leading,
          );

    if (destructive) {
      final theme = fluent.FluentTheme.of(context);
      button = fluent.FluentTheme(
        data: theme.copyWith(
          accentColor: context.streamColorScheme.accentError.toAccentColor(),
        ),
        child: button,
      );
    }
    // The library draws its split button at a height of its own.
    return designSplitFrame(button, scale: true);
  }
}

/// A [StreamTextInput] drawn as a fluent_ui [fluent.TextBox], with the label
/// above it and the helper text below it.
class FluentStreamTextInput extends StatelessWidget {
  const FluentStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    // A TextBox takes its text from a controller only.
    if (props.controller == null && props.initialValue != null) {
      return DefaultStreamTextInput(props: props);
    }

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: fluent.TextBox(
        controller: props.controller,
        focusNode: props.focusNode,
        placeholder: props.hintText,
        prefix: props.leading,
        suffix: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        textCapitalization: props.textCapitalization,
        textAlign: props.textAlign,
        textAlignVertical: props.textAlignVertical,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onEditingComplete: props.onEditingComplete,
        onSubmitted: props.onSubmitted,
        onTap: props.onTap,
      ),
    );
  }
}
