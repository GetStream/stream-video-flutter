import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Represents the call stats UI mainly for the diagnostics purposes only.
class CallDiagnosticsContent extends StatefulWidget {
  /// Creates a new instance of [CallDiagnosticsContent].
  const CallDiagnosticsContent({
    super.key,
    required this.call,
    this.onClosePressed,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the close button is pressed.
  final VoidCallback? onClosePressed;

  @override
  State<CallDiagnosticsContent> createState() => _CallDiagnosticsContentState();
}

class _CallDiagnosticsContentState extends State<CallDiagnosticsContent> {
  final _logger = taggedLogger(tag: 'SV:DiagnosticsView');

  /// Represents the publisher stats.
  CallStats? _publisherStats;

  /// Represents the subscriber stats.
  CallStats? _subscriberStats;

  /// Controls the subscription to the stats updates.
  StreamSubscription<CallStats>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.call.stats.listen((stats) {
      // final local = stats.printable.local.substring(0, 28);
      // final remote = stats.printable.remote.substring(0, 28);
      // _logger.v(
      //   () => '[listenStats] #${stats.peerType}; '
      //       'local: $local, remote: $remote <<<<<<<<<<<<<<<<<<<<<<<<<<',
      // );
      switch (stats.peerType) {
        case StreamPeerType.publisher:
          _publisherStats = stats;
          break;
        case StreamPeerType.subscriber:
          _subscriberStats = stats;
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
    return ColoredBox(
      color: Colors.black45,
      child: Stack(
        children: [
          _CallStatsContent(
            publisherStats: _publisherStats,
            subscriberStats: _subscriberStats,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.cleaning_services_rounded,
                  color: Colors.white,
                ),
                onPressed: _onClearPressed,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _onSharePressed,
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => widget.onClosePressed?.call(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onClearPressed() async {
    try {
      _logger.d(() => '[onClearPressed] no args');
      final fileLogger = StreamLog().find<FileStreamLogger>();
      _logger.d(() => '[onClearPressed] fileLogger: $fileLogger');
      await fileLogger?.clear();
      _logger.v(() => '[onClearPressed] completed');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('LOGS CLEARED'),
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[onClearPressed] failed: $e; $stk');
    }
  }

  Future<void> _onSharePressed() async {
    try {
      _logger.d(() => '[onSharePressed] no args');
      final fileLogger = StreamLog().find<FileStreamLogger>();
      _logger.d(() => '[onSharePressed] fileLogger: $fileLogger');
      final result = await fileLogger?.share();
      _logger.v(() => '[onSharePressed] result: $result');
    } catch (e, stk) {
      _logger.e(() => '[onSharePressed] failed: $e; $stk');
    }
  }
}

/// Represents the publisher/subscriber stats.
class _CallStatsContent extends StatelessWidget {
  const _CallStatsContent({
    super.key,
    required this.publisherStats,
    required this.subscriberStats,
  });

  /// Represents the publisher stats.
  final CallStats? publisherStats;

  /// Represents the subscriber stats.
  final CallStats? subscriberStats;

  @override
  Widget build(BuildContext context) {
    final pubRemote = publisherStats?.printable.remote ?? '';
    final pubLocal = publisherStats?.printable.local ?? '';
    final subRemote = subscriberStats?.printable.remote ?? '';
    final subLocal = subscriberStats?.printable.local ?? '';
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.topLeft,
            child: _PubSubContent(
              title: 'PUBLISHER',
              local: pubLocal,
              remote: pubRemote,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.topLeft,
            child: _PubSubContent(
              title: 'SUBSCRIBER',
              local: subLocal,
              remote: subRemote,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// Represents the publisher/subscriber stats.
class _PubSubContent extends StatelessWidget {
  const _PubSubContent({
    super.key,
    required this.title,
    required this.remote,
    required this.local,
  });

  final String title;
  final String remote;
  final String local;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          local,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          remote,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
