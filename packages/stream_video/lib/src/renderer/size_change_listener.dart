import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// The action to perform when the size of child widget changes.
typedef OnSizeChanged = void Function(Size size);

/// A widget that calls the callback when the layout dimensions of
/// its child change.
class SizeChangeListener extends SingleChildRenderObjectWidget {
  /// Creates a new instance of [SizeChangeListener].
  const SizeChangeListener({
    super.key,
    super.child,
    required this.onSizeChanged,
  });

  /// The action to perform when the size of child widget changes.
  final OnSizeChanged onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(onSizeChanged: onSizeChanged);
  }
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox? child,
    required this.onSizeChanged,
  }) : super(child);

  final OnSizeChanged onSizeChanged;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      onSizeChanged.call(size);
    }
    _oldSize = size;
  }
}
