import 'package:flutter/material.dart';
import 'package:stream_video_flutter/participant/audio_levels.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Widget used to indicate the audio state of a given participant.
/// Either shows a mute icon or audio levels.
class AudioIndicator extends StatelessWidget {
  const AudioIndicator({
    super.key,
    required this.hasAudio,
    required this.audioLevel,
    this.audioLevelActiveColor,
    this.audioLevelInactiveColor,
    this.disabledMicrophoneColor,
  });

  /// If the participant has audio active.
  final bool hasAudio;

  /// The level of audio of the participant.
  final double audioLevel;

  /// The color of an active audio level.
  final Color? audioLevelActiveColor;

  /// The color of an inactive audio level.
  final Color? audioLevelInactiveColor;

  /// The color of disabled microphone icon.
  final Color? disabledMicrophoneColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    if (hasAudio) {
      return AudioLevels(
        audioLevel: audioLevel,
        audioLevelActiveColor: audioLevelActiveColor,
        audioLevelInactiveColor: audioLevelInactiveColor,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.mic_off,
          color: disabledMicrophoneColor ?? theme.disabledMicrophoneColor,
          size: 16,
        ),
      );
    }
  }
}
