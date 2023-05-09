import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Widget that represents a call control option.
class CallControlOption extends StatelessWidget {
  /// Creates a new instance of [CallControlOption].
  const CallControlOption({
    super.key,
    required this.icon,
    this.iconColor,
    this.disabledIconColor,
    this.elevation,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.shape,
    this.padding,
    this.onPressed,
  });

  /// The icon of the call control option.
  final Widget icon;

  /// The color of the icon of the call control option.
  final Color? iconColor;

  /// The color of the icon of the call control option when it is disabled.
  final Color? disabledIconColor;

  /// The elevation of the call control option.
  final double? elevation;

  /// The background color of the call control option.
  final Color? backgroundColor;

  /// The background color of the call control option when it is disabled.
  final Color? disabledBackgroundColor;

  /// The shape of the call control option.
  final OutlinedBorder? shape;

  /// The padding applied to the call control option.
  final EdgeInsetsGeometry? padding;

  /// The callback to invoke when the user taps on the call control option.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallControlsTheme.of(context);

    Color? iconColor;
    if (onPressed != null) {
      iconColor = this.iconColor ?? theme.optionIconColor;
    } else {
      iconColor = disabledIconColor ?? theme.inactiveOptionIconColor;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? theme.optionElevation,
        backgroundColor: backgroundColor ?? theme.optionBackgroundColor,
        shape: shape ?? theme.optionShape,
        padding: padding ?? theme.optionPadding,
        disabledBackgroundColor:
            disabledBackgroundColor ?? theme.inactiveOptionBackgroundColor,
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          color: iconColor,
        ),
        child: icon,
      ),
    );
  }
}
