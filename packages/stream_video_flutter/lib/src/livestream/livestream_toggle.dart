import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'livestream_speakerphone_option.dart';

class LivestreamToggle extends StatelessWidget {
  const LivestreamToggle({
    Key? key,
    required this.enabled,
    required this.onStateChanged,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: onStateChanged,
        iconSize: 64.0,
        icon: AnimatedCrossFade(
          firstChild: Icon(
            Icons.pause_rounded,
            color: Colors.white,
          ),
          secondChild: Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
          ),
          crossFadeState:
              enabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
