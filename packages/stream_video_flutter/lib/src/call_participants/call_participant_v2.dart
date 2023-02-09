import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/src/call_participants/participant_label.dart';

import '../../stream_video_flutter.dart';
import '../utils/device_segmentation.dart';
import 'indicators/connection_quality_indicator.dart';

class CallParticipantV2 extends StatelessWidget {
  const CallParticipantV2({
    super.key,
    required this.call,
    required this.participant,
    this.theme,
  });

  final CallV2 call;

  /// The participant to display.
  final CallParticipantStateV2? participant;

  /// Theme for the call participant.
  final StreamCallParticipantTheme? theme;

  @override
  Widget build(BuildContext context) {
    final participant = this.participant;
    print('(D/SV:ParticipantView) [build] participant: $participant');

    if (participant == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('Mock Participant'),
      );
    }

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
            // TODO: videoFit: VideoFit.cover
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
                    padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(8.0),
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
