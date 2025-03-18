import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/settings_menu.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/standard_action_menu_item.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ClosedCaptionsMenuItem extends StatelessWidget {
  const ClosedCaptionsMenuItem({
    super.key,
    required this.widget,
  });

  final SettingsMenu widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.call.state.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final callState = snapshot.data as CallState;

            if (callState.settings.transcription.closedCaptionMode ==
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
                          ? AppColorPalette.appGreen
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
        });
  }
}
