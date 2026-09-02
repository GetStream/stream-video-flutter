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
    this.enabledCameraIcon,
    this.disabledCameraIcon,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the camera is enabled.
  ///
  /// Defaults to `context.streamIcons.videoFill`.
  final IconData? enabledCameraIcon;

  /// The icon that is shown when the camera is disabled.
  ///
  /// Defaults to `context.streamIcons.videoOffFill`.
  final IconData? disabledCameraIcon;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    Widget buildContent(bool enabled) {
      return CallControlButton(
        icon: Icon(
          enabled
              ? enabledCameraIcon ?? icons.videoFill
              : disabledCameraIcon ?? icons.videoOffFill,
        ),
        tone: enabled ? .neutral : .negative,
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
