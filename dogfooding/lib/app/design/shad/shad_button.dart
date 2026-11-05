import 'package:flutter/material.dart';
import 'package:shad/shad.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

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
    // A selected button takes the primary fill, as a toggle that is on, or
    // the destructive one when it is destructive, as a running recording.
    final variant = switch (props.style) {
      StreamButtonStyle.destructive when selected =>
        ShadButtonVariant.destructive,
      _ when selected => ShadButtonVariant.primary,
      _ => _variant(props.type, props.style),
    };
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
