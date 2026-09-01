import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if closed captions
/// is on or off.
class ToggleClosedCaptionsOption extends StatelessWidget {
  /// Creates a new instance of [ToggleClosedCaptionsOption].
  const ToggleClosedCaptionsOption({
    super.key,
    required this.call,
    this.enabledClosedCaptionIcon,
    this.disabledClosedCaptionIcon,
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the closed caption is enabled.
  ///
  /// Defaults to `context.streamIcons.captionFill`.
  final IconData? enabledClosedCaptionIcon;

  /// The icon that is shown when the closed caption is disabled.
  ///
  /// Defaults to `context.streamIcons.captionFill`.
  final IconData? disabledClosedCaptionIcon;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return PartialCallStateBuilder<bool>(
      call: call,
      selector: (state) => state.isCaptioning,
      builder: (_, enabled) => CallFeatureButton(
        // The design system has one caption glyph: whether captions are on is
        // carried by the selected state, not by a second icon.
        icon: Icon(
          enabled
              ? enabledClosedCaptionIcon ?? icons.captionFill
              : disabledClosedCaptionIcon ?? icons.captionFill,
        ),
        selected: enabled,
        onPressed: () {
          if (!enabled) {
            call.startClosedCaptions();
          } else {
            call.stopClosedCaptions();
          }
        },
      ),
    );
  }
}
