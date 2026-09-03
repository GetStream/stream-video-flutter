import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that allows to change the layout of the call.
class StreamLayoutButton extends StatefulWidget {
  /// Creates a new instance of [StreamLayoutButton].
  const StreamLayoutButton({
    super.key,
    required this.onLayoutModeChanged,
    this.initialLayout = ParticipantLayoutMode.grid,
  });

  /// The initial layout mode.
  final ParticipantLayoutMode initialLayout;

  /// Callback that is called when the layout mode is changed.
  final void Function(ParticipantLayoutMode) onLayoutModeChanged;

  @override
  State<StreamLayoutButton> createState() => _StreamLayoutButtonState();
}

class _StreamLayoutButtonState extends State<StreamLayoutButton> {
  ParticipantLayoutMode _layoutMode = ParticipantLayoutMode.grid;

  @override
  void initState() {
    super.initState();
    _layoutMode = widget.initialLayout;
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return CallControlButton(
      icon: Icon(
        _layoutMode == ParticipantLayoutMode.grid
            ? icons.gridFill
            : icons.speakerLeftFill,
      ),
      onPressed: () {
        _layoutMode = _layoutMode == ParticipantLayoutMode.grid
            ? ParticipantLayoutMode.spotlight
            : ParticipantLayoutMode.grid;

        widget.onLayoutModeChanged.call(_layoutMode);
        setState(() {});
      },
    );
  }
}

/// ToggleLayoutOption is [StreamLayoutButton] now.
@Deprecated(
  'ToggleLayoutOption is StreamLayoutButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleLayoutOption = StreamLayoutButton;
