import 'package:flutter/material.dart';
import 'package:stream_video_flutter/src/theme/themes.dart';

/// A toggle for pausing and resuming the livestream.
///
/// Meant to stop all video and audio tracks locally - this is done through
/// the [onStateChanged] parameter in the implementation and not in the widget.
class LivestreamToggle extends StatelessWidget {
  /// Creates a [LivestreamToggle].
  ///
  /// [enabled] decides the icon to be displayed.
  ///
  /// [onStateChanged] notifies the implementing widget that the
  /// state of the widget has changed.
  const LivestreamToggle({
    super.key,
    required this.enabled,
    required this.onStateChanged,
  });

  /// Whether the play/pause state is enabled.
  final bool enabled;

  /// Notifies the implementing widget of a requested state change.
  final VoidCallback onStateChanged;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final theme = streamVideoTheme.livestreamTheme;
    final colorTheme = StreamVideoTheme.of(context).colorTheme;
    final pauseIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.pauseIconTheme);
    final playIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.playIconTheme);

    return Center(
      child: IconButton(
        onPressed: onStateChanged,
        iconSize: theme.playPauseIconSize,
        icon: AnimatedCrossFade(
          firstChild: IconTheme(
            data: pauseIconTheme,
            child: Icon(
              Icons.pause_rounded,
              size: theme.playPauseIconSize,
            ),
          ),
          secondChild: IconTheme(
            data: playIconTheme,
            child: Icon(
              Icons.play_arrow_rounded,
              size: theme.playPauseIconSize,
            ),
          ),
          crossFadeState:
              enabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
