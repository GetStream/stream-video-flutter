import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../theme/stream_video_theme.dart';
import 'indicators/audio_indicator.dart';

/// Widget used to display participant name and mute status on a call.
class StreamParticipantLabel extends StatelessWidget {
  /// Creates a new instance of [StreamParticipantLabel].
  const StreamParticipantLabel({
    required this.participantName,
    required this.isAudioEnabled,
    required this.isSpeaking,
    required this.isTrackPaused,
    this.audioLevelIndicatorColor,
    this.enabledMicrophoneColor,
    this.disabledMicrophoneColor,
    this.pausedVideoIndicatorColor,
    this.participantLabelTextStyle,
    super.key,
  });

  StreamParticipantLabel.fromParticipant({
    super.key,
    required CallParticipantState participant,
    this.audioLevelIndicatorColor,
    this.enabledMicrophoneColor,
    this.disabledMicrophoneColor,
    this.pausedVideoIndicatorColor,
    this.participantLabelTextStyle,
  })  : participantName = participant.name,
        isAudioEnabled = participant.isAudioEnabled,
        isSpeaking = participant.isSpeaking,
        isTrackPaused = participant.isTrackPaused(SfuTrackType.video);

  /// The name of the participant.
  final String participantName;

  /// If the participant has microphone enabled.
  final bool isAudioEnabled;

  /// If the participant is speaking.
  final bool isSpeaking;

  /// If the track is paused.
  final bool isTrackPaused;

  /// The color of an audio level indicator.
  final Color? audioLevelIndicatorColor;

  /// The color of an enabled microphone icon.
  final Color? enabledMicrophoneColor;

  /// The color of a disabled microphone icon.
  final Color? disabledMicrophoneColor;

  /// The color of a paused video track icon.
  final Color? pausedVideoIndicatorColor;

  /// Text style for the participant label.
  final TextStyle? participantLabelTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                participantName,
                style: participantLabelTextStyle ??
                    theme.participantLabelTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            StreamAudioIndicator(
              isAudioEnabled: isAudioEnabled,
              isSpeaking: isSpeaking,
              audioLevelIndicatorColor: audioLevelIndicatorColor,
              enabledMicrophoneColor: enabledMicrophoneColor,
              disabledMicrophoneColor: disabledMicrophoneColor,
            ),
            if (isTrackPaused) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.network_check,
                size: 16,
                color: pausedVideoIndicatorColor ??
                    theme.pausedVideoIndicatorColor,
              ),
            ],
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }
}
