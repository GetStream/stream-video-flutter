import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../../../stream_video_flutter.dart';
import '../../theme/stream_incoming_outgoing_call_theme.dart';
import '../../utils/extensions.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';
import 'outgoing_call_controls.dart';

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class OutgoingCallContent extends StatelessWidget {
  /// Creates a new instance of [OutgoingCallContent].
  const OutgoingCallContent({
    super.key,
    required this.call,
    required this.callState,
    required this.onCancelPressed,
    required this.onMicrophoneTap,
    required this.onCameraTap,
    this.theme,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onCancelPressed;

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
    final participants =
        callState.otherParticipants.map((e) => e.toUserInfo()).toList();

    return CallBackground(
      participants: participants,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ParticipantAvatars(
              participants: participants,
              singleParticipantAvatarTheme: theme.singleParticipantAvatarTheme,
              multipleParticipantAvatarTheme:
                  theme.multipleParticipantAvatarTheme,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: CallingParticipants(
                participants: participants,
                singleParticipantTextStyle: theme.singleParticipantTextStyle,
                multipleParticipantTextStyle:
                    theme.multipleParticipantTextStyle,
              ),
            ),
            Text(
              'Calling…',
              style: theme.callingLabelTextStyle,
            ),
            const Spacer(),
            OutgoingCallControls(
              onHangup: onCancelPressed,
              onMicrophoneTap: onMicrophoneTap,
              onCameraTap: onCameraTap,
            ),
          ],
        ),
      ),
    );
  }
}
