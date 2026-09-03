import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../device_control.dart';

/// A widget that represents a call control option to toggle if the camera
/// is on or off.
class StreamCameraButton extends StatelessWidget {
  /// Creates a new instance of [StreamCameraButton].
  const StreamCameraButton({
    super.key,
    required this.call,
    this.localParticipant,
    this.devices,
    this.enabledCameraIcon,
    this.disabledCameraIcon,
    this.onError,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The devices the platform reports, used to mark a missing camera.
  ///
  /// Optional, and no controller is built when it is left out: a plain toggle
  /// needs none, and enumerating devices just to draw one is a cost a call
  /// screen should opt into rather than pay by default. Given one — the same
  /// controller the screen's other pickers read — the button badges itself and
  /// stops responding while the platform names no camera, the way
  /// [StreamCameraSplitButton] does.
  final StreamMediaDevicesController? devices;

  /// The icon that is shown when the camera is enabled.
  ///
  /// Defaults to `context.streamIcons.videoFill`.
  final IconData? enabledCameraIcon;

  /// The icon that is shown when the camera is disabled.
  ///
  /// Defaults to `context.streamIcons.videoOffFill`.
  final IconData? disabledCameraIcon;

  /// Called when the call refuses to turn the camera on or off. See
  /// [StreamMicrophoneButton.onError].
  final ValueChanged<Object>? onError;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    Widget buildContent(bool enabled, {required bool unavailable}) {
      return CallControlButton(
        icon: Icon(
          enabled
              ? enabledCameraIcon ?? icons.videoFill
              : disabledCameraIcon ?? icons.videoOffFill,
        ),
        // See StreamMicrophoneButton: an absent camera is badged, not muted.
        tone: enabled || unavailable ? .neutral : .negative,
        showErrorBadge: unavailable,
        onPressed: unavailable
            ? null
            : () => applyDeviceChange(
                call.setCameraEnabled(enabled: !enabled),
                description: 'turn the camera ${enabled ? 'off' : 'on'}',
                onError: onError,
              ),
      );
    }

    Widget withState({required bool unavailable}) {
      if (localParticipant case final participant?) {
        return buildContent(
          participant.isVideoEnabled,
          unavailable: unavailable,
        );
      }

      return PartialCallStateBuilder<bool>(
        call: call,
        selector: (state) => state.localParticipant?.isVideoEnabled ?? false,
        builder: (_, enabled) =>
            buildContent(enabled, unavailable: unavailable),
      );
    }

    if (devices case final devices?) {
      return ListenableBuilder(
        listenable: devices,
        builder: (context, _) =>
            withState(unavailable: devices.reportsNo(devices.videoInputs)),
      );
    }

    return withState(unavailable: false);
  }
}

/// ToggleCameraOption is [StreamCameraButton] now.
@Deprecated(
  'ToggleCameraOption is StreamCameraButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleCameraOption = StreamCameraButton;
