import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A widget that renders a screen sharing track in the screen.
class ScreenShareItem extends StatelessWidget {
  /// Creates a new instance of [ScreenShareItem].
  const ScreenShareItem({
    super.key,
    required this.call,
    required this.participant,
    this.backgroundColor = const Color(0xFF272A30),
  });

  /// Represents a call.
  final CallV2 call;

  /// The participant that shares their screen.
  final CallParticipantStateV2 participant;

  /// The background color for the video.
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final screenShareTrack = participant.screenShareTrack;

    return ColoredBox(
      color: backgroundColor,
      child: Builder(
        builder: (context) {
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
              videoTrackType: SfuTrackType.screenShare,
            ),
          );
        },
      ),
    );
  }
}
