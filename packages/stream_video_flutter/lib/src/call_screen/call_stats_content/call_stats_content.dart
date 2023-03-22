import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

class CallStatsContent extends StatefulWidget {
  const CallStatsContent({
    super.key,
    required this.call,
    this.onClosePressed,
  });

  final Call call;
  final VoidCallback? onClosePressed;

  @override
  State<CallStatsContent> createState() => _CallStatsContentState();
}

class _CallStatsContentState extends State<CallStatsContent> {
  CallStats? _publisher;
  CallStats? _subscriber;

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
    final pubRemote = _publisher?.remote ?? '';
    final pubLocal = _publisher?.local ?? '';
    final subRemote = _subscriber?.remote ?? '';
    final subLocal = _subscriber?.local ?? '';
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
