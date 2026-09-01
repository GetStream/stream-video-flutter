import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Builds the device menu the lobby's audio and camera controls share.
///
/// Both the caret of a split button and the body of a select input open the
/// same sections over the same [StreamMediaDevicesController], which is what
/// keeps the two in step: picking a microphone in one is immediately visible
/// in the other.
extension LobbyDeviceMenus on StreamMediaDevicesController {
  /// The microphone group, plus a speaker group where the platform has one.
  List<StreamMenuSection> audioSections(BuildContext context) {
    final translations = context.translations;

    return [
      if (audioInputs.isNotEmpty)
        StreamMenuSection(
          heading: translations.lobbyMicrophoneSection,
          options: _options(
            context,
            devices: audioInputs,
            selected: selectedAudioInput,
            onSelected: selectAudioInput,
          ),
        ),
      // Platforms that route audio themselves (iOS, Android) report no output
      // devices; there is nothing to pick from there.
      if (audioOutputs.isNotEmpty)
        StreamMenuSection(
          heading: translations.lobbySpeakerSection,
          options: _options(
            context,
            devices: audioOutputs,
            selected: selectedAudioOutput,
            onSelected: selectAudioOutput,
          ),
        ),
    ];
  }

  /// The camera group.
  List<StreamMenuSection> videoSections(BuildContext context) => [
    if (videoInputs.isNotEmpty)
      StreamMenuSection(
        heading: context.translations.lobbyCameraSection,
        options: _options(
          context,
          devices: videoInputs,
          selected: selectedVideoInput,
          onSelected: selectVideoInput,
        ),
      ),
  ];

  List<StreamMenuOption> _options(
    BuildContext context, {
    required List<RtcMediaDevice> devices,
    required RtcMediaDevice? selected,
    required ValueChanged<RtcMediaDevice?> onSelected,
  }) => [
    // "System default" means "let the platform pick". A section is only built
    // where there is something to pick from, so this is never the lone entry
    // in a menu that cannot do anything.
    StreamMenuOption(
      label: context.translations.lobbySystemDefaultDevice,
      selected: selected == null,
      onSelected: () => onSelected(null),
    ),
    for (final device in devices)
      StreamMenuOption(
        // A device the platform will not name is still pickable; its id is
        // the only handle there is.
        label: device.label.isNotEmpty ? device.label : device.id,
        selected: device.id == selected?.id,
        onSelected: () => onSelected(device),
      ),
  ];
}
