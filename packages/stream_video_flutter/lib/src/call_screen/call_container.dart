import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Builder used to create a custom incoming call widget.
typedef IncomingCallBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom outgoing call widget.
typedef OutgoingCallBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call content widget.
typedef CallContentBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom widget for participants avatars.
typedef ParticipantsAvatarBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
  List<UserInfo> participants,
);

/// Builder used to create a custom widget for participants display names.
typedef ParticipantsDisplayNameBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
  List<UserInfo> participants,
);

/// Represents different call content based on the call state.
class StreamCallContainer extends StatefulWidget {
  /// Creates a new instance of [StreamCallContainer].
  const StreamCallContainer({
    super.key,
    required this.call,
    this.callConnectOptions = const CallConnectOptions(),
    this.onBackPressed,
    this.onLeaveCallTap,
    this.onAcceptCallTap,
    this.onDeclineCallTap,
    this.onCancelCallTap,
    this.incomingCallBuilder,
    this.outgoingCallBuilder,
    this.callContentBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Options used while connecting to the call.
  final CallConnectOptions callConnectOptions;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The action to perform when the accept call button is tapped.
  final VoidCallback? onAcceptCallTap;

  /// The action to perform when the decline call button is tapped.
  final VoidCallback? onDeclineCallTap;

  /// The action to perform when the cancel call button is tapped.
  final VoidCallback? onCancelCallTap;

  /// Builder used to create a custom incoming call widget.
  final IncomingCallBuilder? incomingCallBuilder;

  /// Builder used to create a custom outgoing call widget.
  final OutgoingCallBuilder? outgoingCallBuilder;

  /// Builder used to create a custom call content widget.
  final CallContentBuilder? callContentBuilder;

  @override
  State<StreamCallContainer> createState() => _StreamCallContainerState();
}

class _StreamCallContainerState extends State<StreamCallContainer> {
  final _logger = taggedLogger(tag: 'SV:CallContainer');
  StreamSubscription<CallState>? _callStateSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  late CallState _callState;

  @override
  void initState() {
    super.initState();
    _callStateSubscription = call.state.listen(_setState);
    _callState = call.state.value;
    _connect();
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    _callStateSubscription = null;
    super.dispose();
  }

  void _setState(CallState callState) {
    _logger.v(() => '[setState] callState.status: ${callState.status}');
    setState(() {
      _callState = callState;
    });
    if (callState.status.isDisconnected) {
      _leave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _callState.status;
    _logger.v(() => '[build] status: $status');

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return widget.incomingCallBuilder?.call(context, call, _callState) ??
          StreamIncomingCallContent(
            call: call,
            callState: _callState,
            onAcceptCallTap: widget.onAcceptCallTap,
            onDeclineCallTap: widget.onDeclineCallTap,
          );
    } else if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return widget.outgoingCallBuilder?.call(context, call, _callState) ??
          StreamOutgoingCallContent(
            call: call,
            callState: _callState,
            onCancelCallTap: widget.onCancelCallTap,
          );
    } else {
      return widget.callContentBuilder?.call(context, call, _callState) ??
          StreamCallContent(
            call: call,
            callState: _callState,
            onBackPressed: widget.onBackPressed,
            onLeaveCallTap: widget.onLeaveCallTap,
          );
    }
  }

  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');
      call.connectOptions = widget.callConnectOptions;
      final result = await call.join();
      _logger.v(() => '[connect] completed: $result');
    } catch (e) {
      _logger.v(() => '[connect] failed: $e');
      await _leave();
    }
  }

  Future<void> _leave() async {
    _logger.d(() => '[leave] no args');
    // play tone
    final bool popped;
    if (mounted) {
      popped = await Navigator.maybePop(context);
    } else {
      popped = false;
    }
    _logger.v(() => '[leave] popped: $popped');
  }
}
