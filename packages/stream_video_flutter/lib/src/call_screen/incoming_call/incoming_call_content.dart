import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';
import '../common/ringing_call_details.dart';
import '../common/ringing_call_style_defaults.dart';
import 'incoming_call_controls.dart';

/// Represents the Incoming Call state and UI, when the user is called by
/// other people.
class StreamIncomingCallContent extends StatefulWidget {
  const StreamIncomingCallContent({
    super.key,
    required this.call,
    this.onAcceptCallTap,
    this.onDeclineCallTap,
    this.onMicrophoneTap,
    this.onCameraTap,
    this.style,
    this.participantsAvatarWidgetBuilder,
    this.participantsDisplayNameWidgetBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the accept call button is tapped.
  final VoidCallback? onAcceptCallTap;

  /// The action to perform when the decline call button is tapped.
  final VoidCallback? onDeclineCallTap;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback? onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback? onCameraTap;

  /// Overrides for this screen alone.
  ///
  /// Resolved over [StreamIncomingCallTheme], so setting one property here
  /// leaves the rest coming from the theme.
  final StreamRingingCallStyle? style;

  /// Builder used to create a custom widget for participants avatars.
  final CallWidgetBuilderWithData<ParticipantsData>?
  participantsAvatarWidgetBuilder;

  /// Builder used to create a custom widget for participants display names.
  final CallWidgetBuilderWithData<ParticipantsData>?
  participantsDisplayNameWidgetBuilder;

  @override
  State<StreamIncomingCallContent> createState() =>
      _StreamIncomingCallContentState();
}

class _StreamIncomingCallContentState extends State<StreamIncomingCallContent> {
  CallConnectOptions get connectOptions => widget.call.connectOptions;

  @override
  Widget build(BuildContext context) {
    final style = RingingCallStyleDefaults(
      context,
      StreamIncomingCallTheme.of(context).style?.merge(widget.style) ??
          widget.style,
    );

    Widget buildContent(List<UserInfo> users) => ColoredBox(
      color: style.backgroundColor,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: RingingCallDetails(
                  participants: users,
                  status: context.translations.ringingIncomingCall,
                  style: style,
                  avatar: widget.participantsAvatarWidgetBuilder?.call(
                    context,
                    widget.call,
                    ParticipantsData(participants: users),
                  ),
                  nameLine: widget.participantsDisplayNameWidgetBuilder?.call(
                    context,
                    widget.call,
                    ParticipantsData(participants: users),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: style.controlsPadding,
                  child: IncomingCallControls(
                    style: style,
                    isMicrophoneEnabled: connectOptions.microphone.isEnabled,
                    isCameraEnabled: connectOptions.camera.isEnabled,
                    onAcceptCallTap: _onAcceptCallTap,
                    onDeclineCallTap: () => _onDeclineCallTap(context),
                    onMicrophoneTap: () => _onMicrophoneTap(context),
                    onCameraTap: () => _onCameraTap(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return PartialCallStateBuilder(
      call: widget.call,
      selector: (state) =>
          state.ringingMembers.map((e) => e.toUserInfo()).toList(),
      builder: (_, members) => buildContent(members),
    );
  }

  Future<void> _onDeclineCallTap(BuildContext context) async {
    if (widget.onDeclineCallTap != null) {
      widget.onDeclineCallTap!();
    } else {
      await widget.call.reject(reason: CallRejectReason.decline());
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
