import 'package:flutter/material.dart';

import '../../call_controls/call_control_option.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CallControlOption(
                icon: isMicrophoneEnabled
                    ? const Icon(Icons.mic_rounded)
                    : const Icon(Icons.mic_off_rounded),
                padding: const EdgeInsets.all(16),
                onPressed: onMicrophoneTap,
              ),
              CallControlOption(
                icon: isCameraEnabled
                    ? const Icon(Icons.videocam_rounded)
                    : const Icon(Icons.videocam_off_rounded),
                padding: const EdgeInsets.all(16),
                onPressed: onCameraTap,
              ),
            ],
          ),
          CallControlOption(
            icon: const Icon(Icons.call_end_rounded),
            iconColor: Colors.white,
            backgroundColor: Colors.red,
            onPressed: onCancelCallTap,
            padding: const EdgeInsets.all(24),
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
