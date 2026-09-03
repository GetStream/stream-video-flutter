// StreamSplitButton is still experimental in stream_core_flutter, and is
// exported from its video library rather than from core, which this package's
// barrel re-exports.
// ignore_for_file: experimental_member_use

import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/video.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'apply_device_change.dart';
import 'call_button_badge.dart';

/// Turns the microphone on and off, with a caret that picks which microphone
/// and speaker to use.
///
/// The caret opens a [StreamAdaptiveMenuAnchor], so it is a popup on desktop
/// and a bottom sheet on Android and iOS.
///
/// Driven by the call it is given: the button reads that call's microphone
/// state, mutes and unmutes it, and disables itself when the platform reports
/// no microphone. Use [StreamMicrophoneSplitButton.withDevices] where the
/// state and the action are the caller's — in a lobby, where nobody has joined
/// yet.
///
/// {@tool snippet}
///
/// ```dart
/// StreamMicrophoneSplitButton(
///   call: call,
///   // A control bar along the bottom of a call opens its menus upwards.
///   menuDirection: StreamMenuDirection.up,
/// )
/// ```
/// {@end-tool}
class StreamMicrophoneSplitButton extends StatelessWidget {
  /// Creates a control over [call]'s microphone.
  ///
  /// A device controller is built for the call and disposed here unless
  /// [devices] supplies one.
  const StreamMicrophoneSplitButton({
    super.key,
    required Call call,
    this.devices,
    this.menuDirection = StreamMenuDirection.down,
    this.stopTrackOnMute,
    this.onError,
  }) : _call = call,
       _enabled = null,
       _onPressed = null,
       _unavailable = false;

  /// Creates a control whose state and action are the caller's.
  ///
  /// [devices] is required and stays the caller's to dispose. Reach for this
  /// where the microphone being toggled is not a call's — a lobby preview —
  /// or where pressing it has to do something other than mute the call.
  const StreamMicrophoneSplitButton.withDevices({
    super.key,
    required StreamMediaDevicesController this.devices,
    required bool enabled,
    VoidCallback? onPressed,
    bool unavailable = false,
    this.menuDirection = StreamMenuDirection.down,
  }) : _call = null,
       _enabled = enabled,
       _onPressed = onPressed,
       _unavailable = unavailable,
       stopTrackOnMute = null,
       onError = null;

  final Call? _call;
  final bool? _enabled;
  final VoidCallback? _onPressed;
  final bool _unavailable;

  /// The device lists and the current selection, shared with anything else
  /// offering the same choice.
  ///
  /// Optional alongside a call, where one is built for it otherwise. Pass
  /// the same controller to every picker on a screen — a settings menu's
  /// selects as well as this caret — so they never disagree about which
  /// device is in use.
  final StreamMediaDevicesController? devices;

  /// Which way the caret expects its menu to open.
  ///
  /// A control bar along the bottom of a call opens upwards; the default suits
  /// a control with room below it.
  final StreamMenuDirection menuDirection;

  /// Whether muting stops and releases the audio track, or keeps it and
  /// sends silence.
  ///
  /// Null leaves the call's own default, which stops the track. Pass false to
  /// keep it alive, which is what speaking-while-muted detection needs on iOS
  /// and macOS. Only meaningful alongside a call:
  /// [StreamMicrophoneSplitButton.withDevices] does its own muting.
  final bool? stopTrackOnMute;

  /// Called when the call refuses to mute or unmute. See
  /// [ToggleMicrophoneOption.onError].
  ///
  /// Null under [StreamMicrophoneSplitButton.withDevices], where pressing the
  /// button is the caller's own `onPressed` and there is no result to report.
  final ValueChanged<Object>? onError;

  @override
  Widget build(BuildContext context) {
    Widget shape({
      required StreamMediaDevicesController devices,
      required bool enabled,
      required bool unavailable,
      required VoidCallback? onPressed,
    }) {
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

    if (_call case final call?) {
      return _CallDevices(
        call: call,
        devices: devices,
        builder: (context, devices) {
          final unavailable = devices.reportsNo(devices.audioInputs);

          return PartialCallStateBuilder<bool>(
            call: call,
            selector: (state) =>
                state.localParticipant?.isAudioEnabled ?? false,
            builder: (context, enabled) => shape(
              devices: devices,
              enabled: enabled,
              unavailable: unavailable,
              // Badging is appearance only, so a microphone the platform
              // does not report has to be disabled here as well.
              onPressed: unavailable
                  ? null
                  : () => applyDeviceChange(
                      call.setMicrophoneEnabled(
                        enabled: !enabled,
                        stopTrackOnMute: stopTrackOnMute,
                      ),
                      description:
                          'turn the microphone ${enabled ? 'off' : 'on'}',
                      onError: onError,
                    ),
            ),
          );
        },
      );
    }

    return shape(
      devices: devices!,
      enabled: _enabled!,
      unavailable: _unavailable,
      onPressed: _onPressed,
    );
  }
}

/// Turns the camera on and off, with a caret that picks which camera to use.
/// See [StreamMicrophoneSplitButton].
class StreamCameraSplitButton extends StatelessWidget {
  /// Creates a control over [call]'s camera. See
  /// [StreamMicrophoneSplitButton.new].
  const StreamCameraSplitButton({
    super.key,
    required Call call,
    this.devices,
    this.menuDirection = StreamMenuDirection.down,
    this.onError,
  }) : _call = call,
       _enabled = null,
       _onPressed = null,
       _unavailable = false;

  /// Creates a control whose state and action are the caller's. See
  /// [StreamMicrophoneSplitButton.withDevices].
  const StreamCameraSplitButton.withDevices({
    super.key,
    required StreamMediaDevicesController this.devices,
    required bool enabled,
    VoidCallback? onPressed,
    bool unavailable = false,
    this.menuDirection = StreamMenuDirection.down,
  }) : _call = null,
       _enabled = enabled,
       _onPressed = onPressed,
       _unavailable = unavailable,
       onError = null;

  final Call? _call;
  final bool? _enabled;
  final VoidCallback? _onPressed;
  final bool _unavailable;

  /// The device lists and the current selection. See
  /// [StreamMicrophoneSplitButton.devices].
  final StreamMediaDevicesController? devices;

  /// Which way the caret expects its menu to open. See
  /// [StreamMicrophoneSplitButton.menuDirection].
  final StreamMenuDirection menuDirection;

  /// Called when the call refuses to turn the camera on or off. See
  /// [StreamMicrophoneSplitButton.onError].
  final ValueChanged<Object>? onError;

  @override
  Widget build(BuildContext context) {
    Widget shape({
      required StreamMediaDevicesController devices,
      required bool enabled,
      required bool unavailable,
      required VoidCallback? onPressed,
    }) {
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

    if (_call case final call?) {
      return _CallDevices(
        call: call,
        devices: devices,
        builder: (context, devices) {
          final unavailable = devices.reportsNo(devices.videoInputs);

          return PartialCallStateBuilder<bool>(
            call: call,
            selector: (state) =>
                state.localParticipant?.isVideoEnabled ?? false,
            builder: (context, enabled) => shape(
              devices: devices,
              enabled: enabled,
              unavailable: unavailable,
              onPressed: unavailable
                  ? null
                  : () => applyDeviceChange(
                      call.setCameraEnabled(enabled: !enabled),
                      description: 'turn the camera ${enabled ? 'off' : 'on'}',
                      onError: onError,
                    ),
            ),
          );
        },
      );
    }

    return shape(
      devices: devices!,
      enabled: _enabled!,
      unavailable: _unavailable,
      onPressed: _onPressed,
    );
  }
}

/// Supplies a [StreamMediaDevicesController] for [call], and rebuilds
/// [builder] as its lists and selection change.
///
/// Borrows [devices] when one is given and owns one otherwise, following
/// `StreamLobbyView` and its controller: a widget that made the controller
/// disposes it, and one that was handed a controller leaves it alone.
class _CallDevices extends StatefulWidget {
  const _CallDevices({
    required this.call,
    required this.devices,
    required this.builder,
  });

  final Call call;
  final StreamMediaDevicesController? devices;
  final Widget Function(
    BuildContext context,
    StreamMediaDevicesController devices,
  )
  builder;

  @override
  State<_CallDevices> createState() => _CallDevicesState();
}

class _CallDevicesState extends State<_CallDevices> {
  StreamMediaDevicesController? _owned;

  StreamMediaDevicesController get _devices =>
      widget.devices ??
      (_owned ??= StreamMediaDevicesController.forCall(widget.call));

  @override
  void didUpdateWidget(_CallDevices oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A controller made here drives the call it was made for, and is redundant
    // once one is supplied.
    final stale = widget.devices != null || widget.call != oldWidget.call;
    if (_owned case final owned? when stale) {
      owned.dispose();
      _owned = null;
    }
  }

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devices = _devices;

    // Listening to the devices as well as the call: whether the platform has
    // a microphone at all arrives on the device stream, not in call state.
    return ListenableBuilder(
      listenable: devices,
      builder: (context, _) => widget.builder(context, devices),
    );
  }
}

extension on StreamMediaDevicesController {
  /// Whether the platform has been asked and named nothing in [devices].
  ///
  /// Waits for [StreamMediaDevicesController.hasEnumerated]: the lists are
  /// empty before the first enumeration because nothing has been asked, and a
  /// control that read them straight away would badge itself on startup.
  bool reportsNo(List<RtcMediaDevice> devices) =>
      hasEnumerated && devices.isEmpty;
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
    final noChoice = sections.hasNoOptions;

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
      // An unavailable device is not a user choice, so it is badged rather
      // than drawn in the destructive state a deliberate mute gets. Whether
      // the leading half can be pressed is the caller's to say — a failed
      // open is worth retrying — while the caret follows what it has to
      // offer, which is nothing when the platform named no device.
      builder: (context, handle) => CallButtonBadge(
        showErrorBadge: unavailable,
        child: StreamSplitButton.icon(
          leadingIcon: Icon(icon),
          trailingIcon: Icon(caret(isOpen: handle.isOpen)),
          variant: enabled || unavailable ? .regular : .destructive,
          leadingTooltip: tooltip,
          trailingTooltip: trailingTooltip,
          onLeadingPressed: onPressed,
          onTrailingPressed: noChoice ? null : handle.toggle,
        ),
      ),
    );
  }
}
