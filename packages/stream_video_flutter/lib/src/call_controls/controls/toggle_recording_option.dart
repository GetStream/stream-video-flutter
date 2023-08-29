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
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the recording is enabled.
  final IconData enabledRecordingIcon;

  /// The icon that is shown when the recording is disabled.
  final IconData disabledRecordingIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = call.state.value.isRecording;

    return CallControlOption(
      icon: enabled ? Icon(enabledRecordingIcon) : Icon(disabledRecordingIcon),
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
