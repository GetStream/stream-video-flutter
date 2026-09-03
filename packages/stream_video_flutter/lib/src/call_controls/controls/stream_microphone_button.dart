import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../device_control.dart';

/// A widget that represents a call control option to toggle if the microphone
/// is on or off.
class StreamMicrophoneButton extends StatelessWidget {
  /// Creates a new instance of [StreamMicrophoneButton].
  const StreamMicrophoneButton({
    super.key,
    required this.call,
    this.localParticipant,
    this.devices,
    this.enabledMicrophoneIcon,
    this.disabledMicrophoneIcon,
    this.stopTrackOnMute,
    this.onError,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The devices the platform reports, used to mark a missing microphone.
  ///
  /// Optional, and no controller is built when it is left out: a plain toggle
  /// needs none, and enumerating devices just to draw one is a cost a call
  /// screen should opt into rather than pay by default. Given one — the same
  /// controller the screen's other pickers read — the button badges itself and
  /// stops responding while the platform names no microphone, the way
  /// [StreamMicrophoneSplitButton] does.
  final StreamMediaDevicesController? devices;

  /// The icon that is shown when the microphone is enabled.
  ///
  /// Defaults to `context.streamIcons.voiceFill`.
  final IconData? enabledMicrophoneIcon;

  /// The icon that is shown when the microphone is disabled.
  ///
  /// Defaults to `context.streamIcons.voiceOffFill`.
  final IconData? disabledMicrophoneIcon;

  /// Whether muting stops and releases the audio track, or keeps it and
  /// sends silence.
  ///
  /// Null leaves the call's own default, which stops the track. Pass false to
  /// keep it alive, which is what speaking-while-muted detection needs on iOS
  /// and macOS.
  final bool? stopTrackOnMute;

  /// Called when the call refuses to turn the microphone on or off.
  ///
  /// The button draws the call's own participant state, and that does not
  /// change on a refusal — so a viewer without `sendAudio` presses this and
  /// nothing moves. A refusal is always logged; pass this to say so on screen
  /// as well.
  ///
  /// The error is an `Object` rather than the `VideoError` behind it, matching
  /// [StreamMediaDevicesController.enumerationError].
  final ValueChanged<Object>? onError;

  @override
  Widget build(BuildContext context) {
    if (devices case final devices?) {
      // Whether the platform has a microphone at all arrives on the device
      // stream, not in call state.
      return ListenableBuilder(
        listenable: devices,
        builder: (context, _) => _withState(
          context,
          unavailable: devices.reportsNo(devices.audioInputs),
        ),
      );
    }

    // Given no devices there is nothing to ask, so nothing is claimed.
    return _withState(context, unavailable: false);
  }

  // Nothing has reported the track yet: draw the state the call was joined
  // with, since that is where it is about to be.
  bool _resolve(bool? reported) =>
      reported ?? call.connectOptions.microphone.wantsOn;

  Widget _withState(BuildContext context, {required bool unavailable}) {
    if (localParticipant case final participant?) {
      return _button(
        context,
        enabled: _resolve(participant.trackEnabled(SfuTrackType.audio)),
        unavailable: unavailable,
      );
    }

    return PartialCallStateBuilder<bool?>(
      call: call,
      selector: (state) =>
          state.localParticipant?.trackEnabled(SfuTrackType.audio),
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
            ? enabledMicrophoneIcon ?? icons.voiceFill
            : disabledMicrophoneIcon ?? icons.voiceOffFill,
      ),
      // An absent device is not a user choice, so it is badged rather than
      // drawn as a deliberate mute.
      tone: enabled || unavailable ? .neutral : .negative,
      showErrorBadge: unavailable,
      onPressed: unavailable
          ? null
          : () => applyDeviceChange(
              call.setMicrophoneEnabled(
                enabled: !enabled,
                stopTrackOnMute: stopTrackOnMute,
              ),
              description: 'turn the microphone ${enabled ? 'off' : 'on'}',
              onError: onError,
            ),
    );
  }
}

/// ToggleMicrophoneOption is [StreamMicrophoneButton] now.
@Deprecated(
  'ToggleMicrophoneOption is StreamMicrophoneButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleMicrophoneOption = StreamMicrophoneButton;
