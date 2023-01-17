import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../stream_video_flutter.dart';
import '../theme/stream_outgoing_call_theme.dart';
import 'call_background.dart';
import 'calling_participants.dart';
import 'outgoing_call_controls.dart';
import 'participant_avatars.dart';

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class StreamOutgoingCall extends StatelessWidget {
  const StreamOutgoingCall({
    super.key,
    required this.users,
    this.theme,
  });

  /// The participant to display.
  final List<UserInfo> users;

  /// Theme for the outgoing call widget.
  final StreamOutgoingCallTheme? theme;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final theme = this.theme ?? streamChatTheme.outgoingCallTheme;

    return CallBackground(
      participants: users,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ParticipantAvatars(
            participants: users,
            singleParticipantAvatarTheme: theme.singleParticipantAvatarTheme,
            multipleParticipantAvatarTheme:
                theme.multipleParticipantAvatarTheme,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
            child: CallingParticipants(
              participants: users,
              singleParticipantTextStyle: theme.singleParticipantTextStyle,
              multipleParticipantTextStyle: theme.multipleParticipantTextStyle,
            ),
          ),
          Text(
            'Calling…',
            style: theme.callingLabelTextStyle,
          ),
          const Spacer(),
          OutgoingCallControls(
            onHangup: () {
              // TODO: Hande the action
            },
          ),
        ],
      ),
    );
  }
}
