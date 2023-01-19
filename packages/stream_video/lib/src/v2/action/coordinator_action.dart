import '../coordinator/ws/coordinator_events.dart';
import 'action.dart';

class CoordinatorAction extends StreamAction {
  const CoordinatorAction(this.event);

  final CoordinatorEventV2 event;
}
