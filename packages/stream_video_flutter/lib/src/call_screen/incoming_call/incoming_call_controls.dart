import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// The controls of the incoming ringing screen: answer and decline, over the
/// microphone and camera the call will be joined with.
class IncomingCallControls extends StatelessWidget {
  /// Creates a new instance of [IncomingCallControls].
  const IncomingCallControls({
    super.key,
    required this.style,
    this.isMicrophoneEnabled = false,
    this.isCameraEnabled = false,
    required this.onAcceptCallTap,
    required this.onDeclineCallTap,
    required this.onMicrophoneTap,
    required this.onCameraTap,
  });

  /// The resolved style of the screen these controls sit on.
  final StreamRingingCallStyle style;

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
    final translations = context.translations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: style.secondaryControlsSpacing!,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: style.controlsSpacing!,
          children: [
            CallRingingButton(
              icon: Icon(icons.phoneDownFill),
              tone: .negative,
              label: translations.ringingDecline,
              onPressed: onDeclineCallTap,
            ),
            CallRingingButton(
              icon: Icon(icons.phoneFill),
              tone: .positive,
              label: translations.ringingAccept,
              onPressed: onAcceptCallTap,
            ),
          ],
        ),
        // The call is joined with whatever these say, so they stay on a screen
        // the design draws without them.
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: context.streamSpacing.sm,
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
    );
  }
}
