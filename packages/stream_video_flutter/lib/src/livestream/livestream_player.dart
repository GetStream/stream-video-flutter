import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

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
    this.allowDiagnostics = false,
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

  /// Stores the paused state of the stream.
  bool _livestreamEnabled = true;

  /// Stores if the livestream is in cover or contain mode.
  bool _fullscreen = false;

  /// Curved animation that stores the controller opacity.
  late Animation<double> _controllerAnimation;

  /// Animation controller for opacity animation.
  late AnimationController _animationController;

  /// Timer for updating duration.
  late Timer _durationTimer;

  /// Current duration of call.
  final ValueNotifier<Duration> _duration =
      ValueNotifier<Duration>(Duration.zero);

  @override
  void initState() {
    super.initState();
    _callStateSubscription = call.state.listen(_setState);
    _callState = call.state.value;
    _connect();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controllerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    final now = DateTime.now();
    final currentTime = now.millisecondsSinceEpoch;
    final startedAt = _callState.liveStartedAt?.millisecondsSinceEpoch ??
        _callState.createdAt?.millisecondsSinceEpoch ??
        now.millisecondsSinceEpoch;
    _duration.value = Duration(milliseconds: currentTime - startedAt);

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration.value = _duration.value + const Duration(seconds: 1);
    });
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    _callStateSubscription = null;
    _durationTimer.cancel();
    _duration.dispose();
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
    return GestureDetector(
      onTap: () {
        if (!_animationController.isAnimating) {
          if (_controllerAnimation.value == 1.0) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        }
      },
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
            Visibility(
              visible: _controllerAnimation.value != 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _controllerAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controllerAnimation.value,
                      child: child,
                    );
                  },
                  child: LivestreamToggle(
                    enabled: _livestreamEnabled,
                    onStateChanged: () {
                      final streamingParticipants = _callState.callParticipants
                          .where((e) => e.isVideoEnabled)
                          .toList();

                      if (streamingParticipants.isEmpty) return;

                      final livestreamingParticipant =
                          streamingParticipants.first;

                      livestreamingParticipant.publishedTracks
                          .forEach((key, value) {
                        final tracks = call
                            .getTracks(livestreamingParticipant.trackIdPrefix);

                        for (final e in tracks) {
                          _livestreamEnabled ? e.disable() : e.enable();
                        }
                      });

                      setState(() {
                        _livestreamEnabled = !_livestreamEnabled;
                      });
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _controllerAnimation.value != 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _controllerAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controllerAnimation.value,
                      child: child,
                    );
                  },
                  child: ValueListenableBuilder<Duration>(
                    valueListenable: _duration,
                    builder: (context, duration, _) {
                      return LivestreamInfo(
                        call: call,
                        callState: widget.call.state.value,
                        fullscreen: _fullscreen,
                        onStateChanged: () {
                          setState(() {
                            _fullscreen = !_fullscreen;
                          });
                        },
                        duration: duration,
                        showParticipantCount: widget.showParticipantCount,
                      );
                    },
                  ),
                ),
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
