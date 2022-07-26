import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:stream_video/stream_video.dart';

class StreamVideoTrackRenderer extends StatelessWidget {
  final StreamVideoTrack track;
  const StreamVideoTrackRenderer(this.track, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoTrackRenderer(track as VideoTrack);
  }
}
