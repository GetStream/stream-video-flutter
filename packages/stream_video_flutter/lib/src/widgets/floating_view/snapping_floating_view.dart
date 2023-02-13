import 'package:flutter/material.dart';

import 'floating_view_alignment.dart';

/// The time duration for floating view to settle in one of the corners.
const _snapAnimationDuration = Duration(milliseconds: 300);

/// A floating view that will be automatically snapped to the closest
/// corner after it was dragged.
class SnappingFloatingView extends StatefulWidget {
  /// Creates a new instance of [SnappingFloatingView].
  const SnappingFloatingView({
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
  State<SnappingFloatingView> createState() => _SnappingFloatingViewState();
}

class _SnappingFloatingViewState extends State<SnappingFloatingView>
    with TickerProviderStateMixin {
  late final AnimationController _snapAnimationController;

  /// The current alignment of the floating view.
  late FloatingViewAlignment _currentAlignment;

  /// If we are currently moving the floating view with a gesture.
  var _isMoving = false;

  /// The distance from the start of the last move gesture.
  Offset _moveOffset = Offset.zero;

  /// Contains coordinates of all corners that we can use for snap animation.
  Map<FloatingViewAlignment, Offset> _snapOffsets = {};

  double get floatingViewWidth => widget.floatingViewWidth;

  double get floatingViewHeight => widget.floatingViewHeight;

  double get floatingViewPadding => widget.floatingViewPadding;

  @override
  void initState() {
    super.initState();

    /// Initialize the initial alignment.
    _currentAlignment = widget.floatingViewAlignment;
    _snapAnimationController = AnimationController(
      duration: _snapAnimationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _snapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _snapOffsets = _calculateSnapOffsets(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return Stack(
          children: [
            widget.child,
            AnimatedBuilder(
              animation: _snapAnimationController,
              builder: (BuildContext context, Widget? child) {
                final animationCurve = CurveTween(
                  curve: Curves.easeInOutQuad,
                );
                final dragAnimationValue = animationCurve.transform(
                  _snapAnimationController.value,
                );

                final floatingViewOffset = _isMoving
                    ? _moveOffset
                    : Tween<Offset>(
                        begin: _moveOffset,
                        end: _snapOffsets[_currentAlignment],
                      ).transform(
                        _snapAnimationController.isAnimating
                            ? dragAnimationValue
                            : 1,
                      );

                return Positioned(
                  left: floatingViewOffset.dx,
                  top: floatingViewOffset.dy,
                  child: GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    onPanStart: _onPanStart,
                    onPanCancel: _onPanCancel,
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

  /// We have started moving the floating view.
  void _onPanStart(DragStartDetails details) {
    if (!_snapAnimationController.isAnimating) {
      setState(() {
        _moveOffset = _snapOffsets[_currentAlignment]!;
        _isMoving = true;
      });
    }
  }

  /// We are continuing to move the floating view.
  void _onPanUpdate(DragUpdateDetails details) {
    if (_isMoving) {
      setState(() {
        _moveOffset = _moveOffset.translate(
          details.delta.dx,
          details.delta.dy,
        );
      });
    }
  }

  /// We have finished moving the floating view.
  void _onPanEnd(DragEndDetails details) {
    if (_isMoving) {
      setState(() {
        _currentAlignment = _calculateCurrentAlignment(
          offset: _moveOffset,
          snapOffsets: _snapOffsets,
        );
        _isMoving = false;
      });
      _snapAnimationController.forward().whenCompleteOrCancel(() {
        _snapAnimationController.value = 0;
        _moveOffset = Offset.zero;
      });
    }
  }

  /// The gesture didn't complete.
  void _onPanCancel() {
    if (_isMoving) {
      setState(() {
        _snapAnimationController.value = 0;
        _moveOffset = Offset.zero;
        _isMoving = false;
      });
    }
  }

  /// Detects the nearest corner to snap the floating view.
  FloatingViewAlignment _calculateCurrentAlignment({
    required Offset offset,
    required Map<FloatingViewAlignment, Offset> snapOffsets,
  }) {
    var minDistance = double.infinity;
    var alignment = FloatingViewAlignment.topRight;

    for (final element in FloatingViewAlignment.values) {
      final currDistance = snapOffsets[element]!
          .translate(-offset.dx, -offset.dy)
          .distanceSquared;
      if (currDistance < minDistance) {
        minDistance = currDistance;
        alignment = element;
      }
    }
    return alignment;
  }

  /// Calculates offset for each snap position.
  Map<FloatingViewAlignment, Offset> _calculateSnapOffsets(
    double containerWidth,
    double containerHeight,
  ) {
    final left = floatingViewPadding;
    final top = floatingViewPadding;
    final right = containerWidth - floatingViewWidth - floatingViewPadding;
    final bottom = containerHeight - floatingViewHeight - floatingViewPadding;

    return <FloatingViewAlignment, Offset>{
      FloatingViewAlignment.topLeft: Offset(left, top),
      FloatingViewAlignment.topRight: Offset(right, top),
      FloatingViewAlignment.bottomLeft: Offset(left, bottom),
      FloatingViewAlignment.bottomRight: Offset(right, bottom),
    };
  }
}
