import 'dart:async';

import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:LifecycleUtils');

@override
Stream<LifecycleState> get appState {
  _logger.w(() => '[appState] stub implementation');
  return const Stream.empty();
}
