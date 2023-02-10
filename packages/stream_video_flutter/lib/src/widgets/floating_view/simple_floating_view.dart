import 'package:flutter/material.dart';

import '../../utils/extensions.dart';
import 'floating_view_alignment.dart';

/// A simple draggable floating view that can be moved to any position.
class SimpleFloatingView extends StatefulWidget {
  /// Creates a new instance of [SimpleFloatingView].
  const SimpleFloatingView({
    super.key,
    required this.child,
    required this.floatingView,
    required this.floatingViewWidth,
    required this.floatingViewHeight,
    this.floatingViewPadding = 16,
    this.floatingViewAlignment = FloatingViewAlignment.topRight,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The widget that will be displayed as dragging widget.
  final Widget floatingView;

  /// The width of the floating view.
  final double floatingViewWidth;

  /// The height of the floating view.
  final double floatingViewHeight;

  /// The padding between floating view and the container.
  final double floatingViewPadding;

  /// The initial position of the floating view.
  final FloatingViewAlignment floatingViewAlignment;

  @override
  State<SimpleFloatingView> createState() => _SimpleFloatingViewState();
}

class _SimpleFloatingViewState extends State<SimpleFloatingView> {
  final bottomRightOffset = ValueNotifier<Offset>(Offset.zero);
  double maxRightOffset = 0;
  double maxBottomOffset = 0;

  double get floatingViewWidth => widget.floatingViewWidth;

  double get floatingViewHeight => widget.floatingViewHeight;

  double get floatingViewPadding => widget.floatingViewPadding;

  @override
  void initState() {
    super.initState();
    bottomRightOffset.value = _getInitialOffset(widget.floatingViewAlignment);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        maxRightOffset = width - floatingViewWidth - floatingViewPadding;
        maxBottomOffset = height - floatingViewHeight - floatingViewPadding;

        // If window is resized, this resets the floating window.
        bottomRightOffset.value = Offset(
          bottomRightOffset.value.dx
              .coerceIn(floatingViewPadding, maxRightOffset),
          bottomRightOffset.value.dy
              .coerceIn(floatingViewPadding, maxBottomOffset),
        );

        return Stack(
          children: [
            widget.child,
            ValueListenableBuilder(
              valueListenable: bottomRightOffset,
              builder: (context, val, child) {
                return Positioned(
                  right: bottomRightOffset.value.dx,
                  bottom: bottomRightOffset.value.dy,
                  child: GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    child: widget.floatingView,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final bottomOffset = bottomRightOffset.value.dx;
    final rightOffset = bottomRightOffset.value.dy;
    final dx = details.delta.dx;
    final dy = details.delta.dy;

    bottomRightOffset.value = Offset(
      (bottomOffset - dx).coerceIn(floatingViewPadding, maxRightOffset),
      (rightOffset - dy).coerceIn(floatingViewPadding, maxBottomOffset),
    );
  }

  Offset _getInitialOffset(FloatingViewAlignment alignment) {
    switch (alignment) {
      case FloatingViewAlignment.topRight:
        return const Offset(0, double.infinity);
      case FloatingViewAlignment.bottomRight:
        return Offset.zero;
      case FloatingViewAlignment.topLeft:
        return Offset.infinite;
      case FloatingViewAlignment.bottomLeft:
        return const Offset(double.infinity, 0);
    }
  }
}
