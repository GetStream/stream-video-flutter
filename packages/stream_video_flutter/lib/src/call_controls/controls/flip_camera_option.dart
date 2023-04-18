import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../call_control_option.dart';

/// A widget that represents a call control option to flip the active camera.
class FlipCameraOption extends StatelessWidget {
  /// Creates a new instance of [FlipCameraOption].
  const FlipCameraOption({
    super.key,
    required this.call,
    required this.localParticipant,
    this.frontCameraIcon = Icons.flip_camera_ios_rounded,
    this.backCameraIcon = Icons.flip_camera_ios_rounded,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The icon that is shown when the front camera is active.
  final IconData frontCameraIcon;

  /// The icon that is shown when the back icon is active.
  final IconData backCameraIcon;

  @override
  Widget build(BuildContext context) {
    CameraPosition? position;
    final trackState = localParticipant.videoTrack;
    if (trackState is LocalTrackState) {
      position = trackState.cameraPosition;
    }

    return CallControlOption(
      icon: position == CameraPosition.front
          ? Icon(frontCameraIcon)
          : Icon(backCameraIcon),
      onPressed: trackState?.muted == false //
          ? call.flipCamera
          : null,
    );
  }
}
