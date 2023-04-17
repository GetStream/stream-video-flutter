import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Widget used to indicate the audio state of a given participant.
/// Either shows a mute icon or audio levels.
class StreamAudioIndicator extends StatelessWidget {
  /// Creates a new instance of [StreamAudioIndicator].
  const StreamAudioIndicator({
    super.key,
    required this.isAudioEnabled,
    required this.isSpeaking,
    this.audioLevelIndicatorColor,
    this.enabledMicrophoneColor,
    this.disabledMicrophoneColor,
    this.size,
  });

  /// If the participant has microphone enabled.
  final bool isAudioEnabled;

  /// If the participant is speaking.
  final bool isSpeaking;

  /// The color of an audio level indicator.
  final Color? audioLevelIndicatorColor;

  /// The color of an enabled microphone icon.
  final Color? enabledMicrophoneColor;

  /// The color of a disabled microphone icon.
  final Color? disabledMicrophoneColor;

  /// The size of the audio indicator.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);

    if (isAudioEnabled && isSpeaking) {
      return StreamAudioLevelIndicator(
        size: 16,
        color: audioLevelIndicatorColor,
      );
    }

    if (isAudioEnabled && !isSpeaking) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.mic,
          size: 16,
          color: enabledMicrophoneColor ?? theme.enabledMicrophoneColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Icon(
        Icons.mic_off,
        size: 16,
        color: disabledMicrophoneColor ?? theme.disabledMicrophoneColor,
      ),
    );
  }
}
