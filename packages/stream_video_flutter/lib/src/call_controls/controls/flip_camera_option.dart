// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to flip the active camera.
class FlipCameraOption extends StatelessWidget {
  /// Creates a new instance of [FlipCameraOption].
  const FlipCameraOption({
    super.key,
    required this.call,
    this.localParticipant,
    this.frontCameraIcon = Icons.flip_camera_ios_rounded,
    this.backCameraIcon = Icons.flip_camera_ios_rounded,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the front camera is active.
  final IconData frontCameraIcon;

  /// The icon that is shown when the back icon is active.
  final IconData backCameraIcon;

  @override
  Widget build(BuildContext context) {
    Widget buildContent(TrackState? trackState) {
      CameraPosition? position;
      if (trackState is LocalTrackState) {
        position = trackState.cameraPosition;
      }

      return CallControlOption(
        icon: position == CameraPosition.front
            ? Icon(frontCameraIcon)
            : Icon(backCameraIcon),
        onPressed: trackState?.muted == false //
            ? call.flipCamera
            : () {},
      );
    }

    if (localParticipant != null) {
      return buildContent(localParticipant!.videoTrack);
    }
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant?.videoTrack,
      builder: (_, trackState) => buildContent(trackState),
    );
  }
}
