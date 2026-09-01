import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Turns the lobby's microphone on and off.
///
/// Reads its state from [StreamLobbyScope], so it can be dropped into a
/// `LobbyActions` list without being wired up.
class StreamLobbyMicrophoneToggle extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneToggle].
  const StreamLobbyMicrophoneToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final icons = context.streamIcons;
    final enabled = controller.microphoneEnabled;

    return CallControlButton(
      icon: Icon(enabled ? icons.voiceFill : icons.voiceOffFill),
      state: enabled ? .neutral : .negative,
      showErrorBadge: controller.microphoneError != null,
      tooltip: context.translations.lobbyToggleMicrophone,
      onPressed: controller.toggleMicrophone,
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

    return CallControlButton(
      icon: Icon(enabled ? icons.videoFill : icons.videoOffFill),
      state: enabled ? .neutral : .negative,
      showErrorBadge: controller.cameraError != null,
      tooltip: context.translations.lobbyToggleCamera,
      onPressed: controller.toggleCamera,
    );
  }
}
