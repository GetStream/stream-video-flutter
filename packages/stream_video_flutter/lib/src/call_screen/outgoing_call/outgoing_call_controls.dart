import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// The controls of the outgoing ringing screen: the microphone and camera the
/// call will be placed with, over the button that cancels it.
class OutgoingCallControls extends StatelessWidget {
  /// Creates a new instance of [OutgoingCallControls].
  const OutgoingCallControls({
    super.key,
    required this.style,
    this.isMicrophoneEnabled = false,
    this.isCameraEnabled = false,
    required this.onCancelCallTap,
    required this.onMicrophoneTap,
    required this.onCameraTap,
  });

  /// The resolved style of the screen these controls sit on.
  final StreamRingingCallStyle style;

  /// If camera is enabled.
  final bool isCameraEnabled;

  /// If microphone is enabled.
  final bool isMicrophoneEnabled;

  /// The action to perform when the cancel call button is tapped.
  final VoidCallback onCancelCallTap;

  /// The action to perform when the microphone button is tapped.
  final VoidCallback onMicrophoneTap;

  /// The action to perform when the camera button is tapped.
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: style.secondaryControlsSpacing!,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: style.controlsSpacing!,
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
        CallRingingButton(
          icon: Icon(icons.phoneDownFill),
          tone: .negative,
          onPressed: onCancelCallTap,
        ),
      ],
    );
  }
}
