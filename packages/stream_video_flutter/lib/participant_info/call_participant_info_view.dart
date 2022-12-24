import 'package:flutter/material.dart';
import 'package:stream_video_flutter/icon/icon_toggle.dart';
import 'package:stream_video_flutter/participant_info/model/call_participant_state.dart';
import 'package:stream_video_flutter/participant_info/theme/call_participant_info_theme.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StreamCallParticipantInfoView extends StatelessWidget {
  const StreamCallParticipantInfoView({
    super.key,
    required this.participant,
    required this.videoIcon,
    required this.audioIcon,
    this.participantInfoTheme,
  });

  final CallParticipantState participant;
  final StreamIconToggle videoIcon;
  final StreamIconToggle audioIcon;

  /// Theme for the participants info.
  final StreamParticipantInfoTheme? participantInfoTheme;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final participantInfoTheme = this.participantInfoTheme ??
        streamChatTheme.participantsInfoTheme.participantInfoTheme;
    final avatarTheme =
        participantInfoTheme.avatarTheme ?? streamChatTheme.avatarTheme;
    return InkWell(
      onTap: () {},
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
            )
          ],
        ),
      ),
    );
  }
}

class _MediaIcon extends StatelessWidget {
  const _MediaIcon({super.key, required this.icon, required this.color});
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
