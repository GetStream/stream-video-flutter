// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if the camera
/// is on or off.
class ToggleCameraOption extends StatelessWidget {
  /// Creates a new instance of [ToggleCameraOption].
  const ToggleCameraOption({
    super.key,
    required this.call,
    this.localParticipant,
    this.enabledCameraIcon = Icons.videocam_rounded,
    this.disabledCameraIcon = Icons.videocam_off_rounded,
    this.enabledCameraIconColor,
    this.disabledCameraIconColor,
    this.enabledCameraBackgroundColor,
    this.disabledCameraBackgroundColor,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the camera is enabled.
  final IconData enabledCameraIcon;

  /// The icon that is shown when the camera is disabled.
  final IconData disabledCameraIcon;

  /// Color of the icon when camera is enabled
  final Color? enabledCameraIconColor;

  /// Color of the icon when camera is disabled
  final Color? disabledCameraIconColor;

  /// Color of the background when camera is enabled
  final Color? enabledCameraBackgroundColor;

  /// Color of the background when camera is disabled
  final Color? disabledCameraBackgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget buildContent(bool enabled) {
      return CallControlOption(
        icon: enabled ? Icon(enabledCameraIcon) : Icon(disabledCameraIcon),
        iconColor: enabled ? enabledCameraIconColor : disabledCameraIconColor,
        backgroundColor: enabled
            ? enabledCameraBackgroundColor
            : disabledCameraBackgroundColor,
        onPressed: () {
          call.setCameraEnabled(enabled: !enabled);
        },
      );
    }

    if (localParticipant != null) {
      return buildContent(localParticipant!.isVideoEnabled);
    }
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant?.isVideoEnabled ?? false,
      builder: (_, enabled) => buildContent(enabled),
    );
  }
}
