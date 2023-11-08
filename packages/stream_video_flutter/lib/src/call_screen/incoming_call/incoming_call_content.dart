import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../utils/extensions.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';
import 'incoming_call_controls.dart';

/// Represents the Incoming Call state and UI, when the user is called by
/// other people.
class StreamIncomingCallContent extends StatefulWidget {
  const StreamIncomingCallContent({
    super.key,
    required this.call,
    required this.callState,
    this.onAcceptCallTap,
    this.onDeclineCallTap,
    this.onMicrophoneTap,
    this.onCameraTap,
    this.singleParticipantAvatarTheme,
    this.multipleParticipantAvatarTheme,
    this.singleParticipantTextStyle,
    this.multipleParticipantTextStyle,
    this.callingLabelTextStyle,
    this.participantsAvatarBuilder,
    this.participantsDisplayNameBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  /// The action to perform when the accept call button is tapped.
  final VoidCallback? onAcceptCallTap;

  /// The action to perform when the decline call button is tapped.
  final VoidCallback? onDeclineCallTap;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback? onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback? onCameraTap;

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

  /// Builder used to create a custom widget for participants avatars.
  final ParticipantsAvatarBuilder? participantsAvatarBuilder;

  /// Builder used to create a custom widget for participants display names.
  final ParticipantsDisplayNameBuilder? participantsDisplayNameBuilder;

  @override
  State<StreamIncomingCallContent> createState() =>
      _StreamIncomingCallContentState();
}

class _StreamIncomingCallContentState extends State<StreamIncomingCallContent> {
  CallConnectOptions get connectOptions => widget.call.connectOptions;

  @override
  Widget build(BuildContext context) {
    final theme = StreamIncomingOutgoingCallTheme.incomingCallThemeOf(context);

    final singleParticipantAvatarTheme = widget.singleParticipantAvatarTheme ??
        theme.singleParticipantAvatarTheme;
    final multipleParticipantAvatarTheme =
        widget.multipleParticipantAvatarTheme ??
            theme.multipleParticipantAvatarTheme;
    final singleParticipantTextStyle =
        widget.singleParticipantTextStyle ?? theme.singleParticipantTextStyle;
    final multipleParticipantTextStyle = widget.multipleParticipantTextStyle ??
        theme.multipleParticipantTextStyle;
    final callingLabelTextStyle =
        widget.callingLabelTextStyle ?? theme.callingLabelTextStyle;

    final users =
        widget.callState.otherParticipants.map((e) => e.toUserInfo()).toList();

    return CallBackground(
      participants: users,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            widget.participantsAvatarBuilder?.call(
                  context,
                  widget.call,
                  widget.callState,
                  users,
                ) ??
                ParticipantAvatars(
                  participants: users,
                  singleParticipantAvatarTheme: singleParticipantAvatarTheme,
                  multipleParticipantAvatarTheme:
                      multipleParticipantAvatarTheme,
                ),
            widget.participantsDisplayNameBuilder?.call(
                  context,
                  widget.call,
                  widget.callState,
                  users,
                ) ??
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                  child: CallingParticipants(
                    participants: users,
                    singleParticipantTextStyle: singleParticipantTextStyle,
                    multipleParticipantTextStyle: multipleParticipantTextStyle,
                  ),
                ),
            Text(
              // TODO hardcoded text
              'Incoming Call...',
              style: callingLabelTextStyle,
            ),
            const Spacer(),
            IncomingCallControls(
              isMicrophoneEnabled: connectOptions.microphone.isEnabled,
              isCameraEnabled: connectOptions.camera.isEnabled,
              onAcceptCallTap: _onAcceptCallTap,
              onDeclineCallTap: () => _onDeclineCallTap(context),
              onMicrophoneTap: () => _onMicrophoneTap(context),
              onCameraTap: () => _onCameraTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeclineCallTap(BuildContext context) async {
    if (widget.onDeclineCallTap != null) {
      widget.onDeclineCallTap!();
    } else {
      await widget.call.reject();
      await widget.call.leave();
    }
  }

  Future<void> _onAcceptCallTap() async {
    if (widget.onAcceptCallTap != null) {
      widget.onAcceptCallTap!();
    } else {
      await widget.call.accept();
    }
  }

  Future<void> _onMicrophoneTap(BuildContext context) async {
    if (widget.onMicrophoneTap != null) {
      widget.onMicrophoneTap!();
    } else {
      widget.call.connectOptions = connectOptions.copyWith(
        microphone: connectOptions.microphone.toggle(),
      );
      return setState(() => {});
    }
  }

  Future<void> _onCameraTap(BuildContext context) async {
    if (widget.onCameraTap != null) {
      widget.onCameraTap!();
    } else {
      widget.call.connectOptions = connectOptions.copyWith(
        camera: connectOptions.camera.toggle(),
      );
      return setState(() => {});
    }
  }
}
