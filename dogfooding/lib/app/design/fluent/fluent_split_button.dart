// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

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
