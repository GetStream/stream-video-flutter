import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'settings_menu.dart';
import 'standard_action_menu_item.dart';

class ClosedCaptionsMenuItem extends StatelessWidget {
  const ClosedCaptionsMenuItem({super.key, required this.widget});

  final SettingsMenu widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.call.state,
      builder: (context, snapshot) {
        final colorScheme = StreamTheme.of(context).colorScheme;

        if (snapshot.hasData) {
          final callState = snapshot.data;

          if (callState == null ||
              callState.settings.transcription.closedCaptionMode ==
                  ClosedCaptionSettingsMode.disabled) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              StandardActionMenuItem(
                icon: callState.isCaptioning
                    ? Icons.closed_caption_sharp
                    : Icons.closed_caption_disabled_sharp,
                label: 'Toggle Closed Caption',
                trailing: Text(
                  callState.isCaptioning ? 'On' : 'Off',
                  style: TextStyle(
                    color: callState.isCaptioning
                        ? colorScheme.accentSuccess
                        : null,
                  ),
                ),
                onPressed: () {
                  if (!callState.isCaptioning) {
                    widget.call.startClosedCaptions();
                  } else {
                    widget.call.stopClosedCaptions();
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
