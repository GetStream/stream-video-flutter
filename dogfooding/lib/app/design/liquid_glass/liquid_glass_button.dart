import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

/// Glass tinted with [color], for buttons that carry a fill in the other
/// designs.
LiquidGlassSettings tintedGlass(Color color) =>
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
          final tint? => tintedGlass(tint),
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
          final tint? => tintedGlass(tint),
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
