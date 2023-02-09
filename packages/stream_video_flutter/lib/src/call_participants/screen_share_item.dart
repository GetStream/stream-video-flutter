import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

class ScreenShareItem extends StatelessWidget {
  const ScreenShareItem({
    super.key,
    required this.call,
    required this.participant,
    this.backgroundColor = const Color(0xFF272A30),
  });

  final CallV2 call;
  final CallParticipantStateV2 participant;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenShareTrack =
        participant.publishedTracks[SfuTrackType.screenShare];
    final theme = StreamVideoTheme.of(context);
    assert(screenShareTrack != null, 'Participant has no screen share track');

    return ColoredBox(
      color: backgroundColor,
      child: Builder(builder: (context) {
        if (screenShareTrack == null) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorTheme.accentPrimary,
            ),
          );
        }

        return InteractiveViewer(
          child: VideoTrackRenderer(
            call: call,
            participant: participant,
            // TODO
            // videoTrack: track as VideoTrack,
          ),
        );
      }),
    );
  }
}
