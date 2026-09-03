import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../apply_device_change.dart';

/// A widget that represents a call control option to toggle if the microphone
/// is on or off.
class ToggleMicrophoneOption extends StatelessWidget {
  /// Creates a new instance of [ToggleMicrophoneOption].
  const ToggleMicrophoneOption({
    super.key,
    required this.call,
    this.localParticipant,
    this.enabledMicrophoneIcon,
    this.disabledMicrophoneIcon,
    this.onError,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the microphone is enabled.
  ///
  /// Defaults to `context.streamIcons.voiceFill`.
  final IconData? enabledMicrophoneIcon;

  /// The icon that is shown when the microphone is disabled.
  ///
  /// Defaults to `context.streamIcons.voiceOffFill`.
  final IconData? disabledMicrophoneIcon;

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
    final icons = context.streamIcons;

    Widget buildContent(bool enabled) {
      return CallControlButton(
        icon: Icon(
          enabled
              ? enabledMicrophoneIcon ?? icons.voiceFill
              : disabledMicrophoneIcon ?? icons.voiceOffFill,
        ),
        tone: enabled ? .neutral : .negative,
        onPressed: () => applyDeviceChange(
          call.setMicrophoneEnabled(enabled: !enabled),
          description: 'turn the microphone ${enabled ? 'off' : 'on'}',
          onError: onError,
        ),
      );
    }

    if (localParticipant != null) {
      return buildContent(localParticipant!.isAudioEnabled);
    }
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant?.isAudioEnabled ?? false,
      builder: (_, enabled) => buildContent(enabled),
    );
  }
}
