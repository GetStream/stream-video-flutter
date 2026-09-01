import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Represents a set of controls the user can use on the calling screen
/// to cancel the call, toggle their audio and video state.
class OutgoingCallControls extends StatelessWidget {
  /// Creates a new instance of [OutgoingCallControls].
  const OutgoingCallControls({
    super.key,
    this.isMicrophoneEnabled = false,
    this.isCameraEnabled = false,
    required this.onCancelCallTap,
    required this.onMicrophoneTap,
    required this.onCameraTap,
  });

  /// If camera is enabled.
  final bool isCameraEnabled;

  /// If microphone is enabled.
  final bool isMicrophoneEnabled;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onCancelCallTap;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CallControlButton(
                icon: Icon(
                  isMicrophoneEnabled ? icons.voiceFill : icons.voiceOffFill,
                ),
                state: isMicrophoneEnabled ? .neutral : .negative,
                onPressed: onMicrophoneTap,
              ),
              CallControlButton(
                icon: Icon(
                  isCameraEnabled ? icons.videoFill : icons.videoOffFill,
                ),
                state: isCameraEnabled ? .neutral : .negative,
                onPressed: onCameraTap,
              ),
            ],
          ),
          CallControlButton(
            icon: Icon(icons.phoneDownFill),
            state: .negative,
            onPressed: onCancelCallTap,
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
