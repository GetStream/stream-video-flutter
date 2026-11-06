import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

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
      // A selected button is drawn solid in the accent, or in the error color
      // when destructive, as the icon buttons are.
      final selected = props.isSelected ?? false;
      final type = selected ? StreamButtonType.solid : props.type;
      final style = selected && !destructive
          ? StreamButtonStyle.primary
          : props.style;
      button = switch ((type, style)) {
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
      child: padToTapTarget(
        context,
        button,
        tapTargetSize: props.themeStyle?.tapTargetSize,
      ),
    );
  }
}
