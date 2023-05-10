import 'dart:async';

import '../logger/impl/tagged_logger.dart';
import 'lifecycle_state.dart';

final _logger = taggedLogger(tag: 'SV:LifecycleUtils');

@override
Stream<LifecycleState> get appState {
  _logger.w(() => '[appState] stub implementation');
  return const Stream.empty();
}
