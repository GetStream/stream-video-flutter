import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/standard_action_menu_item.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:collection/collection.dart';

class ChooseAudioOutputMenuItem extends StatelessWidget {
  const ChooseAudioOutputMenuItem({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.headphones,
          label: 'Choose audio output',
          onPressed: onPressed,
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
  final Function(RtcMediaDevice) onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = audioOutputDevice.id.equalsIgnoreCase(deviceIdSpeaker);

    return Column(
      children: [
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: enabled ? Icons.speaker : Icons.headphones,
          label: 'Speaker',
          onPressed: () {
            var device = audioOutputs.firstWhereOrNull(
              (it) => it.id.equalsIgnoreCase(
                !enabled ? deviceIdSpeaker : deviceIdEarpiece,
              ),
            );
            if (device != null) onPressed(device);
          },
          trailing: Text(
            enabled ? 'On' : 'Off',
            style: TextStyle(
              color: enabled ? AppColorPalette.appGreen : null,
            ),
          ),
        ),
      ],
    );
  }
}

extension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}
