import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_controls_v2.dart';

class ToggleCameraV2 extends StatelessWidget {
  const ToggleCameraV2({
    super.key,
    required this.call,
    required this.localParticipant,
    this.icon = Icons.videocam_rounded,
    this.inactiveIcon = Icons.videocam_off_rounded,
  });

  final IconData icon;
  final IconData inactiveIcon;
  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final trackState = localParticipant.publishedTracks[SfuTrackType.video];
    final isEnabled = trackState != null && !trackState.muted;

    return CallControlOption(
      icon: isEnabled ? Icon(icon) : Icon(inactiveIcon),
      onPressed: () {
        call.apply(
          SetCameraEnabled(enabled: !isEnabled),
        );
      },
    );
  }
}
