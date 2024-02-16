import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../theme/stream_icons.dart';

/// A widget that allows to change the layout of the call.
class ToggleLayoutOption extends StatefulWidget {
  /// Creates a new instance of [ToggleLayoutOption].
  const ToggleLayoutOption({
    super.key,
    required this.onLayoutModeChanged,
    this.initialLayout = ParticipantLayoutMode.grid,
  });

  /// The initial layout mode.
  final ParticipantLayoutMode initialLayout;

  /// Callback that is called when the layout mode is changed.
  final void Function(ParticipantLayoutMode) onLayoutModeChanged;

  @override
  State<ToggleLayoutOption> createState() => _ToggleLayoutOptionState();
}

class _ToggleLayoutOptionState extends State<ToggleLayoutOption> {
  ParticipantLayoutMode _layoutMode = ParticipantLayoutMode.grid;

  @override
  void initState() {
    super.initState();
    _layoutMode = widget.initialLayout;
  }

  @override
  Widget build(BuildContext context) {
    return CallControlOption(
      icon: Icon(
        _layoutMode == ParticipantLayoutMode.grid
            ? StreamIcons.grid
            : StreamIcons.spotlight,
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
