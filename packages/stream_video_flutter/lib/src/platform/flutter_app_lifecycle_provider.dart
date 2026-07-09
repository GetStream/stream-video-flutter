import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stream_video/stream_video.dart';

/// [AppLifecycleProvider] backed by [WidgetsBinding], matching the native
/// SDK's existing lifecycle behavior.
class FlutterAppLifecycleProvider implements AppLifecycleProvider {
  const FlutterAppLifecycleProvider();

  @override
  Stream<LifecycleState> get appState {
    final controller = StreamController<LifecycleState>();
    final observer = _LifecycleStateObserver(controller.add);
    controller.onCancel = () {
      WidgetsBinding.instance.removeObserver(observer);
      controller.close();
    };
    controller.onListen = () {
      WidgetsBinding.instance.addObserver(observer);
      final current = WidgetsBinding.instance.lifecycleState;
      if (current != null) {
        controller.add(_toDomain(current));
      }
    };
    return controller.stream;
  }

  static LifecycleState _toDomain(AppLifecycleState state) {
    return switch (state) {
      AppLifecycleState.resumed => LifecycleState.resumed,
      AppLifecycleState.inactive => LifecycleState.inactive,
      AppLifecycleState.paused => LifecycleState.paused,
      AppLifecycleState.detached => LifecycleState.detached,
      AppLifecycleState.hidden => LifecycleState.hidden,
    };
  }
}

class _LifecycleStateObserver extends WidgetsBindingObserver {
  _LifecycleStateObserver(this.onStateChanged);

  final void Function(LifecycleState state) onStateChanged;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChanged(FlutterAppLifecycleProvider._toDomain(state));
  }
}
