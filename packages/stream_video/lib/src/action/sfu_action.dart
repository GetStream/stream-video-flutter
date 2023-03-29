import '../sfu/data/events/sfu_events.dart';
import 'action.dart';

abstract class SfuAction extends StreamAction {
  const SfuAction();
}

class SfuEventAction extends SfuAction {
  const SfuEventAction(this.event);

  final SfuEvent event;
}
