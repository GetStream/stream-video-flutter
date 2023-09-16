import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// A widget that displays the list of participants in the lobby.
class StreamLobbyParticipantsView extends StatelessWidget {
  const StreamLobbyParticipantsView({
    super.key,
    required this.participants,
    this.participantAvatarTheme,
  });

  /// List of participants.
  final List<UserInfo> participants;

  /// Theme for the participant avatar.
  final StreamUserAvatarThemeData? participantAvatarTheme;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;

    final theme = StreamLobbyViewTheme.of(context);
    final participantAvatarTheme =
        this.participantAvatarTheme ?? theme.participantAvatarTheme;

    return SizedBox(
      height: theme.participantListHeight,
      child: ListView.builder(
        itemCount: participants.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          final participant = participants[idx];
          return Row(
            children: [
              if (idx != 0) const SizedBox(width: 16),
              Column(
                children: [
                  StreamUserAvatarTheme(
                    data: participantAvatarTheme,
                    child: StreamUserAvatar(
                      user: participant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    participant.name,
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.textHighEmphasis,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
