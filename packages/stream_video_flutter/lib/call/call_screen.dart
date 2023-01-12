import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

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
class CallScreen extends StatelessWidget {
  const CallScreen({
    Key? key,
    required this.call,
    required this.onBackPressed,
    required this.onHangUp,
    this.participantsInfoWidgetBuilder,
  }) : super(key: key);

  final Call call;

  static const routeName = '/call';

  // Hardcoded state. This should some from StreamVideo. 
  final CallState callState = CallState.onCall;
  final VoidCallback onBackPressed;
  final VoidCallback onHangUp;
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;

  @override
  Widget build(BuildContext context) {
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
                        StreamCallParticipantsInfoView(call: call),
              ),
            );
          },
        );
      case CallState.incoming:
        return const MockIncomingCallView();
      case CallState.outgoing:
        return const MockOutgoingCallView();
    }
  }
}

enum CallState {
  onCall,
  incoming,
  outgoing,
}

/// Delete this class one the final implementation if done.
class MockOutgoingCallView extends StatelessWidget {
  const MockOutgoingCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("This screen is not implemented yet.");
  }
}

/// Delete this class one the final implementation if done.
class MockIncomingCallView extends StatelessWidget {
  const MockIncomingCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("This screen is not implemented yet.");
  }
}
