import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_control_option.dart';

/// A widget that represents a call control option to toggle if the microphone
/// is on or off.
class ToggleMicrophoneOption extends StatelessWidget {
  /// Creates a new instance of [ToggleMicrophoneOption].
  const ToggleMicrophoneOption({
    super.key,
    required this.call,
    required this.localParticipant,
    this.enabledMicrophoneIcon = Icons.mic_rounded,
    this.disabledMicrophoneIcon = Icons.mic_off_rounded,
  });

  /// Represents a call.
  final CallV2 call;

  /// The current local participant.
  final CallParticipantStateV2 localParticipant;

  /// The icon that is shown when the microphone is enabled.
  final IconData enabledMicrophoneIcon;

  /// The icon that is shown when the microphone is disabled.
  final IconData disabledMicrophoneIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = localParticipant.isAudioEnabled;

    return CallControlOption(
      icon:
          enabled ? Icon(enabledMicrophoneIcon) : Icon(disabledMicrophoneIcon),
      onPressed: () {
        call.apply(
          SetMicrophoneEnabled(enabled: !enabled),
        );
      },
    );
  }
}
