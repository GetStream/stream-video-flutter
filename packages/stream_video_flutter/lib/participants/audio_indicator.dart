import 'package:flutter/material.dart';
import 'package:stream_video_flutter/participants/audio_level_indicator.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Widget used to indicate the audio state of a given participant.
/// Either shows a mute icon or audio levels.
class StreamAudioIndicator extends StatelessWidget {
  const StreamAudioIndicator({
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
      return StreamAudioLevelIndicator(
        audioLevel: audioLevel,
        activeColor: audioLevelActiveColor,
        inactiveColor: audioLevelInactiveColor,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.mic_off,
          size: 16.0,
          color: disabledMicrophoneColor ?? theme.disabledMicrophoneColor,
        ),
      );
    }
  }
}
