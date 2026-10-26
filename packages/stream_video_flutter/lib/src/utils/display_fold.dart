import 'dart:ui' show DisplayFeatureState;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The fold or hinge that splits the window of [context] into a left and a
/// right half, in window coordinates, or null when there is none.
///
/// Counts what [DisplayFeatureSubScreen] avoids: a feature with an area, or a
/// fold that is half open. A flat fold has no area and is ignored, and so is a
/// cutout, which never runs the full height of the window.
@internal
Rect? verticalFoldOf(BuildContext context) {
  final size = MediaQuery.sizeOf(context);

  for (final feature in MediaQuery.displayFeaturesOf(context)) {
    final bounds = feature.bounds;
    final avoided =
        bounds.shortestSide > 0 ||
        feature.state == DisplayFeatureState.postureHalfOpened;
    if (!avoided) continue;

    final fullHeight = bounds.top <= 0 && bounds.bottom >= size.height;
    final inside = bounds.left > 0 && bounds.right < size.width;
    if (fullHeight && inside) return bounds;
  }

  return null;
}

/// The anchor point that puts a modal with no source of its own in the
/// trailing half of a folded window: the top-right corner, or the top-left in
/// a right-to-left locale.
///
/// Without one, a route falls back to the leading half.
@internal
Offset trailingTopAnchorOf(BuildContext context) =>
    switch (Directionality.of(context)) {
      TextDirection.ltr => const Offset(double.maxFinite, 0),
      TextDirection.rtl => Offset.zero,
    };

/// Lays [start] and [end] out side by side, each kept clear of [fold] by at
/// least [gap].
///
/// The fold is in window coordinates, so after each build this measures where
/// the box sits in the window and moves the split if the fold has moved
/// relative to it. Until the first measurement, and when the fold is not
/// inside the box, the two share the width evenly.
@internal
class SplitAtFold extends StatefulWidget {
  /// Creates a row split at [fold].
  const SplitAtFold({
    super.key,
    required this.fold,
    required this.gap,
    required this.start,
    required this.end,
  });

  /// The fold, in window coordinates.
  final Rect fold;

  /// The room left between each side and the fold.
  final double gap;

  /// The side before the fold in reading order.
  final Widget start;

  /// The side after the fold in reading order.
  final Widget end;

  @override
  State<SplitAtFold> createState() => _SplitAtFoldState();
}

class _SplitAtFoldState extends State<SplitAtFold> {
  /// The fold's left and right edge in this widget's coordinates.
  (double, double)? _fold;

  void _measure(Duration _) {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;

    final origin = box.localToGlobal(Offset.zero);
    final fold = (widget.fold.left - origin.dx, widget.fold.right - origin.dx);
    if (fold != _fold) setState(() => _fold = fold);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_measure);

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final left = rtl ? widget.end : widget.start;
    final right = rtl ? widget.start : widget.end;

    final fold = _fold;
    final gap = widget.gap;

    // One tree whether or not the fold has been measured, so the children
    // keep their state when it is.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final even = ((width - gap * 2) / 2).clamp(0.0, double.infinity);
        final (leftWidth, rightStart) = switch (fold) {
          (final foldLeft, final foldRight)
              when foldLeft - gap > 0 && foldRight + gap < width =>
            (foldLeft - gap, foldRight + gap),
          _ => (even, even + gap * 2),
        };

        return Row(
          textDirection: TextDirection.ltr,
          children: [
            SizedBox(width: leftWidth, child: left),
            SizedBox(width: rightStart - leftWidth),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}
