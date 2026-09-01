// StreamSplitButton is still experimental in stream_core_flutter, and is
// exported from its video library rather than from core, which this package's
// barrel re-exports.
// ignore_for_file: experimental_member_use

import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/video.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Turns the lobby's microphone on and off, with a caret that picks which
/// microphone and speaker to use.
///
/// The caret opens a [StreamAdaptiveMenuAnchor], so it is a popup on desktop
/// and a bottom sheet on Android and iOS. The sections come from the same
/// [StreamMediaDevicesController] the settings lane's select inputs read, so
/// the two always agree.
class StreamLobbyMicrophoneSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneSplitButton].
  const StreamLobbyMicrophoneSplitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final icons = context.streamIcons;
    final translations = context.translations;
    final enabled = controller.microphoneEnabled;

    return StreamAdaptiveMenuAnchor(
      title: translations.lobbyMicrophoneSection,
      sections: controller.devices.audioSections(context),
      builder: (context, handle) => StreamSplitButton.icon(
        icon: Icon(enabled ? icons.voiceFill : icons.voiceOffFill),
        trailingIcon: Icon(handle.isOpen ? icons.caretUp : icons.caretDown),
        style: enabled ? .secondary : .destructive,
        tooltip: translations.lobbyToggleMicrophone,
        trailingTooltip: translations.lobbySelectAudioDevices,
        onPressed: controller.toggleMicrophone,
        onTrailingPressed: handle.toggle,
      ),
    );
  }
}

/// Turns the lobby's camera on and off, with a caret that picks which camera
/// to use. See [StreamLobbyMicrophoneSplitButton].
class StreamLobbyCameraSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyCameraSplitButton].
  const StreamLobbyCameraSplitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final icons = context.streamIcons;
    final translations = context.translations;
    final enabled = controller.cameraEnabled;

    return StreamAdaptiveMenuAnchor(
      title: translations.lobbyCameraSection,
      sections: controller.devices.videoSections(context),
      builder: (context, handle) => StreamSplitButton.icon(
        icon: Icon(enabled ? icons.videoFill : icons.videoOffFill),
        trailingIcon: Icon(handle.isOpen ? icons.caretUp : icons.caretDown),
        style: enabled ? .secondary : .destructive,
        tooltip: translations.lobbyToggleCamera,
        trailingTooltip: translations.lobbySelectVideoDevice,
        onPressed: controller.toggleCamera,
        onTrailingPressed: handle.toggle,
      ),
    );
  }
}
