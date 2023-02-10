import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// Displays call participant info view.
class CallParticipantInfoView extends StatelessWidget {
  /// Creates a new instance of [CallParticipantInfoView].
  const CallParticipantInfoView({
    super.key,
    required this.participant,
    required this.videoIcon,
    required this.audioIcon,
    this.participantInfoTheme,
    this.onParticipantTap,
  });

  /// Represents current participant state.
  final CallParticipantStateV2 participant;

  /// Active/Inactive icons for the video button.
  final StreamIconToggle videoIcon;

  /// Active/Inactive icons for the audio button.
  final StreamIconToggle audioIcon;

  /// Theme for the participants info.
  final StreamParticipantInfoTheme? participantInfoTheme;

  /// The action to perform when a participant is tapped.
  final ValueChanged<CallParticipantStateV2>? onParticipantTap;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final participantInfoTheme =
        this.participantInfoTheme ?? streamChatTheme.participantInfoTheme;
    final avatarTheme =
        participantInfoTheme.avatarTheme ?? streamChatTheme.avatarTheme;

    final isAudioEnabled = participant.isAudioEnabled;
    final isVideoEnabled = participant.isVideoEnabled;

    return InkWell(
      onTap: () {
        onParticipantTap?.call(participant);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreamUserAvatar(
              user: participant.toUserInfo(),
              avatarTheme: avatarTheme,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  participant.name,
                  style: participantInfoTheme.usernameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _MediaIcon(
              icon: isVideoEnabled ? videoIcon.active : videoIcon.inactive,
              color: isVideoEnabled
                  ? participantInfoTheme.iconActiveColor
                  : participantInfoTheme.iconInactiveColor,
            ),
            _MediaIcon(
              icon: isAudioEnabled ? audioIcon.active : audioIcon.inactive,
              color: isAudioEnabled
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
  const _MediaIcon({
    required this.icon,
    required this.color,
  });

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
