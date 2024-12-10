import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if closed captions
/// is on or off.
class ToggleClosedCaptionsOption extends StatelessWidget {
  /// Creates a new instance of [ToggleClosedCaptionsOption].
  const ToggleClosedCaptionsOption({
    super.key,
    required this.call,
    this.enabledClosedCaptionIcon = Icons.closed_caption_rounded,
    this.disabledClosedCaptionIcon = Icons.closed_caption_disabled_rounded,
    this.enabledClosedCaptionIconColor,
    this.disabledClosedCaptionIconColor,
    this.enabledClosedCaptionBackgroundColor,
    this.disabledClosedCaptionBackgroundColor,
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the closed caption is enabled.
  final IconData enabledClosedCaptionIcon;

  /// The icon that is shown when the closed caption is disabled.
  final IconData disabledClosedCaptionIcon;

  /// Color of the icon when closed caption is enabled
  final Color? enabledClosedCaptionIconColor;

  /// Color of the icon when closed caption is disabled
  final Color? disabledClosedCaptionIconColor;

  /// Color of the background when closed caption is enabled
  final Color? enabledClosedCaptionBackgroundColor;

  /// Color of the background when closed caption is disabled
  final Color? disabledClosedCaptionBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final enabled = call.state.value.isCaptioning;

    return CallControlOption(
      icon: enabled
          ? Icon(enabledClosedCaptionIcon)
          : Icon(disabledClosedCaptionIcon),
      iconColor: enabled
          ? enabledClosedCaptionIconColor
          : disabledClosedCaptionIconColor,
      backgroundColor: enabled
          ? enabledClosedCaptionBackgroundColor
          : disabledClosedCaptionBackgroundColor,
      onPressed: () {
        if (!enabled) {
          call.startClosedCaptions();
        } else {
          call.stopClosedCaptions();
        }
      },
    );
  }
}
