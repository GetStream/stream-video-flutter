import 'dart:async';

import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

/// Rebuilds [builder] whenever [state] emits a new value.
///
/// Seeds from the emitter's current value, so the first render already
/// reflects live state rather than waiting for the first stream event.
class CallStateBuilder<T> extends StatefulComponent {
  const CallStateBuilder({
    required this.state,
    required this.builder,
    super.key,
  });

  final StateEmitter<T> state;
  final Component Function(BuildContext context, T value) builder;

  @override
  State<CallStateBuilder<T>> createState() => _CallStateBuilderState<T>();
}

class _CallStateBuilderState<T> extends State<CallStateBuilder<T>> {
  late T _value = component.state.value;
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateComponent(CallStateBuilder<T> oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.state != component.state) {
      _subscription?.cancel();
      _value = component.state.value;
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = component.state.listen((value) {
      if (mounted) setState(() => _value = value);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return component.builder(context, _value);
  }
}
