import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stream_core/stream_core.dart';

import '../logger/impl/tagged_logger.dart';
import 'video_lifecycle_state.dart';

final _logger = taggedLogger(tag: 'SV:LifecycleUtilsM');

Stream<VideoLifecycleState> get appState {
  final controller = StreamController<VideoLifecycleState>();
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

typedef OnLifecycleStateChanged = void Function(VideoLifecycleState state);

class LifecycleStateCallback extends WidgetsBindingObserver {
  LifecycleStateCallback(this.onStateChanged);

  OnLifecycleStateChanged onStateChanged;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChanged(state.toDomain());
  }
}

extension on AppLifecycleState {
  VideoLifecycleState toDomain() {
    return switch (this) {
      AppLifecycleState.resumed => VideoLifecycleState.resumed,
      AppLifecycleState.inactive => VideoLifecycleState.inactive,
      AppLifecycleState.paused => VideoLifecycleState.paused,
      AppLifecycleState.detached => VideoLifecycleState.detached,
      // TODO: Switch with `hidden` once we stop supporting Flutter 3.10.
      _ => VideoLifecycleState.hidden,
    };
  }
}
