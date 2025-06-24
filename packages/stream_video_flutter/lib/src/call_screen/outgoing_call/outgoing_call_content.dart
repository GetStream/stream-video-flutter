// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../common/call_background.dart';
import '../common/calling_participants.dart';
import '../common/participant_avatars.dart';
import 'outgoing_call_controls.dart';

typedef OutgoingCallBackground = Widget Function(
  Call call,
  CallState callState,
  List<UserInfo> participants,
  Widget child,
);

/// Represents the Outgoing Call state and UI, when the user is calling
/// other people.
class StreamOutgoingCallContent extends StatefulWidget {
  /// Creates a new instance of [StreamOutgoingCallContent].
  const StreamOutgoingCallContent({
    super.key,
    required this.call,
    @Deprecated(PartialStateDeprecationMessage.callState) this.callState,
    this.onCancelCallTap,
    this.onMicrophoneTap,
    this.onCameraTap,
    this.singleParticipantAvatarTheme,
    this.multipleParticipantAvatarTheme,
    this.singleParticipantTextStyle,
    this.multipleParticipantTextStyle,
    this.callingLabelTextStyle,
    @Deprecated('Use callBackgroundWidgetBuilder instead.')
    this.callBackgroundBuilder,
    this.callBackgroundWidgetBuilder,
    @Deprecated('Use participantsAvatarWidgetBuilder instead.')
    this.participantsAvatarBuilder,
    this.participantsAvatarWidgetBuilder,
    @Deprecated('Use participantsDisplayNameWidgetBuilder instead.')
    this.participantsDisplayNameBuilder,
    this.participantsDisplayNameWidgetBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  @Deprecated(PartialStateDeprecationMessage.callState)
  final CallState? callState;

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
  ///
  /// Recommend to use [participantsAvatarWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use participantsAvatarWidgetBuilder instead.')
  final ParticipantsAvatarBuilder? participantsAvatarBuilder;

  /// Builder used to create a custom widget for participants avatars.
  final CallWidgetBuilderWithData<ParticipantsData>?
      participantsAvatarWidgetBuilder;

  /// Builder used to create a custom widget for participants display names.
  ///
  /// Recommend to use [participantsDisplayNameWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use participantsDisplayNameWidgetBuilder instead.')
  final ParticipantsDisplayNameBuilder? participantsDisplayNameBuilder;

  /// Builder used to create a custom widget for participants display names.
  final CallWidgetBuilderWithData<ParticipantsData>?
      participantsDisplayNameWidgetBuilder;

  /// A widget that is placed behind the outgoing call UI instead of the Stream default
  ///
  /// Preferably use a [Stack] widget to layer your UI like in the default [CallBackground].
  ///
  /// Recommend to use [callBackgroundWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use callBackgroundWidgetBuilder instead.')
  final OutgoingCallBackground? callBackgroundBuilder;

  /// A widget that is placed behind the outgoing call UI instead of the Stream default
  ///
  /// Preferably use a [Stack] widget to layer your UI like in the default [CallBackground].
  final CallWidgetChildBuilder? callBackgroundWidgetBuilder;

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

    Widget buildContent(List<UserInfo> participants) {
      final child = Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            widget.participantsAvatarWidgetBuilder?.call(
                  context,
                  widget.call,
                  ParticipantsData(participants: participants),
                ) ??
                widget.participantsAvatarBuilder?.call(
                  context,
                  widget.call,
                  widget.callState ?? widget.call.state.value,
                  participants,
                ) ??
                ParticipantAvatars(
                  participants: participants,
                  singleParticipantAvatarTheme: singleParticipantAvatarTheme,
                  multipleParticipantAvatarTheme:
                      multipleParticipantAvatarTheme,
                ),
            widget.participantsDisplayNameWidgetBuilder?.call(
                  context,
                  widget.call,
                  ParticipantsData(participants: participants),
                ) ??
                widget.participantsDisplayNameBuilder?.call(
                  context,
                  widget.call,
                  widget.callState ?? widget.call.state.value,
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
      );

      return widget.callBackgroundWidgetBuilder?.call(
            context,
            widget.call,
            child,
          ) ??
          widget.callBackgroundBuilder?.call(
            widget.call,
            widget.callState ?? widget.call.state.value,
            participants,
            child,
          ) ??
          CallBackground(
            participants: participants,
            child: child,
          );
    }

    if (widget.callState != null) {
      return buildContent(
        widget.callState!.ringingMembers.map((e) => e.toUserInfo()).toList(),
      );
    }

    return PartialCallStateBuilder(
      call: widget.call,
      selector: (state) =>
          state.ringingMembers.map((e) => e.toUserInfo()).toList(),
      builder: (_, members) => buildContent(members),
    );
  }

  Future<void> _onCancelCallTap(BuildContext context) async {
    if (widget.onCancelCallTap != null) {
      widget.onCancelCallTap!();
    } else {
      await widget.call.reject(reason: CallRejectReason.cancel());
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
