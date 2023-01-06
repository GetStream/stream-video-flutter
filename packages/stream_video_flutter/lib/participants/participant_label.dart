import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participants/audio_indicator.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';

/// Widget used to display participant name and mute status on a call.
class StreamParticipantLabel extends StatelessWidget {
  const StreamParticipantLabel({
    required this.participant,
    this.audioLevelActiveColor,
    this.audioLevelInactiveColor,
    this.participantLabelTextStyle,
    this.disabledMicrophoneColor,
    Key? key,
  }) : super(key: key);

  /// The participant to display.
  final Participant participant;

  /// The color of an active audio level.
  final Color? audioLevelActiveColor;

  /// The color of an inactive audio level.
  final Color? audioLevelInactiveColor;

  /// Text style for the participant label.
  final TextStyle? participantLabelTextStyle;

  /// The color of disabled microphone icon.
  final Color? disabledMicrophoneColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8.0),
          Text(
            participant.userId,
            style: participantLabelTextStyle ?? theme.participantLabelTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 4.0),
          StreamAudioIndicator(
            hasAudio: participant.isAudioEnabled,
            audioLevel: participant.audioLevel,
            audioLevelActiveColor: audioLevelActiveColor,
            audioLevelInactiveColor: audioLevelInactiveColor,
            disabledMicrophoneColor: disabledMicrophoneColor,
          ),
          const SizedBox(width: 2.0),
        ],
      ),
    );
  }
}
