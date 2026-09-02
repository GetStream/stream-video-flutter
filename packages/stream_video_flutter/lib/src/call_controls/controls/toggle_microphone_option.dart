import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

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
        onPressed: () {
          call.setMicrophoneEnabled(enabled: !enabled);
        },
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
