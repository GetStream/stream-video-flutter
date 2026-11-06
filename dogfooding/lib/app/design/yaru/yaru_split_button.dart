// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:yaru/yaru.dart';

import '../app_design_spec.dart';

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
