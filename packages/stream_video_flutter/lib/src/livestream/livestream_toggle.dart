import 'package:flutter/material.dart';

import '../theme/themes.dart';

class LivestreamToggle extends StatelessWidget {
  const LivestreamToggle({
    super.key,
    required this.enabled,
    required this.onStateChanged,
  });

  final bool enabled;
  final VoidCallback onStateChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamLivestreamTheme.of(context);
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
            child: const Icon(
              Icons.pause_rounded,
            ),
          ),
          secondChild: IconTheme(
            data: playIconTheme,
            child: const Icon(
              Icons.play_arrow_rounded,
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
