// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';
import 'liquid_glass_button.dart';

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
        settings: destructive ? tintedGlass(colorScheme.accentError) : null,
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
