import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rate_limiter/rate_limiter.dart';

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
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  /// The duration to debounce the size change event.
  final Duration debounceDuration;

  /// The action to perform when the size of child widget changes.
  final OnSizeChanged onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(
      onSizeChanged: onSizeChanged,
      debounceDuration: debounceDuration,
    );
  }
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox? child,
    required Duration debounceDuration,
    required OnSizeChanged onSizeChanged,
  }) : super(child) {
    this.onSizeChanged = debounce(
      onSizeChanged,
      debounceDuration,
    );
  }

  late final Debounce onSizeChanged;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      onSizeChanged.call([size]);
    }
    _oldSize = size;
  }
}

abstract class PartialStateDeprecationMessage {
  static const localParticipant = '''
No longer needed to provide localParticipant. 
If provided the local participant will be used, otherwise the localparticipant of the call will be used.
''';

  static const participants = '''
No longer needed to provide participants. 
If provided the participants will be used, otherwise the participants of the call will be used.
''';

  static const callState = '''
It's no longer recommended to provide `callState`.
The widget can listen to more focussed partial state updates itself from the `call` object.
''';
}
