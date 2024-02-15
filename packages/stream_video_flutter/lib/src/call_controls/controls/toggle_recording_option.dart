import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if recording
/// is on or off.
class ToggleRecordingOption extends StatelessWidget {
  /// Creates a new instance of [ToggleRecordingOption].
  const ToggleRecordingOption({
    super.key,
    required this.call,
    this.enabledRecordingIcon = Icons.video_file_outlined,
    this.disabledRecordingIcon = Icons.video_file_rounded,
    this.enabledRecordingIconColor,
    this.disabledRecordingIconColor,
    this.enabledRecordingBackgroundColor,
    this.disabledRecordingBackgroundColor,
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the recording is enabled.
  final IconData enabledRecordingIcon;

  /// The icon that is shown when the recording is disabled.
  final IconData disabledRecordingIcon;

  /// Color of the icon when recording is enabled
  final Color? enabledRecordingIconColor;

  /// Color of the icon when recording is disabled
  final Color? disabledRecordingIconColor;

  /// Color of the background when recording is enabled
  final Color? enabledRecordingBackgroundColor;

  /// Color of the background when recording is disabled
  final Color? disabledRecordingBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final enabled = call.state.value.isRecording;

    return CallControlOption(
      icon: enabled ? Icon(enabledRecordingIcon) : Icon(disabledRecordingIcon),
      iconColor:
          enabled ? enabledRecordingIconColor : disabledRecordingIconColor,
      backgroundColor: enabled
          ? enabledRecordingBackgroundColor
          : disabledRecordingBackgroundColor,
      onPressed: () {
        if (!enabled) {
          call.startRecording();
        } else {
          call.stopRecording();
        }
      },
    );
  }
}
