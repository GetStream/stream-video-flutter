import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Lays a side panel out against the call's video grid.
///
/// Two shapes, chosen by [fullScreen]:
///
///  * Docked — the panel takes [width] from the trailing edge and [child]
///    shrinks to fill what is left, so the grid re-tiles beside it.
///  * Full screen — the panel covers [child] entirely, sliding in over it.
///
/// On a half-open foldable the panel docks in the half past the fold instead,
/// whatever [fullScreen] says: the trailing half in the book posture, the
/// bottom half in tabletop, and [child] fills the other half. The two meet
/// with the grid's gap centred on the middle of the fold.
///
/// Both are driven by [animation], which runs 0 (closed) to 1 (open). The
/// caller owns the controller, and so also owns when the panel is mounted and
/// unmounted. Keep the widget at a stable position in the tree: the key that
/// carries [child] between the two shapes lives in this widget's state, so a
/// rebuild that replaces the state tears the call content down anyway.
class CallSidePanelLayout extends StatefulWidget {
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
  State<CallSidePanelLayout> createState() => _CallSidePanelLayoutState();
}

class _CallSidePanelLayoutState extends State<CallSidePanelLayout> {
  /// Carries the call content between the docked and full-screen shapes.
  ///
  /// The two shapes hang [CallSidePanelLayout.child] in different places, so
  /// without a global key crossing the boundary rebuilds it from scratch —
  /// which tears down every video renderer under it and blanks the call until
  /// the tracks decode a frame again.
  final _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamFoldBuilder(
      builder: (context, measurement) => switch (measurement.local) {
        final fold? => _buildAtFold(context, fold),
        null => _buildUnfolded(context),
      },
    );
  }

  /// The panel in the half past [fold], [CallSidePanelLayout.child] in the
  /// other.
  Widget _buildAtFold(BuildContext context, StreamLocalFold fold) {
    final panel = widget.panel;
    final child = KeyedSubtree(key: _childKey, child: widget.child);
    final axis = fold.axis;
    final rtl =
        axis == Axis.horizontal &&
        Directionality.of(context) == TextDirection.rtl;

    // The call and the panel meet half the grid's padding past the middle of
    // the fold, so the gap between the tiles and the card is that padding,
    // centred on the fold. Both have room inside their own edges, so they may
    // run into a hinge's reported width.
    final gridPadding =
        StreamCallParticipantsGridTheme.of(context).padding?.resolve(
          Directionality.of(context),
        ) ??
        EdgeInsets.all(context.streamSpacing.xs);
    final half =
        switch (axis) {
          Axis.horizontal => rtl ? gridPadding.left : gridPadding.right,
          Axis.vertical => gridPadding.bottom,
        } /
        2;
    final extent = rtl ? fold.center - half : fold.length - fold.center - half;

    // The call takes its final box as soon as the panel starts to move, and
    // the panel slides over its own half. Squeezing the call instead would
    // re-centre it on the fold on every frame, shrinking the tiles before
    // they grow.
    return AnimatedBuilder(
      animation: widget.animation,
      child: panel,
      builder: (context, panel) {
        final status = widget.animation.status;
        final open =
            panel != null &&
            (status == AnimationStatus.forward ||
                status == AnimationStatus.completed);
        final callExtent = fold.length - (open ? extent : 0);

        final (callRect, panelRect) = switch ((axis, rtl)) {
          (Axis.horizontal, false) => (
            Rect.fromLTWH(0, 0, callExtent, fold.size.height),
            Rect.fromLTWH(
              fold.length - extent,
              0,
              extent,
              fold.size.height,
            ),
          ),
          (Axis.horizontal, true) => (
            Rect.fromLTWH(
              fold.length - callExtent,
              0,
              callExtent,
              fold.size.height,
            ),
            Rect.fromLTWH(0, 0, extent, fold.size.height),
          ),
          (Axis.vertical, _) => (
            Rect.fromLTWH(0, 0, fold.size.width, callExtent),
            Rect.fromLTWH(0, fold.length - extent, fold.size.width, extent),
          ),
        };

        // From the window's edge: the trailing side in the book posture, the
        // bottom in tabletop.
        final from = switch ((axis, rtl)) {
          (Axis.horizontal, false) => const Offset(1, 0),
          (Axis.horizontal, true) => const Offset(-1, 0),
          (Axis.vertical, _) => const Offset(0, 1),
        };

        return Stack(
          children: [
            Positioned.fromRect(rect: callRect, child: child),
            if (panel != null)
              Positioned.fromRect(
                rect: panelRect,
                child: ClipRect(
                  child: FractionalTranslation(
                    translation: from * (1 - widget.animation.value),
                    child: panel,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildUnfolded(BuildContext context) {
    final panel = widget.panel;
    final child = KeyedSubtree(key: _childKey, child: widget.child);

    if (!widget.fullScreen) {
      return Row(
        // Stretch, so the panel fills the available height rather than
        // settling at its intrinsic one.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          if (panel != null)
            SizeTransition(
              sizeFactor: widget.animation,
              axis: Axis.horizontal,
              // Start-aligned, so the panel's leading edge travels with the
              // growing box and the content slides in from the window's edge.
              alignment: AlignmentDirectional.topStart,
              // A fixed width inside the transition: the panel is laid out at
              // its final width throughout and only clipped, so a message
              // list or a chart never reflows mid-animation.
              child: SizedBox(width: widget.width, child: panel),
            ),
        ],
      );
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: panel != null ? widget.coveredTopExtent : 0,
          ),
          child: child,
        ),
        if (panel != null)
          Positioned.fill(
            child: SlideTransition(
              position: widget.animation.drive(
                Tween(begin: const Offset(1, 0), end: Offset.zero),
              ),
              child: panel,
            ),
          ),
      ],
    );
  }
}
