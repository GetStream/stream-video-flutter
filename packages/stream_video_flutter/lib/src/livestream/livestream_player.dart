import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'livestream_info.dart';

// Maybe tomorrow:

// Check if call container updates as much as livestreams
// Check how participants grid keeps the track subscribed

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
    final livestreamingParticipant =
        _callState.callParticipants.where((e) => e.isVideoEnabled).first;

    return Scaffold(
      body: Stack(
        children: [
          StreamVideoRenderer(
            key: ValueKey(livestreamingParticipant.sessionId),
            call: widget.call,
            participant: livestreamingParticipant,
            videoTrackType: SfuTrackType.video,
            onSizeChanged: (size) {},
            placeholderBuilder: (context) {
              return Text('Placeholder');
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LivestreamInfo(
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
