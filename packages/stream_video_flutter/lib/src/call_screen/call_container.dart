// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Builder used to create a custom incoming call widget.
///
/// Replaced by the simplified [CallWidgetBuilder].
@Deprecated('Use CallWidgetBuilder instead.')
typedef IncomingCallBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom outgoing call widget.
///
/// Replaced by the simplified [CallWidgetBuilder].
@Deprecated('Use CallWidgetBuilder instead.')
typedef OutgoingCallBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom call content widget.
///
/// Replaced by the simplified [CallWidgetBuilder].
@Deprecated('Use CallWidgetBuilder instead.')
typedef CallContentBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Builder used to create a custom widget for participants avatars.
///
/// Replaced by the simplified [CallWidgetBuilder].
@Deprecated('Use CallWidgetBuilder instead.')
typedef ParticipantsAvatarBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
  List<UserInfo> participants,
);

/// Builder used to create a custom widget for participants display names.
///
/// Replaced by the simplified [CallWidgetBuilder].
@Deprecated('Use CallWidgetBuilder instead.')
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
    this.callConnectOptions,
    this.onBackPressed,
    this.onLeaveCallTap,
    this.onAcceptCallTap,
    this.onDeclineCallTap,
    this.onCancelCallTap,
    this.onCallDisconnected,
    @Deprecated('Use [incomingCallWidgetBuilder] instead.')
    this.incomingCallBuilder,
    this.incomingCallWidgetBuilder,
    @Deprecated('Use [outgoingCallWidgetBuilder] instead.')
    this.outgoingCallBuilder,
    this.outgoingCallWidgetBuilder,
    @Deprecated('Use [callContentWidgetBuilder] instead.')
    this.callContentBuilder,
    this.callContentWidgetBuilder,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
  });

  /// Represents a call.
  final Call call;

  /// Options used while connecting to the call.
  final CallConnectOptions? callConnectOptions;

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

  /// The action to perform when the call is disconnected. By default, it pops the current route.
  final void Function(CallDisconnectedProperties)? onCallDisconnected;

  /// Builder used to create a custom incoming call widget.
  ///
  /// If [incomingCallBuilder] is provided, the whole [StreamCallContainer] widget will
  /// rebuild on every call state change.
  /// Recommend to use [incomingCallWidgetBuilder] which is not rebuild on every state change.
  @Deprecated('Use [incomingCallWidgetBuilder] instead.')
  final IncomingCallBuilder? incomingCallBuilder;

  /// Builder used to create a custom incoming call widget.
  final CallWidgetBuilder? incomingCallWidgetBuilder;

  /// Builder used to create a custom outgoing call widget.
  ///
  /// If [outgoingCallBuilder] is provided, the whole [StreamCallContainer] widget will
  /// rebuild on every call state change.
  /// Recommend to use [outgoingCallWidgetBuilder] which is not rebuild on every state change.
  @Deprecated('Use [outgoingCallWidgetBuilder] instead.')
  final OutgoingCallBuilder? outgoingCallBuilder;

  /// Builder used to create a custom outgoing call widget.
  final CallWidgetBuilder? outgoingCallWidgetBuilder;

  /// Builder used to create a custom call content widget.
  ///
  /// If [callContentBuilder] is provided, the whole [StreamCallContainer] widget will
  /// rebuild on every call state change.
  /// Recommend to use [callContentWidgetBuilder] which is not rebuild on every state change.
  @Deprecated('Use [callContentWidgetBuilder] instead.')
  final CallContentBuilder? callContentBuilder;

  /// Builder used to create a custom call content widget.
  final CallWidgetBuilder? callContentWidgetBuilder;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  bool get _shouldListenToCallState =>
      incomingCallBuilder != null ||
      outgoingCallBuilder != null ||
      callContentBuilder != null;

  @override
  State<StreamCallContainer> createState() => _StreamCallContainerState();
}

class _StreamCallContainerState extends State<StreamCallContainer> {
  final _logger = taggedLogger(tag: 'SV:CallContainer');
  StreamSubscription<CallState>? _callStateSubscription;
  StreamSubscription<CallStatus>? _callStatusSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds all information about the call.
  CallState? _callState;

  /// Holds only status information about the call.
  late CallStatus _callStatus;

  @override
  void initState() {
    super.initState();
    _listenToCallStateIfNeeded();
    _listenToCallStatus();
    _connect();
  }

  @override
  void didUpdateWidget(StreamCallContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.call != widget.call) {
      _callStateSubscription?.cancel();
      _callStateSubscription = null;
      _callStatusSubscription?.cancel();
      _callStatusSubscription = null;

      _listenToCallStateIfNeeded();
      _listenToCallStatus();
    }
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    _callStateSubscription = null;
    _callStatusSubscription?.cancel();
    _callStatusSubscription = null;
    super.dispose();
  }

  void _listenToCallStateIfNeeded() {
    if (widget._shouldListenToCallState) {
      _callState = call.state.value;
      _callStateSubscription = call.state.listen(_setState);
    } else {
      _callState = null;
    }
  }

  void _listenToCallStatus() {
    _callStatus = call.state.value.status;
    _callStatusSubscription =
        call.partialState((state) => state.status).listen(_setStatus);
  }

  void _setState(CallState callState) {
    _logger.v(() => '[setState] callState.status: ${callState.status}');
    setState(() {
      _callState = callState;
    });
  }

  void _setStatus(CallStatus callStatus) {
    _logger.v(() => '[setStatus] callState.status: $callStatus');
    setState(() {
      _callStatus = callStatus;
    });

    if (callStatus.isDisconnected) {
      _callStateSubscription?.cancel();
      if (widget.onCallDisconnected != null) {
        final disconnectedStatus = callStatus as CallStatusDisconnected;
        final disconnectedProperties = CallDisconnectedProperties(
          reason: disconnectedStatus.reason,
          call: call,
        );
        widget.onCallDisconnected?.call(disconnectedProperties);
      } else {
        _leave();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _callStatus;
    _logger.v(() => '[build] status: $status');

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return _buildIncomingCall();
    }
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return _buildOutgoingCall();
    }
    return _buildCallContent();
  }

  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');

      final result = await call.join(connectOptions: widget.callConnectOptions);
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

  Widget _buildIncomingCall() {
    assert(
      _callState != null || widget.incomingCallBuilder == null,
      'Call state is supposed to be available to build the incoming call widget.',
    );

    return widget.incomingCallWidgetBuilder?.call(context, call) ??
        widget.incomingCallBuilder?.call(context, call, _callState!) ??
        StreamIncomingCallContent(
          call: call,
          callState: _callState,
          onAcceptCallTap: widget.onAcceptCallTap,
          onDeclineCallTap: widget.onDeclineCallTap,
        );
  }

  Widget _buildOutgoingCall() {
    assert(
      _callState != null || widget.outgoingCallBuilder == null,
      'Call state is supposed to be available to build the outgoing call widget.',
    );
    return widget.outgoingCallWidgetBuilder?.call(context, call) ??
        widget.outgoingCallBuilder?.call(context, call, _callState!) ??
        StreamOutgoingCallContent(
          call: call,
          callState: _callState,
          onCancelCallTap: widget.onCancelCallTap,
        );
  }

  Widget _buildCallContent() {
    assert(
      _callState != null || widget.callContentBuilder == null,
      'Call state is supposed to be available to build the call content widget.',
    );

    return widget.callContentWidgetBuilder?.call(context, call) ??
        widget.callContentBuilder?.call(context, call, _callState!) ??
        StreamCallContent(
          call: call,
          callState: _callState,
          onBackPressed: widget.onBackPressed,
          onLeaveCallTap: widget.onLeaveCallTap,
          pictureInPictureConfiguration: widget.pictureInPictureConfiguration,
        );
  }
}

class CallDisconnectedProperties {
  const CallDisconnectedProperties({
    required this.reason,
    required this.call,
  });

  final DisconnectReason reason;
  final Call call;
}
