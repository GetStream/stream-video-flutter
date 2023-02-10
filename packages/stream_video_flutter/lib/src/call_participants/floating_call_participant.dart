import 'dart:math';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Floating participant on top of the participants grid.
class StreamFloatingCallParticipant extends StatelessWidget {
  /// Creates a new instance of [StreamFloatingCallParticipant].
  const StreamFloatingCallParticipant({
    super.key,
    required this.call,
    required this.participant,
    this.theme,
  });

  /// Represents a call.
  final CallV2 call;

  /// The participant to display.
  final CallParticipantStateV2 participant;

  /// Theme for modifying the look of the window.
  final StreamFloatingCallParticipantTheme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).floatingCallParticipantTheme;
    final height = theme.floatingParticipantHeight;
    final width = theme.floatingParticipantWidth;
    final avatarSize = theme.avatarSize ?? min(height, width) / 2.5;
    final avatarBorderRadius =
        theme.avatarBorderRadius ?? BorderRadius.circular(avatarSize);

    return SafeArea(
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: StreamCallParticipant(
              call: call,
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
