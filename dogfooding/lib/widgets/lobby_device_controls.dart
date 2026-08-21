import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The audio and camera device pickers shown on the lobby screen.
///
/// Owns device discovery (see [RtcMediaDeviceNotifier]) and renders a
/// [MenuAnchor] per pill: the audio pill picks both the microphone and the
/// speaker, the camera pill picks the video input. Selection itself is
/// controlled by the parent, which needs it to build the `CallConnectOptions`
/// on join.
class LobbyDeviceControls extends StatefulWidget {
  const LobbyDeviceControls({
    super.key,
    required this.showMicrophone,
    required this.showCamera,
    required this.selectedAudioInput,
    required this.selectedAudioOutput,
    required this.selectedVideoInput,
    required this.onAudioInputSelected,
    required this.onAudioOutputSelected,
    required this.onVideoInputSelected,
  });

  /// Whether the microphone picker is shown.
  ///
  /// Device labels are only populated once `getUserMedia` succeeded, so the
  /// parent gates this on having microphone permission.
  final bool showMicrophone;

  /// Whether the camera picker is shown.
  final bool showCamera;

  /// The selected audio input, or `null` for the system default.
  final RtcMediaDevice? selectedAudioInput;

  /// The selected audio output, or `null` for the system default.
  final RtcMediaDevice? selectedAudioOutput;

  /// The selected video input, or `null` for the system default.
  final RtcMediaDevice? selectedVideoInput;

  final ValueChanged<RtcMediaDevice?> onAudioInputSelected;
  final ValueChanged<RtcMediaDevice?> onAudioOutputSelected;
  final ValueChanged<RtcMediaDevice?> onVideoInputSelected;

  @override
  State<LobbyDeviceControls> createState() => _LobbyDeviceControlsState();
}

class _LobbyDeviceControlsState extends State<LobbyDeviceControls> {
  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  StreamSubscription<List<RtcMediaDevice>>? _deviceChangeSubscription;

  List<RtcMediaDevice> _audioInputDevices = const [];
  List<RtcMediaDevice> _audioOutputDevices = const [];
  List<RtcMediaDevice> _videoInputDevices = const [];

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription = _deviceNotifier.onDeviceChange.listen(
      _handleDeviceChange,
    );
    unawaited(_deviceNotifier.enumerateDevices());
  }

  @override
  void dispose() {
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  void _handleDeviceChange(List<RtcMediaDevice> devices) {
    if (!mounted) return;

    final audioInputs = devices
        .where((device) => device.kind == RtcMediaDeviceKind.audioInput)
        .toList(growable: false);
    final audioOutputs = devices
        .where((device) => device.kind == RtcMediaDeviceKind.audioOutput)
        .toList(growable: false);
    final videoInputs = devices
        .where((device) => device.kind == RtcMediaDeviceKind.videoInput)
        .toList(growable: false);

    setState(() {
      _audioInputDevices = audioInputs;
      _audioOutputDevices = audioOutputs;
      _videoInputDevices = videoInputs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        if (widget.showMicrophone)
          _DeviceMenuAnchor(
            tooltip: 'Select audio devices',
            icon: icons.voiceFill,
            label: widget.selectedAudioInput?.label,
            sections: [
              _DeviceMenuSection(
                heading: 'Microphone',
                devices: _audioInputDevices,
                selectedDevice: widget.selectedAudioInput,
                onDeviceSelected: widget.onAudioInputSelected,
              ),
              // Platforms that route audio themselves (iOS, Android) report no
              // output devices; there is nothing to pick from there.
              if (_audioOutputDevices.isNotEmpty)
                _DeviceMenuSection(
                  heading: 'Speaker',
                  devices: _audioOutputDevices,
                  selectedDevice: widget.selectedAudioOutput,
                  onDeviceSelected: widget.onAudioOutputSelected,
                ),
            ],
          ),
        if (widget.showCamera)
          _DeviceMenuAnchor(
            tooltip: 'Select video input device',
            icon: icons.videoFill,
            label: widget.selectedVideoInput?.label,
            sections: [
              _DeviceMenuSection(
                heading: 'Camera',
                devices: _videoInputDevices,
                selectedDevice: widget.selectedVideoInput,
                onDeviceSelected: widget.onVideoInputSelected,
              ),
            ],
          ),
      ],
    );
  }
}

/// One radio group inside a device menu, e.g. "Microphone" or "Speaker".
class _DeviceMenuSection {
  const _DeviceMenuSection({
    required this.heading,
    required this.devices,
    required this.selectedDevice,
    required this.onDeviceSelected,
  });

  final String heading;
  final List<RtcMediaDevice> devices;
  final RtcMediaDevice? selectedDevice;
  final ValueChanged<RtcMediaDevice?> onDeviceSelected;
}

/// A pill button that opens a menu of device [sections], separated by dividers.
class _DeviceMenuAnchor extends StatefulWidget {
  const _DeviceMenuAnchor({
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.sections,
  });

  final String tooltip;
  final IconData icon;

  /// The text on the pill, or `null` to show the system default.
  final String? label;

  final List<_DeviceMenuSection> sections;

  @override
  State<_DeviceMenuAnchor> createState() => _DeviceMenuAnchorState();
}

class _DeviceMenuAnchorState extends State<_DeviceMenuAnchor> {
  final _menuController = MenuController();
  bool _isOpen = false;

  void _select(_DeviceMenuSection section, RtcMediaDevice? device) {
    // StreamContextMenuAction only pops when it sits inside a PopupRoute. A
    // MenuAnchor overlay is not a route, so the menu has to be closed here.
    _menuController.close();
    section.onDeviceSelected(device);
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      onOpen: () => setState(() => _isOpen = true),
      onClose: () {
        if (mounted) setState(() => _isOpen = false);
      },
      // Neutralize MenuAnchor's own Material panel so that StreamContextMenu
      // supplies the whole surface: background, border, radius and elevation.
      style: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      menuChildren: [
        ConstrainedBox(
          // StreamContextMenu sizes itself to its widest child, so bound it:
          // device labels can be arbitrarily long.
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 320,
            maxHeight: 360,
          ),
          child: StreamContextMenu(
            children: StreamContextMenuAction.sectioned(
              sections: [
                for (final section in widget.sections)
                  [
                    _MenuHeading(section.heading),
                    _DeviceMenuItem(
                      label: 'System default',
                      selected: section.selectedDevice == null,
                      onTap: () => _select(section, null),
                    ),
                    for (final device in section.devices)
                      _DeviceMenuItem(
                        label: device.label.isNotEmpty
                            ? device.label
                            : device.id,
                        selected: device.id == section.selectedDevice?.id,
                        onTap: () => _select(section, device),
                      ),
                  ],
              ],
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return Tooltip(
          message: widget.tooltip,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: StreamButton(
              style: .secondary,
              type: .outline,
              iconLeft: Icon(widget.icon),
              iconRight: Icon(_isOpen ? icons.caretUp : icons.caretDown),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Text(
                widget.label ?? 'Default',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A single device row, with a radio indicator marking the active device.
class _DeviceMenuItem extends StatelessWidget {
  const _DeviceMenuItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return StreamContextMenuAction<void>(
      onTap: onTap,
      leading: _RadioIndicator(selected: selected),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// The section heading of a menu, e.g. "Microphone".
class _MenuHeading extends StatelessWidget {
  const _MenuHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xs + spacing.xxs,
        vertical: spacing.xs,
      ),
      child: Text(
        text,
        style: textTheme.captionEmphasis.copyWith(
          color: colorScheme.textTertiary,
        ),
      ),
    );
  }
}

/// A radio button indicator. The design system has no radio component yet, so
/// this mirrors the `Radio Button` component from the design.
class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  static const _size = 16.0;
  static const _indicatorSize = 8.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colorScheme.accentPrimary : null,
        border: selected ? null : Border.all(color: colorScheme.borderDefault),
      ),
      child: selected
          ? Center(
              child: Container(
                width: _indicatorSize,
                height: _indicatorSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.textOnAccent,
                ),
              ),
            )
          : null,
    );
  }
}
