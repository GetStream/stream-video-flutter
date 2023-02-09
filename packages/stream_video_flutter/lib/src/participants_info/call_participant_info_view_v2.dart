import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// {@template streamCallParticipantInfoView}
/// Displays call participant info view.
/// {@endtemplate}
class CallParticipantInfoViewV2 extends StatelessWidget {
  /// {@macro streamCallParticipantInfoView}
  const CallParticipantInfoViewV2({
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

    final user = UserInfo(
      id: participant.userId,
      role: participant.role,
      name: participant.userId,
      imageUrl: participant.profileImageURL,
    );

    final trackState = participant.publishedTracks[SfuTrackType.audio];
    final audioAvailable = trackState != null && !trackState.muted;

    final trackState2 = participant.publishedTracks[SfuTrackType.video];
    final videoAvailable = trackState2 != null && !trackState2.muted;

    return InkWell(
      onTap: () {
        onParticipantTap?.call(participant);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreamUserAvatar(
              user: user,
              avatarTheme: avatarTheme,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  participant.name,
                  style: participantInfoTheme.usernameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _MediaIcon(
              icon: videoAvailable ? videoIcon.active : videoIcon.inactive,
              color: videoAvailable
                  ? participantInfoTheme.iconActiveColor
                  : participantInfoTheme.iconInactiveColor,
            ),
            _MediaIcon(
              icon: audioAvailable ? audioIcon.active : audioIcon.inactive,
              color: audioAvailable
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
