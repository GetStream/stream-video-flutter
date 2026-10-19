import 'dart:async';

import '../logger/impl/tagged_logger.dart';
import 'video_lifecycle_state.dart';

final _logger = taggedLogger(tag: 'SV:LifecycleUtils');

Stream<VideoLifecycleState> get appState {
  _logger.w(() => '[appState] stub implementation');
  return const Stream.empty();
}
