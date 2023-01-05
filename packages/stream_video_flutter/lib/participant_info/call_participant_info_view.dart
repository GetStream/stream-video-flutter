import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// {@template streamCallParticipantInfoView}
/// Displays call participant info view.
/// {@endtemplate}
class StreamCallParticipantInfoView extends StatelessWidget {
  /// {@macro streamCallParticipantInfoView}
  const StreamCallParticipantInfoView({
    super.key,
    required this.participant,
    required this.videoIcon,
    required this.audioIcon,
    this.participantInfoTheme,
    this.onParticipantTap,
  });

  /// Represents current participant state.
  final CallParticipantState participant;

  /// Active/Inactive icons for the video button.
  final StreamIconToggle videoIcon;

  /// Active/Inactive icons for the audio button.
  final StreamIconToggle audioIcon;

  /// Theme for the participants info.
  final StreamParticipantInfoTheme? participantInfoTheme;

  /// The action to perform when a participant is tapped.
  final ValueChanged<CallParticipantState>? onParticipantTap;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final participantInfoTheme =
        this.participantInfoTheme ?? streamChatTheme.participantInfoTheme;
    final avatarTheme =
        participantInfoTheme.avatarTheme ?? streamChatTheme.avatarTheme;

    return InkWell(
      onTap: () {
        onParticipantTap?.call(participant);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamUserAvatar(
              user: participant.user,
              avatarTheme: avatarTheme,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  participant.user.name,
                  style: participantInfoTheme.usernameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _MediaIcon(
              icon: participant.videoAvailable
                  ? videoIcon.active
                  : videoIcon.inactive,
              color: participant.videoAvailable
                  ? participantInfoTheme.iconActiveColor
                  : participantInfoTheme.iconInactiveColor,
            ),
            _MediaIcon(
              icon: participant.audioAvailable
                  ? audioIcon.active
                  : audioIcon.inactive,
              color: participant.audioAvailable
                  ? participantInfoTheme.iconActiveColor
                  : participantInfoTheme.iconInactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaIcon extends StatelessWidget {
  const _MediaIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }
}
