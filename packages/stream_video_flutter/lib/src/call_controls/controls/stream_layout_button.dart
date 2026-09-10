import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that switches the call between a grid and a spotlight layout.
class StreamLayoutButton extends StatelessWidget {
  /// Creates a new instance of [StreamLayoutButton].
  const StreamLayoutButton({
    required this.onLayoutModeChanged,
    this.layout = ParticipantLayoutMode.grid,
    super.key,
  });

  /// The layout mode the button draws.
  final ParticipantLayoutMode layout;

  /// Callback that is called when the layout mode is changed.
  ///
  /// The button holds no state of its own, so the caller is expected to pass
  /// the new mode back in through [layout].
  final void Function(ParticipantLayoutMode) onLayoutModeChanged;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final isGrid = layout == ParticipantLayoutMode.grid;

    return CallControlButton(
      icon: Icon(isGrid ? icons.gridFill : icons.speakerLeftFill),
      onPressed: () => onLayoutModeChanged(
        isGrid ? ParticipantLayoutMode.spotlight : ParticipantLayoutMode.grid,
      ),
    );
  }
}

/// ToggleLayoutOption is [StreamLayoutButton] now.
@Deprecated(
  'ToggleLayoutOption is StreamLayoutButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleLayoutOption = StreamLayoutButton;
