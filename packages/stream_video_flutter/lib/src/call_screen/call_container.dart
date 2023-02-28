import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../participants_info/call_participants_info_menu.dart';

/// Builder used to create a custom participants info screen.
typedef CallParticipantsInfoWidgetBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// Represents different call content based on the call state.
class StreamCallContainer extends StatefulWidget {
  /// Creates a new instance of [StreamCallContainer].
  const StreamCallContainer({
    super.key,
    required this.call,
    this.callConnectOptions = const CallConnectOptions(),
    required this.onBackPressed,
    required this.onLeaveCall,
    this.participantsInfoWidgetBuilder,
    this.callControlsBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Options used while connecting to the call.
  final CallConnectOptions callConnectOptions;

  /// The action to perform when the back button is pressed.
  final VoidCallback onBackPressed;

  /// The action to perform when the leave call button is pressed.
  final VoidCallback onLeaveCall;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsWidgetBuilder? callControlsBuilder;

  @override
  State<StreamCallContainer> createState() => _StreamCallContainerState();
}

class _StreamCallContainerState extends State<StreamCallContainer> {
  final _subscriptions = Subscriptions();

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  late CallState _callState;

  @override
  void initState() {
    super.initState();
    _subscriptions.add(0, call.state.listen(_setState));
    _callState = call.state.value;
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.cancelAll();
  }

  Future<void> _setState(CallState callState) async {
    setState(() {
      _callState = callState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = _callState.status;

    if (status.isDrop) _disconnect();

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return IncomingCallContent(
        call: call,
        callState: _callState,
        onRejectPressed: _onRejectCall,
        onAcceptPressed: _onAcceptCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    } else if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return OutgoingCallContent(
        call: call,
        callState: _callState,
        onCancelPressed: _onCancelCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    } else {
      final usersProvider = StreamUsersConfiguration.of(context);

      return StreamCallContent(
        call: call,
        callState: _callState,
        onBackPressed: widget.onBackPressed,
        onLeaveCall: widget.onLeaveCall,
        callControlsBuilder: widget.callControlsBuilder,
        onParticipantsTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  widget.participantsInfoWidgetBuilder
                      ?.call(context, widget.call) ??
                  StreamCallParticipantsInfoMenu(
                    call: widget.call,
                    usersProvider: usersProvider,
                  ),
            ),
          );
        },
      );
    }
  }

  Future<void> _start() async {
    try {
      final result = await call.connect(options: widget.callConnectOptions);
      if (result.isFailure) {
        await _onCancelCall();
      }
    } catch (e) {
      await _onCancelCall();
    }
  }

  Future<void> _onRejectCall() async {
    await call.apply(const RejectCall());
    await call.disconnect();
    widget.onBackPressed();
  }

  Future<void> _onAcceptCall() async {
    await call.apply(const AcceptCall());
  }

  Future<void> _onCancelCall() async {
    await call.apply(const CancelCall());
    await _disconnect();
  }

  Future<void> _disconnect() async {
    await widget.call.disconnect();
    widget.onBackPressed();
  }
}
