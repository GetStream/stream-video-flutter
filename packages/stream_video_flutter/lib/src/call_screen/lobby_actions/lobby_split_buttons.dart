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
    final unavailable = controller.microphoneUnavailable;

    return StreamAdaptiveMenuAnchor(
      title: translations.lobbyMicrophoneSection,
      sections: controller.devices.audioSections(context),
      // An unavailable device is not a user choice, so it is drawn disabled
      // with an error badge rather than in the destructive state a deliberate
      // mute gets. Both halves take a null callback because a split button
      // only takes on its disabled surface once neither half can be pressed —
      // and with no device there is nothing for the caret to offer anyway.
      builder: (context, handle) => CallButtonBadge(
        showErrorBadge: unavailable,
        child: StreamSplitButton.icon(
          leadingIcon: Icon(enabled ? icons.voiceFill : icons.voiceOffFill),
          trailingIcon: Icon(handle.isOpen ? icons.caretUp : icons.caretDown),
          variant: enabled || unavailable ? .regular : .destructive,
          leadingTooltip: translations.lobbyToggleMicrophone,
          trailingTooltip: translations.lobbySelectAudioDevices,
          onLeadingPressed: unavailable ? null : controller.toggleMicrophone,
          onTrailingPressed: unavailable ? null : handle.toggle,
        ),
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
    final unavailable = controller.cameraUnavailable;

    return StreamAdaptiveMenuAnchor(
      title: translations.lobbyCameraSection,
      sections: controller.devices.videoSections(context),
      // See StreamLobbyMicrophoneSplitButton.
      builder: (context, handle) => CallButtonBadge(
        showErrorBadge: unavailable,
        child: StreamSplitButton.icon(
          leadingIcon: Icon(enabled ? icons.videoFill : icons.videoOffFill),
          trailingIcon: Icon(handle.isOpen ? icons.caretUp : icons.caretDown),
          variant: enabled || unavailable ? .regular : .destructive,
          leadingTooltip: translations.lobbyToggleCamera,
          trailingTooltip: translations.lobbySelectVideoDevice,
          onLeadingPressed: unavailable ? null : controller.toggleCamera,
          onTrailingPressed: unavailable ? null : handle.toggle,
        ),
      ),
    );
  }
}
