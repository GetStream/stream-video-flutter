// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to toggle if the microphone
/// is on or off.
class ToggleMicrophoneOption extends StatelessWidget {
  /// Creates a new instance of [ToggleMicrophoneOption].
  const ToggleMicrophoneOption({
    super.key,
    required this.call,
    @Deprecated('Should not be used anymore.') this.localParticipant,
    this.enabledMicrophoneIcon = Icons.mic_rounded,
    this.disabledMicrophoneIcon = Icons.mic_off_rounded,
    this.enabledMicrophoneIconColor,
    this.disabledMicrophoneIconColor,
    this.enabledMicrophoneBackgroundColor,
    this.disabledMicrophoneBackgroundColor,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  @Deprecated('Should not be used anymore.')
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the microphone is enabled.
  final IconData enabledMicrophoneIcon;

  /// The icon that is shown when the microphone is disabled.
  final IconData disabledMicrophoneIcon;

  /// Color of the icon when microphone is enabled
  final Color? enabledMicrophoneIconColor;

  /// Color of the icon when microphone is disabled
  final Color? disabledMicrophoneIconColor;

  /// Color of the background when microphone is enabled
  final Color? enabledMicrophoneBackgroundColor;

  /// Color of the background when microphone is disabled
  final Color? disabledMicrophoneBackgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget builder(bool enabled) {
      return CallControlOption(
        icon: enabled
            ? Icon(enabledMicrophoneIcon)
            : Icon(disabledMicrophoneIcon),
        iconColor:
            enabled ? enabledMicrophoneIconColor : disabledMicrophoneIconColor,
        backgroundColor: enabled
            ? enabledMicrophoneBackgroundColor
            : disabledMicrophoneBackgroundColor,
        onPressed: () {
          call.setMicrophoneEnabled(enabled: !enabled);
        },
      );
    }

    if (localParticipant != null) {
      return builder(localParticipant!.isAudioEnabled);
    }
    return CallStreamBuilder(
      call: call,
      selector: (state) => state.localParticipant?.isAudioEnabled ?? false,
      builder: (_, enabled) => builder(enabled),
    );
  }
}
