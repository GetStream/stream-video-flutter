import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'audio_level_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    if (isAudioEnabled && isSpeaking) {
      return StreamAudioLevelIndicator(
        color: audioLevelIndicatorColor,
      );
    } else if (isAudioEnabled && !isSpeaking) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.mic,
          size: 16,
          color: enabledMicrophoneColor ?? theme.enabledMicrophoneColor,
        ),
      );
    } else {
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
}
