import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'connection_failure_section.dart';

/// The developer options on the large control bar: a menu of ways to break the
/// call on purpose, to see how it recovers.
///
/// On smaller screens the same options sit in the more menu.
class DeveloperOptionsMenu extends StatelessWidget {
  const DeveloperOptionsMenu({
    required this.call,
    this.snackbarMessenger,
    super.key,
  });

  final Call call;

  /// Shows what was simulated above the control bar.
  final StreamSnackbarMessenger? snackbarMessenger;

  @override
  Widget build(BuildContext context) {
    final failures = connectionFailureSection(
      call,
      messenger: snackbarMessenger,
    );

    return StreamAdaptiveMenuAnchor(
      title: 'Developer options',
      // The control bar runs along the bottom of the call.
      direction: StreamMenuDirection.up,
      sections: [
        // Open rather than folded: it is the only section in this menu.
        StreamMenuSection(heading: failures.heading, options: failures.options),
      ],
      builder: (context, handle) => CallFeatureButton(
        icon: Icon(context.streamIcons.command),
        tooltip: 'Developer options',
        selected: handle.isOpen,
        onPressed: handle.toggle,
      ),
    );
  }
}
