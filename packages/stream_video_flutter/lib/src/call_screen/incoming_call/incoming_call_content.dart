import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../theme/incoming_outgoing_call_theme.dart';
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
    this.singleParticipantAvatarTheme,
    this.multipleParticipantAvatarTheme,
    this.singleParticipantTextStyle,
    this.multipleParticipantTextStyle,
    this.callingLabelTextStyle,
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

  /// Theme for the avatar in a call with one participant.
  final StreamUserAvatarThemeData? singleParticipantAvatarTheme;

  /// Theme for the avatar in a call with multiple participants.
  final StreamUserAvatarThemeData? multipleParticipantAvatarTheme;

  /// Text style for the participant label in a call with one participant.
  final TextStyle? singleParticipantTextStyle;

  /// Text style for the participant label in a call with multiple participants.
  final TextStyle? multipleParticipantTextStyle;

  /// Text style for the calling label.
  final TextStyle? callingLabelTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = StreamIncomingOutgoingCallTheme.incomingCallThemeOf(context);

    final singleParticipantAvatarTheme =
        this.singleParticipantAvatarTheme ?? theme.singleParticipantAvatarTheme;
    final multipleParticipantAvatarTheme =
        this.multipleParticipantAvatarTheme ??
            theme.multipleParticipantAvatarTheme;
    final singleParticipantTextStyle =
        this.singleParticipantTextStyle ?? theme.singleParticipantTextStyle;
    final multipleParticipantTextStyle =
        this.multipleParticipantTextStyle ?? theme.multipleParticipantTextStyle;
    final callingLabelTextStyle =
        this.callingLabelTextStyle ?? theme.callingLabelTextStyle;

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
              singleParticipantAvatarTheme: singleParticipantAvatarTheme,
              multipleParticipantAvatarTheme: multipleParticipantAvatarTheme,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: CallingParticipants(
                participants: users,
                singleParticipantTextStyle: singleParticipantTextStyle,
                multipleParticipantTextStyle: multipleParticipantTextStyle,
              ),
            ),
            Text(
              'Incoming Call...',
              style: callingLabelTextStyle,
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
