import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../call_controls.dart';

class SwitchCamera extends StatelessWidget {
  const SwitchCamera({
    super.key,
    required this.call,
    required this.localParticipant,
    this.icon = Icons.flip_camera_ios_rounded,
    this.alternateIcon = Icons.flip_camera_ios_rounded,
  });

  final IconData icon;
  final IconData alternateIcon;
  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final position = getCurrentCameraPosition();
    return CallControlOption(
      icon: position == CameraPosition.front ? Icon(icon) : Icon(alternateIcon),
      onPressed: position != null
          ? () {
              final newPosition = position == CameraPositionV2.front
                  ? CameraPositionV2.back
                  : CameraPositionV2.front;

              call.apply(
                SetCameraPosition(cameraPosition: newPosition),
              );
            }
          : null,
    );
  }

  CameraPositionV2? getCurrentCameraPosition() {
    final trackState = localParticipant.publishedTracks[SfuTrackType.video];
    if (trackState is! LocalTrackState) return null;

    return trackState.cameraPosition;
  }

  // CameraPosition? get position {
  //   // Can't switch the camera if the video is not enabled.
  //   if (!participant.isVideoEnabled) return null;
  //   final videoTrack = participant.videoTrack?.track;
  //   final options = videoTrack?.currentOptions;
  //   // If the options are null, then the camera is not enabled.
  //   if (options is! CameraCaptureOptions) return null;
  //
  //   return options.cameraPosition;
  // }
}
