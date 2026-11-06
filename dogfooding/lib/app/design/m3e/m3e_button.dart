import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

/// The theme for a button in the error color, for the destructive style.
ThemeData _destructiveTheme(ThemeData theme) {
  final colorScheme = theme.colorScheme;
  return theme.copyWith(
    colorScheme: colorScheme.copyWith(
      primary: colorScheme.error,
      onPrimary: colorScheme.onError,
      secondaryContainer: colorScheme.errorContainer,
      onSecondaryContainer: colorScheme.onErrorContainer,
    ),
  );
}

/// A [StreamButton] drawn as an M3E [ButtonM3E] or [IconButtonM3E]: filled
/// for solid primary, tonal for other solid buttons, outlined and standard
/// (text) for the outline and ghost types.
class M3EStreamButton extends StatelessWidget {
  const M3EStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final selected = props.isSelected ?? false;
    final enabled = props.onPressed != null;

    final size = props.size.value;
    Widget button;
    if (props.child == null) {
      // Material's own icon buttons, which take the exact size asked for: the
      // m3e icon button pads itself to a tap target, so it would paint smaller
      // than the SDK's when fitted in.
      final icon = props.iconLeft ?? props.iconRight ?? const SizedBox.shrink();
      final style =
          IconButton.styleFrom(
            fixedSize: Size.square(size),
            minimumSize: Size.square(size),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.standard,
          ).copyWith(
            // Expressive buttons change shape with their state: round while
            // off, a rounded square while on, and squarer still while pressed.
            shape: WidgetStateProperty.resolveWith(
              (states) => switch (states) {
                _ when states.contains(WidgetState.pressed) =>
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size * 0.2),
                  ),
                _ when states.contains(WidgetState.selected) =>
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size * 0.3),
                  ),
                _ => const StadiumBorder(),
              },
            ),
          );
      button = switch ((props.type, props.style)) {
        _ when selected => IconButton.filled(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.solid, StreamButtonStyle.secondary) =>
          IconButton.filledTonal(
            onPressed: props.onPressed,
            tooltip: props.tooltip,
            // Only a selected button is a toggle; false would recolor the
            // others as toggles that are off.
            isSelected: selected ? true : null,
            style: style,
            icon: icon,
          ),
        (StreamButtonType.solid, _) => IconButton.filled(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.outline, _) => IconButton.outlined(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.ghost, _) => IconButton(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
      };
    } else {
      // The m3e buttons come in fixed sizes, the large one taller than the
      // SDK's, so the height is set here. The width is left free, so a button
      // still stretches where the SDK's would.
      button = SizedBox(
        height: size,
        child: ButtonM3E(
          onPressed: props.onPressed ?? () {},
          enabled: enabled,
          selected: selected,
          icon: props.iconLeft,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Flexible(child: props.child!),
              ?props.iconRight,
            ],
          ),
          size: switch (props.size) {
            StreamButtonSize.small => ButtonM3ESize.xs,
            StreamButtonSize.medium => ButtonM3ESize.sm,
            StreamButtonSize.large => ButtonM3ESize.sm,
          },
          style: switch ((props.type, props.style)) {
            (StreamButtonType.solid, StreamButtonStyle.secondary) =>
              ButtonM3EStyle.tonal,
            (StreamButtonType.solid, _) => ButtonM3EStyle.filled,
            (StreamButtonType.outline, _) => ButtonM3EStyle.outlined,
            (StreamButtonType.ghost, _) => ButtonM3EStyle.text,
          },
        ),
      );
      if (props.tooltip case final tooltip?) {
        button = Tooltip(message: tooltip, child: button);
      }
    }

    if (props.style == StreamButtonStyle.destructive) {
      button = Theme(data: _destructiveTheme(Theme.of(context)), child: button);
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
