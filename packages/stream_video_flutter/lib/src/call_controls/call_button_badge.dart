import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Overlays an error badge on the top-end corner of a call button.
///
/// Shared by [CallControlButton] and [CallFeatureButton] so the badge sits in
/// the same place on both.
class CallButtonBadge extends StatelessWidget {
  /// Creates a new instance of [CallButtonBadge].
  const CallButtonBadge({
    super.key,
    required this.showErrorBadge,
    required this.child,
  });

  /// Whether to draw the badge at all.
  final bool showErrorBadge;

  /// The button to badge.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!showErrorBadge) return child;

    return Stack(
      // The badge deliberately overhangs the button's box, so the stack must
      // not clip it away.
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -4,
          end: -4,
          child: StreamErrorBadge(size: .sm),
        ),
      ],
    );
  }
}
