import 'package:flutter/material.dart';

import '../../call_controls/call_control_option.dart';

/// Represents a set of controls the user can use on the calling screen
/// to accept/cancel the call, toggle their audio and video state.
class IncomingCallControls extends StatelessWidget {
  /// Creates a new instance of [IncomingCallControls].
  const IncomingCallControls({
    super.key,
    this.isMicrophoneEnabled = false,
    this.isCameraEnabled = false,
    required this.onAcceptCallTap,
    required this.onDeclineCallTap,
    required this.onMicrophoneTap,
    required this.onCameraTap,
  });

  /// If camera is enabled.
  final bool isCameraEnabled;

  /// If microphone is enabled.
  final bool isMicrophoneEnabled;

  /// The action to perform when the accept call button is tapped.
  final VoidCallback onAcceptCallTap;

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onDeclineCallTap;

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
                icon: const Icon(Icons.call_end_rounded),
                iconColor: Colors.white,
                backgroundColor: Colors.red,
                onPressed: onDeclineCallTap,
                padding: const EdgeInsets.all(24),
              ),
              CallControlOption(
                icon: const Icon(Icons.call_rounded),
                iconColor: Colors.white,
                backgroundColor: Colors.green,
                onPressed: onAcceptCallTap,
                padding: const EdgeInsets.all(24),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
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
          )
        ],
      ),
    );
  }
}
