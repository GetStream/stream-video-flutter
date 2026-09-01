import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if recording
/// is on or off.
class ToggleRecordingOption extends StatelessWidget {
  /// Creates a new instance of [ToggleRecordingOption].
  const ToggleRecordingOption({
    super.key,
    required this.call,
    this.enabledRecordingIcon,
    this.disabledRecordingIcon,
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the recording is enabled.
  ///
  /// Defaults to `context.streamIcons.recordingStopFill`.
  final IconData? enabledRecordingIcon;

  /// The icon that is shown when the recording is disabled.
  ///
  /// Defaults to `context.streamIcons.recordingFill`.
  final IconData? disabledRecordingIcon;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return PartialCallStateBuilder<bool>(
      call: call,
      selector: (state) => state.isRecording,
      builder: (_, enabled) => CallFeatureButton(
        icon: Icon(
          enabled
              ? enabledRecordingIcon ?? icons.recordingStopFill
              : disabledRecordingIcon ?? icons.recordingFill,
        ),
        selected: enabled,
        onPressed: () {
          if (!enabled) {
            call.startRecording();
          } else {
            call.stopRecording();
          }
        },
      ),
    );
  }
}
