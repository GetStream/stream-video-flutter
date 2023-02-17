import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../theme/stream_incoming_outgoing_call_theme.dart';
import '../../utils/extensions.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';
import 'incoming_call_controls.dart';

/// Represents the Incoming Call state and UI, when the user is called by
/// other people.
class IncomingCallContent extends StatelessWidget {
  const IncomingCallContent({
    super.key,
    required this.call,
    required this.callState,
    required this.onRejectPressed,
    required this.onAcceptPressed,
    required this.onMicrophoneTap,
    required this.onCameraTap,
    this.theme,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the accept call button is tapped.
  final VoidCallback onAcceptPressed;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onRejectPressed;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback onCameraTap;

  /// Theme for the incoming call widget.
  final StreamIncomingOutgoingCallTheme? theme;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final theme = this.theme ?? streamChatTheme.incomingCallTheme;

    final users =
        callState.otherParticipants.map((e) => e.toUserInfo()).toList();

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
                multipleParticipantTextStyle:
                    theme.multipleParticipantTextStyle,
              ),
            ),
            Text(
              'Incoming Call...',
              style: theme.callingLabelTextStyle,
            ),
            const Spacer(),
            IncomingCallControls(
              onAccept: onAcceptPressed,
              onHangup: onRejectPressed,
              onMicrophoneTap: onMicrophoneTap,
              onCameraTap: onCameraTap,
            ),
          ],
        ),
      ),
    );
  }
}
