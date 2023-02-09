import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_controls.dart';

class ToggleMic extends StatelessWidget {
  const ToggleMic({
    super.key,
    required this.call,
    required this.localParticipant,
    this.icon = Icons.mic_rounded,
    this.inactiveIcon = Icons.mic_off_rounded,
  });

  final IconData icon;
  final IconData inactiveIcon;

  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final trackState = localParticipant.publishedTracks[SfuTrackType.audio];
    final isMicEnabled = trackState != null && !trackState.muted;

    return CallControlOption(
      icon: isMicEnabled ? Icon(icon) : Icon(inactiveIcon),
      onPressed: () {
        call.apply(
          SetMicrophoneEnabled(enabled: !isMicEnabled),
        );
      },
    );
  }
}
