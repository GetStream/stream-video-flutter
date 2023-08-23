import 'dart:async';

import 'package:flutter/widgets.dart';

import '../logger/impl/tagged_logger.dart';
import '../utils/standard.dart';
import 'lifecycle_state.dart';

final _logger = taggedLogger(tag: 'SV:LifecycleUtilsM');

@override
Stream<LifecycleState> get appState {
  final controller = StreamController<LifecycleState>();
  final callback = LifecycleStateCallback((state) {
    _logger.v(() => '[appState] newState: "$state"');
    controller.add(state);
  });
  controller.onCancel = () {
    _logger.i(() => '[appState] cancelled');
    WidgetsBinding.instance.removeObserver(callback);
    controller.close();
  };
  controller.onListen = () {
    _logger.i(() => '[appState] no args');
    WidgetsBinding.instance.addObserver(callback);
    WidgetsBinding.instance.lifecycleState?.toDomain().also((state) {
      _logger.v(() => '[appState] curState: "$state"');
      controller.add(state);
    });
  };
  return controller.stream;
}

typedef OnLifecycleStateChanged = void Function(LifecycleState state);

class LifecycleStateCallback extends WidgetsBindingObserver {
  LifecycleStateCallback(this.onStateChanged);

  OnLifecycleStateChanged onStateChanged;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChanged(state.toDomain());
  }
}

extension on AppLifecycleState {
  LifecycleState toDomain() {
    return switch (this) {
      AppLifecycleState.resumed => LifecycleState.resumed,
      AppLifecycleState.inactive => LifecycleState.inactive,
      AppLifecycleState.paused => LifecycleState.paused,
      AppLifecycleState.detached => LifecycleState.detached,
      // TODO: Switch with `hidden` once we stop supporting Flutter 3.10.
      _ => LifecycleState.hidden,
    };
  }
}
