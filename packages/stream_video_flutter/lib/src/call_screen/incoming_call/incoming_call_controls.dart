import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

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
    final icons = context.streamIcons;

    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CallControlButton(
                icon: Icon(icons.phoneDownFill),
                tone: .negative,
                onPressed: onDeclineCallTap,
              ),
              CallControlButton(
                icon: Icon(icons.phoneFill),
                tone: .positive,
                onPressed: onAcceptCallTap,
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CallControlButton(
                icon: Icon(
                  isMicrophoneEnabled ? icons.voiceFill : icons.voiceOffFill,
                ),
                tone: isMicrophoneEnabled ? .neutral : .negative,
                onPressed: onMicrophoneTap,
              ),
              CallControlButton(
                icon: Icon(
                  isCameraEnabled ? icons.videoFill : icons.videoOffFill,
                ),
                tone: isCameraEnabled ? .neutral : .negative,
                onPressed: onCameraTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
