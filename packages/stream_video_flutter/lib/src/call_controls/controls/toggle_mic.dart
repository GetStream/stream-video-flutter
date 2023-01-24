import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

class ToggleMic extends StatelessWidget {
  const ToggleMic({
    super.key,
    required this.participant,
    this.icon = Icons.mic_rounded,
    this.inactiveIcon = Icons.mic_off_rounded,
  });

  final IconData icon;
  final IconData inactiveIcon;
  final LocalParticipant participant;

  @override
  Widget build(BuildContext context) {
    final isMicEnabled = participant.isAudioEnabled;
    return CallControlOption(
      icon: isMicEnabled ? Icon(icon) : Icon(inactiveIcon),
      onPressed: () async {
        try {
          // Enable/disable the microphone.
          await participant.setMicrophoneEnabled(enabled: !isMicEnabled);
        } catch (_) {}
      },
    );
  }
}
