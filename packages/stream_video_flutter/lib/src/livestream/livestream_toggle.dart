import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'livestream_speakerphone_option.dart';

class LivestreamToggle extends StatelessWidget {
  const LivestreamToggle({
    super.key,
    required this.enabled,
    required this.onStateChanged,
  });

  final bool enabled;
  final VoidCallback onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: onStateChanged,
        iconSize: 64,
        icon: AnimatedCrossFade(
          firstChild: const Icon(
            Icons.pause_rounded,
            color: Colors.white,
          ),
          secondChild: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
          ),
          crossFadeState:
              enabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
