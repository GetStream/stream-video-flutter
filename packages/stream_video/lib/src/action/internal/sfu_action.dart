import 'package:meta/meta.dart';

import '../../sfu/data/events/sfu_events.dart';
import '../internal_action.dart';

@internal
abstract class SfuAction extends StreamInternalAction {
  const SfuAction();
}

class SfuEventAction extends SfuAction {
  const SfuEventAction(this.event);

  final SfuEvent event;

  @override
  List<Object?> get props => [event];
}
