import 'package:flutter/material.dart';

import 'floating_view_alignment.dart';
import 'simple_floating_view.dart';
import 'snapping_floating_view.dart';

/// A widget that uses either [SimpleFloatingView] or [SnappingFloatingView]
/// depending on the [isSnappingBehaviorEnabled].
class FloatingViewContainer extends StatelessWidget {
  /// Constructor for creating [FloatingViewContainer].
  const FloatingViewContainer({
    super.key,
    required this.child,
    required this.floatingView,
    required this.floatingViewWidth,
    required this.floatingViewHeight,
    this.isSnappingBehaviorEnabled = true,
    this.floatingViewPadding = 16,
    this.floatingViewAlignment = FloatingViewAlignment.topRight,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The widget that will be displayed as dragging widget.
  final Widget floatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool isSnappingBehaviorEnabled;

  /// The width of the floating view.
  final double floatingViewWidth;

  /// The height of the floating view.
  final double floatingViewHeight;

  /// The padding between floating view and the container.
  final double floatingViewPadding;

  /// The initial position of the floating view.
  final FloatingViewAlignment floatingViewAlignment;

  @override
  Widget build(BuildContext context) {
    if (isSnappingBehaviorEnabled) {
      return SnappingFloatingView(
        floatingView: floatingView,
        floatingViewWidth: floatingViewWidth,
        floatingViewHeight: floatingViewHeight,
        floatingViewPadding: floatingViewPadding,
        floatingViewAlignment: floatingViewAlignment,
        child: child,
      );
    } else {
      return SimpleFloatingView(
        floatingView: floatingView,
        floatingViewWidth: floatingViewWidth,
        floatingViewHeight: floatingViewHeight,
        floatingViewPadding: floatingViewPadding,
        floatingViewAlignment: floatingViewAlignment,
        child: child,
      );
    }
  }
}
