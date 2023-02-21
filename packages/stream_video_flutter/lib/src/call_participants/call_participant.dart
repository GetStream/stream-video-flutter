import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';
import 'indicators/connection_quality_indicator.dart';
import 'participant_label.dart';

/// A widget that represents a single participant in a call.
class StreamCallParticipant extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  const StreamCallParticipant({
    super.key,
    required this.call,
    required this.participant,
    this.theme,
  });

  /// Represents a call.
  final Call call;

  /// The participant to display.
  final CallParticipantState participant;

  /// Theme for the participant.
  final StreamCallParticipantTheme? theme;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final theme = this.theme ?? streamVideoTheme.callParticipantTheme;

    return ClipRRect(
      borderRadius: theme.borderRadius,
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: participant.isDominantSpeaker && theme.showFocusedBorder
              ? Border.all(
                  width: theme.focusedBorderThickness,
                  color: theme.focusedBorderColor,
                )
              : null,
          borderRadius: theme.borderRadius,
        ),
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: Stack(
          children: [
            VideoTrackRenderer(
              call: call,
              participant: participant,
              videoTrackType: SfuTrackType.video,
              placeholderBuilder: (context) {
                return Center(
                  child: StreamUserAvatar(
                    avatarTheme: theme.avatarTheme,
                    user: participant.toUserInfo(),
                  ),
                );
              },
            ),
            Align(
              alignment: theme.participantLabelAlignment,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: StreamParticipantLabel.fromParticipant(
                      participant: participant,
                      audioLevelIndicatorColor: theme.audioLevelIndicatorColor,
                      disabledMicrophoneColor: theme.disabledMicrophoneColor,
                      enabledMicrophoneColor: theme.enabledMicrophoneColor,
                      participantLabelTextStyle:
                          theme.participantLabelTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: theme.connectionLevelAlignment,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamConnectionQualityIndicator(
                  connectionQuality: participant.connectionQuality,
                  activeColor: theme.connectionLevelActiveColor,
                  inactiveColor: theme.connectionLevelInactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
