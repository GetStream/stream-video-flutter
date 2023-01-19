import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../stream_video_flutter.dart';
import '../theme/stream_incoming_outgoing_call_theme.dart';
import 'call_background.dart';
import 'calling_participants.dart';
import 'incoming_call_controls.dart';
import 'participant_avatars.dart';

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class StreamIncomingCall extends StatelessWidget {
  const StreamIncomingCall({
    super.key,
    required this.users,
    required this.onAccept,
    required this.onHangup,
    required this.onMicrophoneTap,
    required this.onCameraTap,
    this.theme,
  });

  /// The participant to display.
  final List<UserInfo> users;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onAccept;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onHangup;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback onCameraTap;

  /// Theme for the outgoing call widget.
  final StreamIncomingOutgoingCallTheme? theme;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final theme = this.theme ?? streamChatTheme.outgoingCallTheme;

    return CallBackground(
      participants: users,
      child: Material(
        color: Colors.transparent,
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
              'Incoming Call...',
              style: theme.callingLabelTextStyle,
            ),
            const Spacer(),
            IncomingCallControls(
              onAccept: onAccept,
              onHangup: onHangup,
              onMicrophoneTap: onMicrophoneTap,
              onCameraTap: onCameraTap,
            ),
          ],
        ),
      ),
    );
  }
}
