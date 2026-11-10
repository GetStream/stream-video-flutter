import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

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
      child: padToTapTarget(
        context,
        button,
        tapTargetSize: props.themeStyle?.tapTargetSize,
      ),
    );
  }
}
