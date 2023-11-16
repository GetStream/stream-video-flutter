import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'livestream_content.dart';
import 'livestream_toggle.dart';

class LivestreamPlayer extends StatefulWidget {
  const LivestreamPlayer({
    super.key,
    required this.call,
    this.muted = false,
    this.showParticipantCount = true,
    this.backButtonBuilder,
    this.allowDiagnostics = false,
  });

  final Call call;
  final bool muted;
  final bool showParticipantCount;
  final WidgetBuilder? backButtonBuilder;
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

  bool loading = false;
  bool error = false;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;
  bool _livestreamEnabled = true;
  bool _fullscreen = false;

  late Animation<double> _controllerAnimation;
  late AnimationController _animationController;
  late Timer _durationTimer;
  final ValueNotifier<double> _duration = ValueNotifier<double>(0);

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
    _durationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // var currentTime = DateTime.now();
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
                      final livestreamingParticipant = _callState
                          .callParticipants
                          .where((e) => e.isVideoEnabled)
                          .first;

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
                  child: LivestreamInfo(
                    call: call,
                    callState: widget.call.state.value,
                    fullscreen: _fullscreen,
                    onStateChanged: () {
                      setState(() {
                        _fullscreen = !_fullscreen;
                      });
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

  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');
      call.connectOptions = CallConnectOptions(
        camera: TrackOption.disabled(),
        microphone: TrackOption.disabled(),
      );
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
