import 'package:flutter/material.dart';

/// Lays a side panel out against the call's video grid.
///
/// Two shapes, chosen by [fullScreen]:
///
///  * Docked — the panel takes [width] from the trailing edge and [child]
///    shrinks to fill what is left, so the grid re-tiles beside it.
///  * Full screen — the panel covers [child] entirely, sliding in over it.
///
/// Both are driven by [animation], which runs 0 (closed) to 1 (open). The
/// widget itself holds no state — the caller owns the controller, and so also
/// owns when the panel is mounted and unmounted.
class CallSidePanelLayout extends StatelessWidget {
  /// Creates a layout showing [panel] against [child].
  const CallSidePanelLayout({
    super.key,
    required this.animation,
    required this.panel,
    required this.fullScreen,
    required this.child,
    this.width = 360,
    this.coveredTopExtent = 0,
  });

  /// Drives the panel's entrance and exit: 0 is closed, 1 is fully open.
  final Animation<double> animation;

  /// The panel to show, or null when there is nothing open or closing.
  final Widget? panel;

  /// Whether the panel covers [child] instead of standing beside it.
  final bool fullScreen;

  /// The width a docked panel takes from [child].
  ///
  /// Ignored when [fullScreen], where the panel takes everything.
  final double width;

  /// Height to re-add above [child] to replace chrome the panel has covered.
  ///
  /// A caller that hides its own chrome to make room for a full-screen panel
  /// hands back what it gave up, so [child] neither moves nor re-lays-out the
  /// moment a panel opens.
  ///
  /// Ignored unless [fullScreen], and unless there is a [panel] to make room
  /// for.
  final double coveredTopExtent;

  /// The call content the panel is shown against.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final panel = this.panel;

    if (!fullScreen) {
      return Row(
        // Stretch, so the panel fills the available height rather than
        // settling at its intrinsic one.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          if (panel != null)
            SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              // Start-aligned, so the panel's leading edge travels with the
              // growing box and the content slides in from the window's edge.
              alignment: AlignmentDirectional.topStart,
              // A fixed width inside the transition: the panel is laid out at
              // its final width throughout and only clipped, so a message
              // list or a chart never reflows mid-animation.
              child: SizedBox(width: width, child: panel),
            ),
        ],
      );
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: panel != null ? coveredTopExtent : 0),
          child: child,
        ),
        if (panel != null)
          Positioned.fill(
            child: SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1, 0), end: Offset.zero),
              ),
              child: panel,
            ),
          ),
      ],
    );
  }
}
