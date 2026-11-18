// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Lobby switch for the HiFi audio policy.
///
/// The choice is applied before joining, so it cannot change once the call
/// has started.
class LobbyHiFiAudio extends StatelessWidget {
  const LobbyHiFiAudio({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: StreamLobbyViewTheme.of(context).cardBackgroundColor,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.graphic_eq,
              color: enabled
                  ? colorTheme.accentPrimary
                  : colorTheme.textLowEmphasis,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HiFi audio',
                  style: textTheme.bodyBold.copyWith(
                    color: colorTheme.textHighEmphasis,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Stereo playout, no echo cancellation',
                  style: textTheme.footnote.copyWith(
                    color: colorTheme.textLowEmphasis,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Plays remote audio in stereo when someone shares it. '
                  'On iOS, your microphone has to be muted.',
                  style: textTheme.footnote.copyWith(
                    color: colorTheme.textLowEmphasis,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeTrackColor: colorTheme.accentPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
