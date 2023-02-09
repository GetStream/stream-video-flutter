import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../participants_info/call_participants_info_view_v2.dart';
import 'active_call/active_call_v2.dart';
import 'incoming_call/incoming_call_v2.dart';
import 'outgoing_call/outgoing_call_v2.dart';

/// {@template callParticipantsBuilder}
/// Builder used to create a custom participants info screen.
/// {@endtemplate}
typedef CallParticipantsInfoWidgetBuilderV2 = Widget Function(
  BuildContext context,
  CallV2 call,
);

const int _idState = 2;
int _callSeq = 1;

class StreamCallScreenV2 extends StatefulWidget {
  const StreamCallScreenV2({
    super.key,
    required this.call,
    required this.onBackPressed,
    required this.onHangUp,
    this.participantsInfoWidgetBuilder,
  });

  final CallV2 call;
  final VoidCallback onBackPressed;
  final VoidCallback onHangUp;
  final CallParticipantsInfoWidgetBuilderV2? participantsInfoWidgetBuilder;

  @override
  State<StreamCallScreenV2> createState() => _StreamCallScreenV2State();
}

class _StreamCallScreenV2State extends State<StreamCallScreenV2> {
  final _logger = taggedLogger(tag: 'CallScreen-${_callSeq++}');
  final subscriptions = Subscriptions();

  @override
  void initState() {
    super.initState();
    _logger.d(() => '[initState] no args');
    subscriptions.add(_idState, widget.call.state.listen(_setState));
    _setState(widget.call.state.value);
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d(() => '[dispose] no args');
    subscriptions.cancelAll();
  }

  Future<void> _setState(CallStateV2 state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final status = callState.status;
    _logger.d(() => '[build] status: $status');
    if (status.isDrop) {
      _disconnect();
    }

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return IncomingCallV2(
        state: callState,
        onRejectPressed: _rejectCall,
        onAcceptPressed: _acceptCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    }
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return OutgoingCallV2(
        state: callState,
        onCancelPressed: _cancelCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    }

    if (status.isConnected) {
      final participants = callState.callParticipants.take(4).toList();
      final localParticipant =
          participants.firstWhereOrNull((it) => it.isLocal)!;

      final usersProvider = StreamUsersConfiguration.of(context);

      return StreamActiveCallV2(
        call: widget.call,
        state: callState,
        onBackPressed: widget.onBackPressed,
        onHangUp: widget.onHangUp,
        onParticipantsTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  widget.participantsInfoWidgetBuilder
                      ?.call(context, widget.call) ??
                  StreamCallParticipantsInfoViewV2(
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
    } catch (e, stk) {
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
    _logger.d(() => '[cancelCall] no args');
    await widget.call.apply(const CancelCall());
    await _disconnect();
  }

  Future<void> _disconnect() async {
    _logger.d(() => '[disconnect] no args');
    await widget.call.disconnect();
    widget.onBackPressed();
  }
}
