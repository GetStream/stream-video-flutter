import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

typedef LivestreamEndedBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

typedef LivestreamBackstageBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Creates a widget that allows a user to view a livestream.
///
/// By default, the widget has call controls and other elements including:
/// play/pause the stream, live/backstage indicator, participant count,
/// call duration, mute/unmute call, expand/contract livestream.
class LivestreamPlayer extends StatefulWidget {
  /// Creates a livestream player
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [muted] defines if the call is muted by default.
  ///
  /// * [showParticipantCount] defines if the call should show participant count.
  ///
  /// * [backButtonBuilder] allows you to build a back/close button for closing the livestream.
  ///
  /// * [allowDiagnostics] displays call diagnostics when the widget is double-tapped.
  const LivestreamPlayer({
    super.key,
    required this.call,
    this.muted = false,
    this.showParticipantCount = true,
    this.backButtonBuilder,
    this.livestreamEndedBuilder,
    this.livestreamBackstageBuilder,
    this.allowDiagnostics = false,
    this.onCallDisconnected,
    this.onRecordingTapped,
    this.onFullscreenTapped,
  });

  /// The livestream call to display.
  final Call call;

  /// Stores if the call should be muted by default
  final bool muted;

  /// Boolean to display participant count.
  ///
  /// Defaults to true.
  final bool showParticipantCount;

  /// [WidgetBuilder] used to build an action button on the top left side of
  /// the screen.
  final WidgetBuilder? backButtonBuilder;

  /// The builder used to create a custom widget when the livestream has ended.
  final LivestreamEndedBuilder? livestreamEndedBuilder;

  /// The builder used to create a custom widget when the livestream is in backstage mode.
  final LivestreamBackstageBuilder? livestreamBackstageBuilder;

  /// The action to perform when the call is disconnected. By default, it pops the current route.
  final void Function(CallDisconnectedProperties)? onCallDisconnected;

  /// The action to perform when the recording shown when livestream is ended is tapped.
  final FutureOr<void> Function(String)? onRecordingTapped;

  /// The action to perform when dfullscreen button is tapped.
  final VoidCallback? onFullscreenTapped;

  /// Boolean to allow a user to double-tap a call to see diagnostic data.
  ///
  /// Defaults to false.
  final bool allowDiagnostics;

  @override
  State<LivestreamPlayer> createState() => _LivestreamPlayerState();
}

class _LivestreamPlayerState extends State<LivestreamPlayer>
    with SingleTickerProviderStateMixin {
  final _logger = taggedLogger(tag: 'SV:LivestreamPlayer');
  StreamSubscription<CallState>? _callStateSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  late CallState _callState;

  /// Controls the visibility of diagnostic data.
  bool _isStatsVisible = false;

  /// Stores if the livestream is in cover or contain mode.
  bool _fullscreen = false;

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
      _callStateSubscription?.cancel();

      if (widget.onCallDisconnected != null) {
        final disconnectedStatus = callState.status as CallStatusDisconnected;
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
    final isBackstage = _callState.isBackstage;
    final hasEnded = _callState.endedAt != null;

    if (hasEnded) {
      return widget.livestreamEndedBuilder?.call(
            context,
            call,
            _callState,
          ) ??
          LivestreamEndedContent(
            call: call,
            onRecordingTapped: widget.onRecordingTapped,
          );
    }

    if (isBackstage) {
      return widget.livestreamBackstageBuilder?.call(
            context,
            call,
            _callState,
          ) ??
          LivestreamBackstageContent(
            callState: _callState,
          );
    }

    return GestureDetector(
      onDoubleTap: () {
        if (widget.allowDiagnostics) {
          setState(() {
            _isStatsVisible = !_isStatsVisible;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            LivestreamContent(
              call: call,
              callState: _callState,
              backButtonBuilder: widget.backButtonBuilder,
              displayDiagnostics: _isStatsVisible,
              videoFit: _fullscreen ? VideoFit.cover : VideoFit.contain,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<int>(
                stream: call.callDurationSecondsStream,
                builder: (context, snapshot) {
                  final duration = Duration(seconds: snapshot.data ?? 0);

                  return LivestreamInfo(
                    call: call,
                    callState: widget.call.state.value,
                    fullscreen: _fullscreen,
                    onFullscreenTapped: () {
                      if (widget.onFullscreenTapped != null) {
                        widget.onFullscreenTapped?.call();
                      } else {
                        setState(() {
                          _fullscreen = !_fullscreen;
                        });
                      }
                    },
                    duration: duration,
                    showParticipantCount: widget.showParticipantCount,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Joins a call.
  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');
      final connectOptions = CallConnectOptions(
        camera: TrackOption.disabled(),
        microphone: TrackOption.disabled(),
      );

      final result = await call.join(connectOptions: connectOptions);
      _logger.v(() => '[connect] completed: $result');
    } catch (e) {
      _logger.v(() => '[connect] failed: $e');
      await _leave();
    }
  }

  Future<void> _leave() async {
    _logger.d(() => '[leave] no args');
    await call.leave();
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
