import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'standard_action_menu_item.dart';

class ChooseAudioOutputMenuItem extends StatelessWidget {
  const ChooseAudioOutputMenuItem({
    required this.onPressed,
    this.selectedLabel,
    super.key,
  });

  final VoidCallback onPressed;

  /// Label of the currently selected audio output, shown as a trailing hint.
  final String? selectedLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.headphones,
          label: 'Choose audio output',
          onPressed: onPressed,
          trailing: selectedLabel == null
              ? null
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    selectedLabel!,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.textSecondary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class ToggleAudioOutputMenuItem extends StatelessWidget {
  const ToggleAudioOutputMenuItem({
    required this.audioOutputDevice,
    required this.audioOutputs,
    required this.onPressed,
    super.key,
  });

  final RtcMediaDevice audioOutputDevice;
  final List<RtcMediaDevice> audioOutputs;
  final void Function(RtcMediaDevice) onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;
    final enabled = audioOutputDevice.id.equalsIgnoreCase(deviceIdSpeaker);

    return Column(
      children: [
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: enabled ? Icons.speaker : Icons.headphones,
          label: 'Speaker',
          onPressed: () {
            final device = audioOutputs.firstWhereOrNull(
              (it) => it.id.equalsIgnoreCase(
                !enabled ? deviceIdSpeaker : deviceIdEarpiece,
              ),
            );
            if (device != null) onPressed(device);
          },
          trailing: Text(
            enabled ? 'On' : 'Off',
            style: TextStyle(color: enabled ? colorScheme.accentSuccess : null),
          ),
        ),
      ],
    );
  }
}

extension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}
