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

typedef LivestreamControlsBuilder = Widget Function(
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
  /// * [showParticipantCount] defines if the call should show participant count.
  ///
  /// * [backButtonBuilder] allows you to build a back/close button for closing the livestream.
  ///
  /// * [videoPlaceholderBuilder] allows you to build a video placeholder for the
  /// video renderer. This is useful when the video is not available or
  /// disconnected. By default, it uses the [StreamUserAvatar] widget
  ///
  /// * [livestreamHostsUnavailableBuilder] allows you to build a custom widget when
  /// a livestream is connected but no hosts have video enabled.
  ///
  /// * [livestreamNotConnectedBuilder] allows you to build a custom widget when
  /// the livestream is not connected. Provides connection state information.
  ///
  /// * [videoRendererBuilder] allows you to build a custom video renderer
  ///
  /// * [allowDiagnostics] displays call diagnostics when the widget is double-tapped.
  const LivestreamPlayer({
    super.key,
    required this.call,
    this.showParticipantCount = true,
    this.backButtonBuilder,
    this.livestreamEndedBuilder,
    this.livestreamBackstageBuilder,
    this.livestreamControlsBuilder,
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.livestreamHostsUnavailableBuilder,
    this.livestreamNotConnectedBuilder,
    this.allowDiagnostics = false,
    this.onCallDisconnected,
    this.onRecordingTapped,
    this.onFullscreenTapped,
    this.startInFullscreenMode = false,
  });

  /// The livestream call to display.
  final Call call;

  /// Boolean to display participant count.
  ///
  /// Defaults to true.
  final bool showParticipantCount;

  /// Determines whether the livestream should start in fullscreen mode.
  /// When true, the video will expand to cover the entire available space.
  /// When false, the video will be contained within its boundaries.
  /// Defaults to false.
  final bool startInFullscreenMode;

  /// [WidgetBuilder] used to build an action button on the top left side of
  /// the screen.
  final WidgetBuilder? backButtonBuilder;

  /// The builder used to create a custom widget when the livestream has ended.
  final LivestreamEndedBuilder? livestreamEndedBuilder;

  /// The builder used to create a custom widget when the livestream is in backstage mode.
  final LivestreamBackstageBuilder? livestreamBackstageBuilder;

  /// The builder used to create custom controls for the livestream player.
  /// This allows customization of the control UI elements displayed during the livestream.
  final LivestreamControlsBuilder? livestreamControlsBuilder;

  /// Builder function used to build a video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Builder function used to create a custom widget when a livestream is connected
  /// but no hosts have video enabled.
  final LivestreamHostsUnavailableBuilder? livestreamHostsUnavailableBuilder;

  /// Builder function used to create a custom widget when the livestream is not connected.
  /// Provides connection state information (isMigrating, isReconnecting) that can be
  /// used to show appropriate status messages.
  final LivestreamNotConnectedBuilder? livestreamNotConnectedBuilder;

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
    _fullscreen = widget.startInFullscreenMode;

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
              videoPlaceholderBuilder: widget.videoPlaceholderBuilder,
              videoRendererBuilder: widget.videoRendererBuilder,
              livestreamHostsUnavailableBuilder:
                  widget.livestreamHostsUnavailableBuilder,
              livestreamNotConnectedBuilder:
                  widget.livestreamNotConnectedBuilder,
              displayDiagnostics: _isStatsVisible,
              videoFit: _fullscreen ? VideoFit.cover : VideoFit.contain,
            ),
            widget.livestreamControlsBuilder?.call(context, call, _callState) ??
                Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder<Duration>(
                    stream: call.callDurationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;

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
