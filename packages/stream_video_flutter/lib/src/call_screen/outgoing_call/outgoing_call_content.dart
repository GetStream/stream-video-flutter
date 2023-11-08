import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../utils/extensions.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';
import 'outgoing_call_controls.dart';

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class StreamOutgoingCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamOutgoingCallContent].
  const StreamOutgoingCallContent({
    super.key,
    required this.call,
    required this.callState,
    this.onCancelCallTap,
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

  /// The action to perform when the cancel call button is tapped.
  final VoidCallback? onCancelCallTap;

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
  State<StreamOutgoingCallContent> createState() =>
      _StreamOutgoingCallContentState();
}

class _StreamOutgoingCallContentState extends State<StreamOutgoingCallContent> {
  CallConnectOptions get connectOptions => widget.call.connectOptions;

  @override
  Widget build(BuildContext context) {
    final theme = StreamIncomingOutgoingCallTheme.outgoingCallThemeOf(context);

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

    final participants =
        widget.callState.otherParticipants.map((e) => e.toUserInfo()).toList();

    return CallBackground(
      participants: participants,
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
                  participants,
                ) ??
                ParticipantAvatars(
                  participants: participants,
                  singleParticipantAvatarTheme: singleParticipantAvatarTheme,
                  multipleParticipantAvatarTheme:
                      multipleParticipantAvatarTheme,
                ),
            widget.participantsDisplayNameBuilder?.call(
                  context,
                  widget.call,
                  widget.callState,
                  participants,
                ) ??
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                  child: CallingParticipants(
                    participants: participants,
                    singleParticipantTextStyle: singleParticipantTextStyle,
                    multipleParticipantTextStyle: multipleParticipantTextStyle,
                  ),
                ),
            Text(
              'Calling…',
              style: callingLabelTextStyle,
            ),
            const Spacer(),
            OutgoingCallControls(
              isMicrophoneEnabled: connectOptions.microphone.isEnabled,
              isCameraEnabled: connectOptions.camera.isEnabled,
              onCancelCallTap: () => _onCancelCallTap(context),
              onMicrophoneTap: () => _onMicrophoneTap(context),
              onCameraTap: () => _onCameraTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCancelCallTap(BuildContext context) async {
    if (widget.onCancelCallTap != null) {
      widget.onCancelCallTap!();
    } else {
      await widget.call.end();
      await widget.call.leave();
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
