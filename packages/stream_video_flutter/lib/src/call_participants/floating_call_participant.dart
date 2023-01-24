import 'dart:math';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// PIP participant floating on top of the participants grid.
class StreamFloatingCallParticipant extends StatelessWidget {
  const StreamFloatingCallParticipant({
    super.key,
    required this.participant,
    this.theme,
  });

  /// The participant to display.
  final Participant participant;

  /// Theme for modifying the look of the window.
  final StreamFloatingCallParticipantTheme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).floatingCallParticipantTheme;
    final height = theme.height;
    final width = theme.width;
    final avatarSize = theme.avatarSize ?? min(height, width) / 2.5;
    final avatarBorderRadius =
        theme.avatarBorderRadius ?? BorderRadius.circular(avatarSize);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(8),
        width: width,
        height: height,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: StreamCallParticipant(
              participant: participant,
              theme: StreamCallParticipantTheme(
                avatarTheme: StreamAvatarTheme(
                  constraints: BoxConstraints.tightFor(
                    height: avatarSize,
                    width: avatarSize,
                  ),
                  borderRadius: avatarBorderRadius,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
