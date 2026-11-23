// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

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
    this.incomingCallWidgetBuilder,
    this.outgoingCallWidgetBuilder,
    this.callContentWidgetBuilder,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
    this.leaveCallOnDispose = true,
  });

  /// Represents a call.
  final Call call;

  /// Whether the container ends its call when it is disposed, for example
  /// when its route is popped with the back button.
  ///
  /// The container always joins [call] when it is first built, so this is the
  /// call it was given then, including one the app had already joined, such
  /// as a ringing call joined after an accept. An incoming call the user has
  /// not accepted is rejected; any other call is left.
  ///
  /// A left call cannot be joined again. Anything that disposes the container
  /// and builds a new one for the same call ends the call: a page without
  /// keep-alive in a `PageView` or `TabBarView`, an `AnimatedSwitcher`, a
  /// parent that changes type, or `pushReplacement` to another screen with
  /// the same call. Keep the container mounted, give it a `GlobalKey` when it
  /// moves in the tree, or set this to `false`.
  ///
  /// Set it to `false` also when the call should keep running after the
  /// container is gone, such as a call shown in an in-app
  /// picture-in-picture overlay. The app is then responsible for calling
  /// [Call.leave].
  final bool leaveCallOnDispose;

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
  final CallWidgetBuilder? incomingCallWidgetBuilder;

  /// Builder used to create a custom outgoing call widget.
  final CallWidgetBuilder? outgoingCallWidgetBuilder;

  /// Builder used to create a custom call content widget.
  final CallWidgetBuilder? callContentWidgetBuilder;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  @override
  State<StreamCallContainer> createState() => _StreamCallContainerState();
}

class _StreamCallContainerState extends State<StreamCallContainer> {
  final _logger = taggedLogger(tag: 'SV:CallContainer');
  StreamSubscription<CallStatus>? _callStatusSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds only status information about the call.
  late CallStatus _callStatus;

  /// Whether the call is over and this container still owes its route a pop.
  var _popPending = false;

  /// The call this container joined, which it leaves on dispose. It stays the
  /// first call when [StreamCallContainer.call] changes, since only that one
  /// was joined here.
  Call? _joinedCall;

  @override
  void initState() {
    super.initState();
    _listenToCallStatus();
    _connect();
  }

  @override
  void didUpdateWidget(StreamCallContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.call != widget.call) {
      _callStatusSubscription?.cancel();
      _callStatusSubscription = null;

      // A pop owed for the call that just left is not owed for this one: the
      // container has been given something to show again.
      _popPending = false;

      _listenToCallStatus();
    }
  }

  @override
  void dispose() {
    _callStatusSubscription?.cancel();
    _callStatusSubscription = null;

    final joinedCall = _joinedCall;
    if (widget.leaveCallOnDispose && joinedCall != null) {
      unawaited(_leaveOnDispose(joinedCall));
    }

    super.dispose();
  }

  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');

      // Recorded even when the app joined the call first, as the ringing flow
      // does after an accept: backing out of the screen should still end it.
      _joinedCall = call;
      final result = await call.join(connectOptions: widget.callConnectOptions);
      _logger.v(() => '[connect] completed: $result');

      if (result is Failure && result.error is CallLeftException) {
        _logger.w(
          () =>
              '[connect] the call was already left and cannot be joined '
              'again. A StreamCallContainer that is disposed leaves its call, '
              'so one remounted without a GlobalKey cannot rejoin it; keep it '
              'mounted, or pass leaveCallOnDispose: false.',
        );
      }
    } catch (e) {
      _logger.v(() => '[connect] failed: $e');
      await _leave();
    }
  }

  /// Ends [call] once the container is gone, so the call does not keep
  /// publishing audio and video behind a closed screen.
  ///
  /// An incoming call the user has not accepted is rejected rather than left:
  /// a leave does not tell the server, so the caller would keep ringing.
  Future<void> _leaveOnDispose(Call call) async {
    final status = call.state.value.status;
    if (status.isDisconnected) return;

    try {
      final Result<None> result;
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        _logger.d(() => '[dispose] rejecting call: ${call.callCid}');
        result = await call.reject(
          reason: CallRejectReason.decline(),
          initiator: LeaveInitiator.app,
        );
      } else {
        _logger.d(() => '[dispose] leaving call: ${call.callCid}');
        result = await call.leave(
          reason: const DisconnectReason.left(initiator: LeaveInitiator.app),
        );
      }
      if (result is Failure) {
        _logger.e(() => '[dispose] leave failed: $result');
      }
    } catch (e, stk) {
      _logger.e(() => '[dispose] leave failed: $e\n$stk');
    }
  }

  void _listenToCallStatus() {
    _callStatus = call.state.value.status;
    _callStatusSubscription = call
        .partialState((state) => state.status)
        .listen(_setStatus);
  }

  void _setStatus(CallStatus callStatus) {
    _logger.v(() => '[setStatus] callState.status: $callStatus');
    setState(() {
      _callStatus = callStatus;
    });

    if (callStatus.isDisconnected) {
      // A call disconnects once: anything after it must not call
      // onCallDisconnected, or leave, a second time.
      _callStatusSubscription?.cancel();
      _callStatusSubscription = null;
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

  Future<void> _leave() async {
    _logger.d(() => '[leave] no args');
    if (!mounted) {
      _logger.v(() => '[leave] popped: false');
      return;
    }

    // `maybePop` closes the topmost route, which is not always the one this
    // container is in: a dialog can sit above it, and so can another screen.
    // The call ending is not the user asking to leave whatever that is, so a
    // container that is not on top waits its turn instead. Null means there
    // is no route to reason about, which is left to `maybePop` as before.
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
      _logger.v(() => '[leave] not the top route; waiting to pop');
      _popPending = true;
      if (mounted) setState(() {});
      return;
    }

    _popPending = false;
    final popped = await Navigator.maybePop(context);
    _logger.v(() => '[leave] popped: $popped');
  }

  @override
  Widget build(BuildContext context) {
    final status = _callStatus;
    _logger.v(() => '[build] status: $status');

    if (_popPending) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(_leave());
        });
      }
    }

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return _buildIncomingCall();
    }
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return _buildOutgoingCall();
    }
    return _buildCallContent();
  }

  Widget _buildIncomingCall() {
    return widget.incomingCallWidgetBuilder?.call(context, call) ??
        StreamIncomingCallContent(
          call: call,
          onAcceptCallTap: widget.onAcceptCallTap,
          onDeclineCallTap: widget.onDeclineCallTap,
        );
  }

  Widget _buildOutgoingCall() {
    return widget.outgoingCallWidgetBuilder?.call(context, call) ??
        StreamOutgoingCallContent(
          call: call,
          onCancelCallTap: widget.onCancelCallTap,
        );
  }

  Widget _buildCallContent() {
    return widget.callContentWidgetBuilder?.call(context, call) ??
        StreamCallContent(
          call: call,
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
