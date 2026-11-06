// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:shad/shad.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;

import '../app_design_spec.dart';

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
