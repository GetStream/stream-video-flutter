import 'package:flutter/material.dart';

import 'package:stream_video_flutter/stream_video_flutter.dart';

class ScreenShareItem extends StatelessWidget {
  const ScreenShareItem({
    super.key,
    required this.participant,
    this.backgroundColor = const Color(0xFF272A30),
  });

  final Participant participant;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenShareTrack = participant.screenShareTrack;
    assert(screenShareTrack != null, 'Participant has no screen share track');

    return ColoredBox(
      color: backgroundColor,
      child: Builder(builder: (context) {
        final track = screenShareTrack?.track;

        if (track == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff005FFF),
            ),
          );
        }

        return InteractiveViewer(
          child: StreamVideoRenderer(
            videoTrack: track as VideoTrack,
            videoFit: VideoFit.contain,
          ),
        );
      }),
    );
  }
}
