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

  /// Null while the switch is inert.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;

    // The lobby lays its footer out at the join button's width.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(radius.lg),
        color: colorScheme.backgroundSurfaceCard,
        border: Border.all(color: colorScheme.borderSubtle),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          spacing: spacing.sm,
          children: [
            Icon(
              Icons.graphic_eq,
              color: enabled
                  ? colorScheme.accentPrimary
                  : colorScheme.textSecondary,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HiFi audio',
                    style: textTheme.bodyEmphasis.copyWith(
                      color: colorScheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Stereo playout, no echo cancellation',
                    style: textTheme.captionDefault.copyWith(
                      color: colorScheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Plays remote audio in stereo when someone shares it. '
                    'On iOS, your microphone has to be muted.',
                    style: textTheme.captionDefault.copyWith(
                      color: colorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              label: 'HiFi audio',
              child: StreamSwitch(value: enabled, onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
