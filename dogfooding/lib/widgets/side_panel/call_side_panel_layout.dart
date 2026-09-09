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
/// widget itself holds no state: the call screen owns the controller, so the
/// same animation can also collapse the app bar.
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
  final double width;

  /// Height to re-add above [child] to replace chrome the panel has covered.
  ///
  /// A full-screen panel takes over the app bar's row as well, and without
  /// this the grid would jump up by that much — and re-tile — the moment a
  /// panel opened.
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
              // growing box and the content appears to slide in from the
              // window's edge rather than being wiped into place. End-aligned
              // would hold it still and merely uncover it.
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
          padding: EdgeInsets.only(top: coveredTopExtent),
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
