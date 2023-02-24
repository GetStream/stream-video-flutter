import '../coordinator/models/coordinator_events.dart';
import '../models/call_metadata.dart';
import 'action.dart';

abstract class CoordinatorAction extends StreamAction {
  const CoordinatorAction();
}

class CoordinatorEventAction extends CoordinatorAction {
  const CoordinatorEventAction(this.event);

  final CoordinatorEvent event;
}

class CoordinatorUsersAction extends CoordinatorAction {
  const CoordinatorUsersAction({
    required this.users,
  });

  final Map<String, CallUser> users;
}
