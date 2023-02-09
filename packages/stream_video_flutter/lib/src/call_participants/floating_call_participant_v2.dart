import 'dart:math';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_participant_v2.dart';

/// PIP participant floating on top of the participants grid.
class StreamFloatingCallParticipantV2 extends StatelessWidget {
  const StreamFloatingCallParticipantV2({
    super.key,
    required this.call,
    required this.participant,
    this.theme,
  });

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
            child: StreamCallParticipantV2(
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
