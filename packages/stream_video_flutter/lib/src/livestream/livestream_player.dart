import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_screen/call_diagnostics_content/call_diagnostics_content.dart';
import 'livestream_info.dart';

class LivestreamPlayer extends StatefulWidget {
  const LivestreamPlayer({
    super.key,
    required this.call,
    this.muted = false,
    this.showParticipantCount = true,
  });

  final Call call;
  final bool muted;
  final bool showParticipantCount;

  @override
  State<LivestreamPlayer> createState() => _LivestreamPlayerState();
}

class _LivestreamPlayerState extends State<LivestreamPlayer> {
  final _logger = taggedLogger(tag: 'SV:LivestreamPlayer');
  StreamSubscription<CallState>? _callStateSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  late CallState _callState;

  bool loading = false;
  bool error = false;

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

  int updated = 0;

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
    return Scaffold(
      body: Stack(
        children: [
          LivestreamContent(
            call: call,
            callState: _callState,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LivestreamInfo(
              call: call,
              callState: widget.call.state.value,
            ),
          ),
        ],
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

class LivestreamContent extends StatefulWidget {
  const LivestreamContent({
    Key? key,
    required this.call,
    required this.callState,
  }) : super(key: key);

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  final CallState callState;

  @override
  State<LivestreamContent> createState() => _LivestreamContentState();
}

class _LivestreamContentState extends State<LivestreamContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  CallState get callState => widget.callState;

  /// Controls the visibility of [CallDiagnosticsContent].
  bool _isStatsVisible = false;

  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget;
    if (callState.status.isConnected) {
      final participant =
          callState.callParticipants.where((e) => e.isVideoEnabled).first;

      bodyWidget = StreamCallParticipant(
        // We use the sessionId as the key to avoid rebuilding the widget
        // when the participant changes.
        key: ValueKey(participant.sessionId),
        call: call,
        participant: participant,
        showConnectionQualityIndicator: false,
        showParticipantLabel: false,
        showSpeakerBorder: false,
        videoFit: VideoFit.contain,
      );
    } else {
      final isReconnecting = callState.status.isReconnecting;
      bodyWidget = Center(
        child: Text(isReconnecting ? 'Reconnecting' : 'Connecting'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0XFF272A30),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: _toggleStatsVisibility,
            child: bodyWidget,
          ),
          Visibility(
            visible: _isStatsVisible,
            child: CallDiagnosticsContent(
              call: call,
              onClosePressed: _toggleStatsVisibility,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStatsVisibility() {
    if (kDebugMode) {
      setState(() {
        _isStatsVisible = !_isStatsVisible;
      });
    }
  }
}
