import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Picks which microphone and speaker the call will use.
///
/// Opens the same sections as [StreamLobbyMicrophoneSplitButton] over the same
/// [StreamMediaDevicesController], so a lobby showing both keeps them in step.
///
/// Stays visible but disabled until the microphone has been opened once: the
/// platform only names devices after `getUserMedia` has succeeded, and hiding
/// the field would shift the layout the moment permission is granted.
class StreamLobbyMicrophoneSelect extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneSelect].
  const StreamLobbyMicrophoneSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final translations = context.translations;
    final opened = controller.hasOpenedMicrophone;

    return _DeviceSelect(
      title: translations.lobbyMicrophoneSection,
      sections: controller.devices.audioSections(context),
      icon: context.streamIcons.voiceFill,
      value: controller.devices.selectedAudioInput?.label,
      enabled: opened,
      tooltip: opened
          ? translations.lobbySelectAudioDevices
          : translations.lobbyMicrophonePermissionRequired,
    );
  }
}

/// Picks which camera the call will use. See [StreamLobbyMicrophoneSelect].
class StreamLobbyCameraSelect extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyCameraSelect].
  const StreamLobbyCameraSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final translations = context.translations;
    final opened = controller.hasOpenedCamera;

    return _DeviceSelect(
      title: translations.lobbyCameraSection,
      sections: controller.devices.videoSections(context),
      icon: context.streamIcons.videoFill,
      value: controller.devices.selectedVideoInput?.label,
      enabled: opened,
      tooltip: opened
          ? translations.lobbySelectVideoDevice
          : translations.lobbyCameraPermissionRequired,
    );
  }
}

/// A select field opening a device menu.
class _DeviceSelect extends StatelessWidget {
  const _DeviceSelect({
    required this.title,
    required this.sections,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.tooltip,
  });

  final String title;
  final List<StreamMenuSection> sections;
  final IconData icon;
  final String? value;
  final bool enabled;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    // Nothing to pick from, so the field has nothing to open.
    final noChoice = sections.every((section) => section.options.isEmpty);

    return StreamAdaptiveMenuAnchor(
      title: title,
      sections: sections,
      // A field is a wide anchor, and a narrow popup under it reads as
      // belonging to something else.
      matchAnchorWidth: true,
      builder: (context, handle) => Tooltip(
        message: tooltip,
        child: StreamSelectInput(
          leading: Icon(icon),
          value: value,
          hintText: context.translations.lobbyDefaultDeviceHint,
          // True for a sheet as well as a popup, so the caret points the same
          // way on every platform.
          expanded: handle.isOpen,
          onPressed: enabled && !noChoice ? handle.toggle : null,
        ),
      ),
    );
  }
}
