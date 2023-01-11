import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ToggleCamera extends StatelessWidget {
  const ToggleCamera({
    Key? key,
    required this.participant,
    this.icon = Icons.videocam_rounded,
    this.inactiveIcon = Icons.videocam_off_rounded,
  }) : super(key: key);

  final IconData icon;
  final IconData inactiveIcon;
  final LocalParticipant participant;

  @override
  Widget build(BuildContext context) {
    final isVideoEnabled = participant.isVideoEnabled;
    return CallControlOption(
      icon: isVideoEnabled ? Icon(icon) : Icon(inactiveIcon),
      onPressed: () async {
        try {
          // Enable/disable the video.
          await participant.setCameraEnabled(enabled: !isVideoEnabled);
        } catch (_) {}
      },
    );
  }
}
