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
  final CallV2 call;

  /// The current local participant.
  final CallParticipantStateV2 localParticipant;

  /// The icon that is shown when the front camera is active.
  final IconData frontCameraIcon;

  /// The icon that is shown when the back icon is active.
  final IconData backCameraIcon;

  @override
  Widget build(BuildContext context) {
    CameraPositionV2? position;
    final trackState = localParticipant.videoTrack;
    if (trackState is LocalTrackState) {
      position = trackState.cameraPosition;
    }

    return CallControlOption(
      icon: position == CameraPositionV2.front
          ? Icon(frontCameraIcon)
          : Icon(backCameraIcon),
      onPressed: position != null
          ? () {
              final newPosition = position == CameraPositionV2.front
                  ? CameraPositionV2.back
                  : CameraPositionV2.front;

              call.apply(SetCameraPosition(cameraPosition: newPosition));
            }
          : null,
    );
  }
}
