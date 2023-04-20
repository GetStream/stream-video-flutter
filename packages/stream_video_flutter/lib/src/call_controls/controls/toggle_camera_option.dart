import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if the camera
/// is on or off.
class ToggleCameraOption extends StatelessWidget {
  /// Creates a new instance of [ToggleCameraOption].
  const ToggleCameraOption({
    super.key,
    required this.call,
    required this.localParticipant,
    this.enabledCameraIcon = Icons.videocam_rounded,
    this.disabledCameraIcon = Icons.videocam_off_rounded,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The icon that is shown when the camera is enabled.
  final IconData enabledCameraIcon;

  /// The icon that is shown when the camera is disabled.
  final IconData disabledCameraIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = localParticipant.isVideoEnabled;

    return CallControlOption(
      icon: enabled ? Icon(enabledCameraIcon) : Icon(disabledCameraIcon),
      onPressed: () {
        call.setCameraEnabled(enabled: !enabled);
      },
    );
  }
}
