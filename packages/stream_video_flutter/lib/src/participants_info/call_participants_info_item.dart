import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// Displays call participant info view.
class CallParticipantsInfoItem extends StatelessWidget {
  /// Creates a new instance of [CallParticipantsInfoItem].
  const CallParticipantsInfoItem({
    super.key,
    required this.participant,
    required this.videoIcon,
    required this.audioIcon,
    this.onParticipantTap,
    this.participantNameTextStyle,
    this.participantIconActiveColor,
    this.participantIconInactiveColor,
    this.participantUserAvatarTheme,
  });

  /// Represents current participant state.
  final CallParticipantState participant;

  /// Active/Inactive icons for the video button.
  final StreamIconToggle videoIcon;

  /// Active/Inactive icons for the audio button.
  final StreamIconToggle audioIcon;

  /// The action to perform when a participant is tapped.
  final ValueChanged<CallParticipantState>? onParticipantTap;

  /// [TextStyle] for the user name.
  final TextStyle? participantNameTextStyle;

  /// Color of the active icon.
  final Color? participantIconActiveColor;

  /// Color of the inactive icon.
  final Color? participantIconInactiveColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? participantUserAvatarTheme;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantsInfoMenuTheme.of(context);
    final participantNameTextStyle =
        this.participantNameTextStyle ?? theme.participantNameTextStyle;
    final participantIconActiveColor =
        this.participantIconActiveColor ?? theme.participantIconActiveColor;
    final participantIconInactiveColor =
        this.participantIconInactiveColor ?? theme.participantIconInactiveColor;
    final participantUserAvatarTheme =
        this.participantUserAvatarTheme ?? theme.participantUserAvatarTheme;

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
            StreamUserAvatarTheme(
              data: participantUserAvatarTheme,
              child: StreamUserAvatar(
                user: participant.toUserInfo(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  participant.name,
                  style: participantNameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _MediaIcon(
              icon: isVideoEnabled ? videoIcon.active : videoIcon.inactive,
              color: isVideoEnabled
                  ? participantIconActiveColor
                  : participantIconInactiveColor,
            ),
            _MediaIcon(
              icon: isAudioEnabled ? audioIcon.active : audioIcon.inactive,
              color: isAudioEnabled
                  ? participantIconActiveColor
                  : participantIconInactiveColor,
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
