import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Turns the lobby's microphone on and off.
///
/// Reads its state from [StreamLobbyScope], so it can be dropped into a
/// `StreamLobbyActions` list without being wired up.
class StreamLobbyMicrophoneToggle extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneToggle].
  const StreamLobbyMicrophoneToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final icons = context.streamIcons;
    final enabled = controller.microphoneEnabled;
    final unavailable = controller.microphoneUnavailable;

    return CallControlButton(
      icon: Icon(enabled ? icons.voiceFill : icons.voiceOffFill),
      // An unavailable device is not a user choice, so it is badged rather
      // than drawn in the negative state a deliberate mute gets.
      state: enabled || unavailable ? .neutral : .negative,
      showErrorBadge: unavailable,
      tooltip: context.translations.lobbyToggleMicrophone,
      // Only a device the platform does not report at all is unpressable. A
      // failed open stays pressable, because retrying is what clears it.
      onPressed: controller.microphoneMissing
          ? null
          : controller.toggleMicrophone,
    );
  }
}

/// Turns the lobby's camera on and off. See
/// [StreamLobbyMicrophoneToggle].
class StreamLobbyCameraToggle extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyCameraToggle].
  const StreamLobbyCameraToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final icons = context.streamIcons;
    final enabled = controller.cameraEnabled;
    final unavailable = controller.cameraUnavailable;

    return CallControlButton(
      icon: Icon(enabled ? icons.videoFill : icons.videoOffFill),
      // See StreamLobbyMicrophoneToggle.
      state: enabled || unavailable ? .neutral : .negative,
      showErrorBadge: unavailable,
      tooltip: context.translations.lobbyToggleCamera,
      onPressed: controller.cameraMissing ? null : controller.toggleCamera,
    );
  }
}
