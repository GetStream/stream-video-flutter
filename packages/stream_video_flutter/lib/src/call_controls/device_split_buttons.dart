// StreamSplitButton is still experimental in stream_core_flutter, and is
// exported from its video library rather than from core, which this package's
// barrel re-exports.
// ignore_for_file: experimental_member_use

import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/video.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// Turns the microphone on and off, with a caret that picks which microphone
/// and speaker to use.
///
/// The caret opens a [StreamAdaptiveMenuAnchor], so it is a popup on desktop
/// and a bottom sheet on Android and iOS. Nothing about it is specific to the
/// lobby: pass a [StreamMediaDevicesController] wired to a call — see
/// [StreamMediaDevicesController.forCall] — and it drives the call instead.
///
/// {@tool snippet}
///
/// ```dart
/// StreamMicrophoneSplitButton(
///   devices: devices,
///   enabled: isMicrophoneOn,
///   onPressed: toggleMicrophone,
/// )
/// ```
/// {@end-tool}
class StreamMicrophoneSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamMicrophoneSplitButton].
  const StreamMicrophoneSplitButton({
    super.key,
    required this.devices,
    required this.enabled,
    this.onPressed,
    this.unavailable = false,
    this.menuDirection = StreamMenuDirection.down,
  });

  /// The device lists and the current selection, shared with anything else
  /// offering the same choice.
  final StreamMediaDevicesController devices;

  /// Whether the microphone is on.
  final bool enabled;

  /// Turns the microphone on and off.
  final VoidCallback? onPressed;

  /// Whether the microphone cannot be used at all.
  ///
  /// Draws the control disabled with an error badge rather than in the state a
  /// deliberate mute gets, so a permission problem is not mistaken for a
  /// choice the user made.
  final bool unavailable;

  /// Which way the caret expects its menu to open.
  ///
  /// A control bar along the bottom of a call opens upwards; the default suits
  /// a control with room below it.
  final StreamMenuDirection menuDirection;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final translations = context.translations;

    return _DeviceSplitButton(
      title: translations.lobbyMicrophoneSection,
      sections: devices.audioSections(context),
      icon: enabled ? icons.voiceFill : icons.voiceOffFill,
      tooltip: translations.lobbyToggleMicrophone,
      trailingTooltip: translations.lobbySelectAudioDevices,
      enabled: enabled,
      unavailable: unavailable,
      onPressed: onPressed,
      menuDirection: menuDirection,
    );
  }
}

/// Turns the camera on and off, with a caret that picks which camera to use.
/// See [StreamMicrophoneSplitButton].
class StreamCameraSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamCameraSplitButton].
  const StreamCameraSplitButton({
    super.key,
    required this.devices,
    required this.enabled,
    this.onPressed,
    this.unavailable = false,
    this.menuDirection = StreamMenuDirection.down,
  });

  /// The device lists and the current selection.
  final StreamMediaDevicesController devices;

  /// Whether the camera is on.
  final bool enabled;

  /// Turns the camera on and off.
  final VoidCallback? onPressed;

  /// Whether the camera cannot be used at all. See
  /// [StreamMicrophoneSplitButton.unavailable].
  final bool unavailable;

  /// Which way the caret expects its menu to open. See
  /// [StreamMicrophoneSplitButton.menuDirection].
  final StreamMenuDirection menuDirection;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final translations = context.translations;

    return _DeviceSplitButton(
      title: translations.lobbyCameraSection,
      sections: devices.videoSections(context),
      icon: enabled ? icons.videoFill : icons.videoOffFill,
      tooltip: translations.lobbyToggleCamera,
      trailingTooltip: translations.lobbySelectVideoDevice,
      enabled: enabled,
      unavailable: unavailable,
      onPressed: onPressed,
      menuDirection: menuDirection,
    );
  }
}

/// The shape both split buttons share.
class _DeviceSplitButton extends StatelessWidget {
  const _DeviceSplitButton({
    required this.title,
    required this.sections,
    required this.icon,
    required this.tooltip,
    required this.trailingTooltip,
    required this.enabled,
    required this.unavailable,
    required this.onPressed,
    required this.menuDirection,
  });

  final String title;
  final List<StreamMenuSection> sections;
  final IconData icon;
  final String tooltip;
  final String trailingTooltip;
  final bool enabled;
  final bool unavailable;
  final VoidCallback? onPressed;
  final StreamMenuDirection menuDirection;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    // Nothing to pick from — a simulator with no camera, or permission not
    // granted yet, so the platform names no devices.
    final noChoice = sections.every((section) => section.options.isEmpty);

    // Closed, the caret points where the menu will appear; open, it points
    // back at the anchor, which is the way to close it again.
    IconData caret({required bool isOpen}) => switch ((menuDirection, isOpen)) {
      (StreamMenuDirection.down, false) => icons.caretDown,
      (StreamMenuDirection.down, true) => icons.caretUp,
      (StreamMenuDirection.up, false) => icons.caretUp,
      (StreamMenuDirection.up, true) => icons.caretDown,
    };

    return StreamAdaptiveMenuAnchor(
      title: title,
      sections: sections,
      direction: menuDirection,
      // An unavailable device is not a user choice, so it is drawn disabled
      // with an error badge rather than in the destructive state a deliberate
      // mute gets. Both halves take a null callback because a split button
      // only takes on its disabled surface once neither half can be pressed —
      // and with no device there is nothing for the caret to offer anyway.
      builder: (context, handle) => CallButtonBadge(
        showErrorBadge: unavailable,
        child: StreamSplitButton.icon(
          icon: Icon(icon),
          trailingIcon: Icon(caret(isOpen: handle.isOpen)),
          style: enabled || unavailable ? .secondary : .destructive,
          tooltip: tooltip,
          trailingTooltip: trailingTooltip,
          onPressed: unavailable ? null : onPressed,
          onTrailingPressed: unavailable || noChoice ? null : handle.toggle,
        ),
      ),
    );
  }
}
