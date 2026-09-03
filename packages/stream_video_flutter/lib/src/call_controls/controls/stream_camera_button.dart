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
    if (devices case final devices?) {
      // Whether the platform has a camera at all arrives on the device
      // stream, not in call state.
      return ListenableBuilder(
        listenable: devices,
        builder: (context, _) => _withState(
          context,
          unavailable: devices.reportsNo(devices.videoInputs),
        ),
      );
    }

    // Given no devices there is nothing to ask, so nothing is claimed.
    return _withState(context, unavailable: false);
  }

  // Nothing has reported the track yet: draw the state the call was joined
  // with, since that is where it is about to be.
  bool _resolve(bool? reported) =>
      reported ?? call.connectOptions.camera.wantsOn;

  Widget _withState(BuildContext context, {required bool unavailable}) {
    if (localParticipant case final participant?) {
      return _button(
        context,
        enabled: _resolve(participant.trackEnabled(SfuTrackType.video)),
        unavailable: unavailable,
      );
    }

    return PartialCallStateBuilder<bool?>(
      call: call,
      selector: (state) =>
          state.localParticipant?.trackEnabled(SfuTrackType.video),
      builder: (context, reported) => _button(
        context,
        enabled: _resolve(reported),
        unavailable: unavailable,
      ),
    );
  }

  Widget _button(
    BuildContext context, {
    required bool enabled,
    required bool unavailable,
  }) {
    final icons = context.streamIcons;

    return CallControlButton(
      icon: Icon(
        enabled
            ? enabledCameraIcon ?? icons.videoFill
            : disabledCameraIcon ?? icons.videoOffFill,
      ),
      // An absent device is not a user choice, so it is badged rather than
      // drawn as a deliberate mute.
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
}

/// ToggleCameraOption is [StreamCameraButton] now.
@Deprecated(
  'ToggleCameraOption is StreamCameraButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleCameraOption = StreamCameraButton;
