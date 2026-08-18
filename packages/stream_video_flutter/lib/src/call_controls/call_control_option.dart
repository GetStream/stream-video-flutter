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
    // Translate the legacy padding into a circle diameter so callers that
    // requested larger buttons (e.g. incoming/outgoing accept/decline) keep
    // their prominence. Icons render at the button's default 20px icon size.
    final resolvedPadding = padding?.resolve(
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );
    final diameter = resolvedPadding == null
        ? null
        : 20 + resolvedPadding.vertical;

    return StreamButton.icon(
      icon: icon,
      onPressed: onPressed,
      style: StreamButtonStyle.secondary,
      isFloating: (elevation ?? 0) > 0,
      themeStyle: StreamButtonThemeStyle.from(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        foregroundColor: iconColor,
        disabledForegroundColor: disabledIconColor,
        shape: shape,
        fixedSize: diameter == null ? null : Size.square(diameter),
      ),
    );
  }
}
