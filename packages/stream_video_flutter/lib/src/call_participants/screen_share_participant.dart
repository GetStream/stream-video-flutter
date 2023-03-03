import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A widget that represents a participant in screen sharing mode.
class ScreenShareParticipant extends StatelessWidget {
  /// Creates a new instance of [ScreenShareParticipant].
  const ScreenShareParticipant({
    super.key,
    required this.call,
    required this.participant,
  });

  /// Represents a call.
  final Call call;

  /// The participant to display.
  final CallParticipantState participant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 112,
      child: StreamCallParticipant(
        call: call,
        participant: participant,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        connectionLevelAlignment: Alignment.topRight,
        userAvatarTheme: const StreamUserAvatarThemeData(
          constraints: BoxConstraints.tightFor(
            height: 50,
            width: 50,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
