import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'input/stream_select_input.dart';
import 'menu/stream_context_menu_anchor.dart';
import 'menu/stream_context_menu_heading.dart';
import 'menu/stream_radio_indicator.dart';

/// The audio and camera device pickers shown on the lobby screen.
///
/// Owns device discovery (see [RtcMediaDeviceNotifier]) and renders a
/// [StreamSelectInput] per field: the audio field picks both the microphone
/// and the speaker, the camera field picks the video input. Selection itself is
/// controlled by the parent, which needs it to build the `CallConnectOptions`
/// on join.
///
/// Fields for devices we have no permission for stay visible but are disabled,
/// so the lobby layout does not shift once permission is granted.
class LobbyDeviceControls extends StatefulWidget {
  const LobbyDeviceControls({
    super.key,
    required this.microphoneEnabled,
    required this.cameraEnabled,
    required this.selectedAudioInput,
    required this.selectedAudioOutput,
    required this.selectedVideoInput,
    required this.onAudioInputSelected,
    required this.onAudioOutputSelected,
    required this.onVideoInputSelected,
  });

  /// Whether the microphone picker can be opened.
  ///
  /// Device labels are only populated once `getUserMedia` succeeded, so the
  /// parent gates this on having microphone permission.
  final bool microphoneEnabled;

  /// Whether the camera picker can be opened.
  final bool cameraEnabled;

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
    final spacing = context.streamSpacing;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        spacing: spacing.xs,
        mainAxisAlignment: .center,
        children: [
          Expanded(
            child: _DeviceMenuAnchor(
              enabled: widget.microphoneEnabled,
              tooltip: widget.microphoneEnabled
                  ? 'Select audio devices'
                  : 'Microphone permission is required to select audio devices',
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
          ),
          Expanded(
            child: _DeviceMenuAnchor(
              enabled: widget.cameraEnabled,
              tooltip: widget.cameraEnabled
                  ? 'Select video input device'
                  : 'Camera permission is required to select a video device',
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
          ),
        ],
      ),
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

/// A select field that opens a menu of device [sections], separated by dividers.
class _DeviceMenuAnchor extends StatefulWidget {
  const _DeviceMenuAnchor({
    required this.enabled,
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.sections,
  });

  /// Whether the field can be pressed to open the menu.
  final bool enabled;

  final String tooltip;
  final IconData icon;

  /// The text on the field, or `null` to show the placeholder.
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
    return StreamContextMenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      onOpen: () => setState(() => _isOpen = true),
      onClose: () {
        if (mounted) setState(() => _isOpen = false);
      },
      menuChildren: StreamContextMenuAction.sectioned(
        sections: [
          for (final section in widget.sections)
            [
              StreamContextMenuHeading(label: Text(section.heading)),
              _DeviceMenuItem(
                label: 'System default',
                selected: section.selectedDevice == null,
                onTap: () => _select(section, null),
              ),
              for (final device in section.devices)
                _DeviceMenuItem(
                  label: device.label.isNotEmpty ? device.label : device.id,
                  selected: device.id == section.selectedDevice?.id,
                  onTap: () => _select(section, device),
                ),
            ],
        ],
      ),
      builder: (context, controller, child) {
        return Tooltip(
          message: widget.tooltip,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: StreamSelectInput(
              leading: Icon(widget.icon),
              value: widget.label,
              hintText: 'Default',
              expanded: _isOpen,
              onPressed: widget.enabled
                  ? () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    }
                  : null,
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
      leading: StreamRadioIndicator(selected: selected),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
