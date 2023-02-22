import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Renders avatars of the participants on the outgoing call and incoming
/// call screens.
class ParticipantAvatars extends StatelessWidget {
  /// Creates a new instance of [ParticipantAvatars].
  const ParticipantAvatars({
    super.key,
    required this.participants,
    this.singleParticipantAvatarTheme = const StreamUserAvatarThemeData(
      initialsTextStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minHeight: 160,
        minWidth: 160,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(80),
      ),
    ),
    this.multipleParticipantAvatarTheme = const StreamUserAvatarThemeData(
      initialsTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minHeight: 80,
        minWidth: 80,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
  });

  /// The list of participants to display.
  final List<UserInfo> participants;

  /// Theme for the avatar in a call with one participant.
  final StreamUserAvatarThemeData singleParticipantAvatarTheme;

  /// Theme for the avatar in a call with multiple participants.
  final StreamUserAvatarThemeData multipleParticipantAvatarTheme;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final length = participants.length;

    if (length == 1) {
      return StreamUserAvatarTheme(
        data: singleParticipantAvatarTheme,
        child: StreamUserAvatar(
          user: participants[0],
        ),
      );
    } else if (length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamUserAvatarTheme(
            data: multipleParticipantAvatarTheme,
            child: StreamUserAvatar(
              user: participants[0],
            ),
          ),
          const SizedBox(
            width: 32,
          ),
          StreamUserAvatarTheme(
            data: multipleParticipantAvatarTheme,
            child: StreamUserAvatar(
              user: participants[1],
            ),
          )
        ],
      );
    } else if (length >= 3) {
      return Column(
        children: [
          StreamUserAvatarTheme(
            data: multipleParticipantAvatarTheme,
            child: StreamUserAvatar(
              user: participants[0],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamUserAvatarTheme(
                data: multipleParticipantAvatarTheme,
                child: StreamUserAvatar(
                  user: participants[1],
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              if (length > 3)
                Container(
                  constraints: multipleParticipantAvatarTheme.constraints,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: streamChatTheme.colorTheme.accentPrimary,
                      borderRadius: multipleParticipantAvatarTheme.borderRadius,
                    ),
                    child: Center(
                      child: Text(
                        '+${length - 2}',
                        style: multipleParticipantAvatarTheme.initialsTextStyle,
                      ),
                    ),
                  ),
                )
              else
                StreamUserAvatarTheme(
                  data: multipleParticipantAvatarTheme,
                  child: StreamUserAvatar(
                    user: participants[2],
                  ),
                )
            ],
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
