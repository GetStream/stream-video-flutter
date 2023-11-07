import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class LivestreamInfo extends StatelessWidget {
  const LivestreamInfo({
    Key? key,
    required this.callState,
  }) : super(key: key);

  final CallState callState;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        children: [
          Text('Live'),
          Text(callState.callParticipants.length.toString()),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_mute),
          ),
        ],
      ),
    );
  }
}
