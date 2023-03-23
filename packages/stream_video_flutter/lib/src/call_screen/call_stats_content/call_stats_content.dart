import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Represents the call stats UI mainly for the diagnostics purposes only.
class CallStatsContent extends StatefulWidget {
  /// Creates a new instance of [CallStatsContent].
  const CallStatsContent({
    super.key,
    required this.call,
    this.onClosePressed,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the close button is pressed.
  final VoidCallback? onClosePressed;

  @override
  State<CallStatsContent> createState() => _CallStatsContentState();
}

class _CallStatsContentState extends State<CallStatsContent> {

  /// Represents the publisher stats.
  CallStats? _publisher;

  /// Represents the subscriber stats.
  CallStats? _subscriber;

  /// Controls the subscription to the stats updates.
  StreamSubscription<CallStats>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.call.stats.listen((stats) {
      switch (stats.peerType) {
        case StreamPeerType.publisher:
          _publisher = stats;
          break;
        case StreamPeerType.subscriber:
          _subscriber = stats;
          break;
      }
      setState(() {});
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final pubRemote = _publisher?.printable.remote ?? '';
    final pubLocal = _publisher?.printable.local ?? '';
    final subRemote = _subscriber?.printable.remote ?? '';
    final subLocal = _subscriber?.printable.local ?? '';
    return ColoredBox(
      color: Colors.black38,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(16),
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => widget.onClosePressed?.call(),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const Text(
                      'PUBLISHER',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pubLocal,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      pubRemote,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const Text(
                      'SUBSCRIBER',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subLocal,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      subRemote,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
