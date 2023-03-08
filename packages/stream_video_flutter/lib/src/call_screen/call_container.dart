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
    _connect();
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.cancelAll();
  }

  void _setState(CallState callState) {
    _logger.v(() => '[setState] callState.status: ${callState.status}');
    setState(() {
      _callState = callState;
    });
    if (callState.status.isDrop) {
      _disconnect();
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
      call.setInitialCallOptions(widget.callConnectOptions);
      final result = await call.connect();
      if (result.isFailure) {
        await _onCancelCall();
      }
    } catch (e) {
      await _onCancelCall();
    }
  }

  Future<void> _onCancelCall() async {
    _logger.d(() => '[onCancelCall] no args');
    await call.apply(const CancelCall());
    await _disconnect();
  }

  Future<void> _disconnect() async {
    _logger.d(() => '[disconnect] no args');
    await call.disconnect();
    final popped = await Navigator.maybePop(context);
    _logger.v(() => '[disconnect] popped: $popped');
  }
}
