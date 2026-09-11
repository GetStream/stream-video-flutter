import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A call control that turns the camera on and off.
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

  /// The local participant to read, instead of watching [call] for it.
  ///
  /// Must be [call]'s own local participant: one from another call would draw
  /// that call's state onto this control.
  final CallParticipantState? localParticipant;

  /// The devices the platform reports, used to mark a missing camera.
  ///
  /// Given one — the same controller the screen's other pickers read — the
  /// button badges itself and stops responding while the platform names no
  /// camera. Left out, nothing listens for devices and the button claims
  /// nothing about them. Note that [StreamCameraSplitButton] always
  /// enumerates, building a controller for the call when none is passed.
  ///
  /// Pass the screen's own controller to be able to read
  /// [StreamMediaDevicesController.enumerationError] or offer
  /// [StreamMediaDevicesController.refreshDevices] as a retry.
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
  final StreamDeviceErrorCallback? onError;

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
