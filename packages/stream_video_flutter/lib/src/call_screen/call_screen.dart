import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// {@template callParticipantsBuilder}
/// Builder used to create a custom participants info screen.
/// {@endtemplate}
typedef CallParticipantsInfoWidgetBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// This class holds the widgets for the three possible states of a call: on call,
/// incoming call, outgoing call and presents the correct screen accordingly with
/// the state.
class StreamCallScreen extends StatelessWidget {
  StreamCallScreen({
    super.key,
    required this.call,
    required this.onBackPressed,
    required this.onHangUp,
    this.participantsInfoWidgetBuilder,
  });

  final Call call;

  // Hardcoded state. This should some from StreamVideo.
  final CallState callState = CallState.onCall;
  final VoidCallback onBackPressed;
  final VoidCallback onHangUp;
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;
  final List<UserInfo> incomingCallUsers = [];
  final List<UserInfo> outgoingCallUsers = [];

  @override
  Widget build(BuildContext context) {
    final usersProvider = StreamUsersConfiguration.of(context);

    switch (callState) {
      case CallState.onCall:
        return StreamActiveCall(
          call: call,
          onBackPressed: onBackPressed,
          onHangUp: onHangUp,
          onParticipantsTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    participantsInfoWidgetBuilder?.call(context, call) ??
                    StreamCallParticipantsInfoView(
                      call: call,
                      usersProvider: usersProvider,
                    ),
              ),
            );
          },
        );
      case CallState.incoming:
        return StreamIncomingCall(
          users: incomingCallUsers,
          onAccept: () {
            // TODO: Handle the action
          },
          onHangup: () {
            // TODO: Handle the action
          },
          onMicrophoneTap: () {
            // TODO: Handle the action
          },
          onCameraTap: () {
            // TODO: Handle the action
          },
        );
      case CallState.outgoing:
        return StreamOutgoingCall(
          users: outgoingCallUsers,
          onHangup: () {
            // TODO: Handle the action
          },
          onMicrophoneTap: () {
            // TODO: Handle the action
          },
          onCameraTap: () {
            // TODO: Handle the action
          },
        );
    }
  }
}

enum CallState {
  onCall,
  incoming,
  outgoing,
}
