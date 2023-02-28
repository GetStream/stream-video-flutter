import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../utils/extensions.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';

/// Represents the Incoming Call state and UI, when the user is called by
/// other people.
class IncomingCallContent extends StatelessWidget {
  const IncomingCallContent({
    super.key,
    required this.call,
    required this.callState,
    this.onAcceptCallTap,
    this.onDeclineCallTap,
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
  final VoidCallback? onAcceptCallTap;

  /// The action to perform when the decline call button is tapped.
  final VoidCallback? onDeclineCallTap;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallControlOption(
                  icon: const Icon(Icons.call_end_rounded),
                  iconColor: Colors.white,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _onDeclineCallTap(context);
                  },
                  padding: const EdgeInsets.all(24),
                ),
                CallControlOption(
                  icon: const Icon(Icons.call_rounded),
                  iconColor: Colors.white,
                  backgroundColor: Colors.green,
                  onPressed: _onAcceptCallTap,
                  padding: const EdgeInsets.all(24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeclineCallTap(BuildContext context) async {
    await call.apply(const RejectCall());
    await call.disconnect();

    if (onDeclineCallTap != null) {
      onDeclineCallTap!();
    } else {
      await Navigator.maybePop(context);
    }
  }

  Future<void> _onAcceptCallTap() async {
    await call.apply(const AcceptCall());

    onDeclineCallTap?.call();
  }
}
