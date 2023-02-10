import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../utils/device_segmentation.dart';
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
  final CallV2 call;

  /// The participant to display.
  final CallParticipantStateV2 participant;

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
          border: participant.isSpeaking
              ? Border.all(
                  width: 4,
                  color: theme.focusedColor,
                )
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(isDesktopDevice ? 12 : 0),
          ),
        ),
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: Stack(
          children: [
            VideoTrackRenderer(
              call: call,
              participant: participant,
              placeholderBuilder: (context) {
                return Center(
                  child: StreamUserAvatar(
                    avatarTheme: theme.avatarTheme,
                    user: UserInfo(
                      id: participant.userId,
                      role: participant.role,
                      name: participant.userId,
                      imageUrl: participant.profileImageURL,
                    ),
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
                    child: StreamParticipantLabel(
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
