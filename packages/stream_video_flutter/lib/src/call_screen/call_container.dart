import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../participants_info/call_participants_info_view.dart';

/// Builder used to create a custom participants info screen.
typedef CallParticipantsInfoWidgetBuilder = Widget Function(
  BuildContext context,
  CallV2 call,
);

/// Represents different call content based on the call state.
class StreamCallContainer extends StatefulWidget {
  /// Creates a new instance of [StreamCallContainer].
  const StreamCallContainer({
    super.key,
    required this.call,
    required this.onBackPressed,
    required this.onLeaveCall,
    this.participantsInfoWidgetBuilder,
  });

  /// Represents a call.
  final CallV2 call;

  /// The action to perform when the back button is pressed.
  final VoidCallback onBackPressed;

  /// The action to perform when the leave call button is pressed.
  final VoidCallback onLeaveCall;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoWidgetBuilder? participantsInfoWidgetBuilder;

  @override
  State<StreamCallContainer> createState() => _StreamCallContainerState();
}

class _StreamCallContainerState extends State<StreamCallContainer> {
  final _subscriptions = Subscriptions();

  @override
  void initState() {
    super.initState();
    _subscriptions.add(0, widget.call.state.listen(_setState));
    _setState(widget.call.state.value);
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.cancelAll();
  }

  Future<void> _setState(CallStateV2 state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final status = callState.status;
    if (status.isDrop) {
      _disconnect();
    }

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return IncomingCallContent(
        state: callState,
        onRejectPressed: _rejectCall,
        onAcceptPressed: _acceptCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    }
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return OutgoingCallContent(
        state: callState,
        onCancelPressed: _cancelCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    }

    if (status.isConnected) {
      final usersProvider = StreamUsersConfiguration.of(context);

      return StreamCallContent(
        call: widget.call,
        state: callState,
        onBackPressed: widget.onBackPressed,
        onLeaveCall: widget.onLeaveCall,
        onParticipantsTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  widget.participantsInfoWidgetBuilder
                      ?.call(context, widget.call) ??
                  StreamCallParticipantsInfoView(
                    call: widget.call,
                    usersProvider: usersProvider,
                  ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelCall,
          ),
        ],
        title: Text('CallId: ${callState.callCid}'),
      ),
      body: Center(
        child: Text(
          'Status: ${status.runtimeType}',
        ),
      ),
    );
  }

  Future<void> _start() async {
    try {
      if (widget.call.state.value.status.isIdle) {
        final result = await widget.call.getOrCreate();
        if (result.isFailure) {
          await _cancelCall();
          return;
        }
      }
      final result = await widget.call.connect();
      if (result.isFailure) {
        await _cancelCall();
      }
    } catch (e) {
      await _cancelCall();
    }
  }

  Future<void> _rejectCall() async {
    await widget.call.apply(const RejectCall());
    await widget.call.disconnect();
    widget.onBackPressed();
  }

  Future<void> _acceptCall() async {
    await widget.call.apply(const AcceptCall());
  }

  Future<void> _cancelCall() async {
    await widget.call.apply(const CancelCall());
    await _disconnect();
  }

  Future<void> _disconnect() async {
    await widget.call.disconnect();
    widget.onBackPressed();
  }
}
