import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../call_controls.dart';

class SwitchCamera extends StatelessWidget {
  const SwitchCamera({
    super.key,
    required this.participant,
    this.icon = Icons.flip_camera_ios_rounded,
    this.alternateIcon = Icons.flip_camera_ios_rounded,
  });

  final IconData icon;
  final IconData alternateIcon;
  final LocalParticipant participant;

  @override
  Widget build(BuildContext context) {
    final position = this.position;
    return CallControlOption(
      icon: position == CameraPosition.front ? Icon(icon) : Icon(alternateIcon),
      onPressed: position != null
          ? () async {
              try {
                // Switch the camera.
                final track = participant.videoTrack!.track!;
                await track.setCameraPosition(position.switched());
              } catch (_) {}
            }
          : null,
    );
  }

  CameraPosition? get position {
    // Can't switch the camera if the video is not enabled.
    if (!participant.isVideoEnabled) return null;
    final videoTrack = participant.videoTrack?.track;
    final options = videoTrack?.currentOptions;
    // If the options are null, then the camera is not enabled.
    if (options is! CameraCaptureOptions) return null;

    return options.cameraPosition;
  }
}
