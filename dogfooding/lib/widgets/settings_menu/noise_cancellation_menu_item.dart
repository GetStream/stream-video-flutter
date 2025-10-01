import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../theme/app_palette.dart';
import 'standard_action_menu_item.dart';

class NoiseCancellationMenuItem extends StatefulWidget {
  const NoiseCancellationMenuItem({super.key, required this.call});

  final Call call;

  @override
  State<NoiseCancellationMenuItem> createState() =>
      _NoiseCancellationMenuItemState();
}

class _NoiseCancellationMenuItemState extends State<NoiseCancellationMenuItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.call.state.asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final callState = snapshot.data;

          if (callState == null ||
              callState.settings.audio.noiseCancellation?.mode ==
                  NoiceCancellationSettingsMode.disabled) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              StandardActionMenuItem(
                icon: callState.isAudioProcessing
                    ? Icons.hearing
                    : Icons.hearing_disabled,
                label: 'Toggle Noise Cancellation',
                trailing: Text(
                  callState.isAudioProcessing ? 'On' : 'Off',
                  style: TextStyle(
                    color: callState.isAudioProcessing
                        ? AppColorPalette.appGreen
                        : null,
                  ),
                ),
                onPressed: () {
                  if (!callState.isAudioProcessing) {
                    widget.call.startAudioProcessing();
                  } else {
                    widget.call.stopAudioProcessing();
                  }
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
