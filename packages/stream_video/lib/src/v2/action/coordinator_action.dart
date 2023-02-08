import '../coordinator/models/coordinator_models.dart';
import '../coordinator/ws/coordinator_events.dart';
import 'action.dart';

abstract class CoordinatorAction extends StreamAction {
  const CoordinatorAction();
}

class CoordinatorEventAction extends CoordinatorAction {
  const CoordinatorEventAction(this.event);

  final CoordinatorEventV2 event;
}

class CoordinatorUsersAction extends CoordinatorAction {
  const CoordinatorUsersAction({
    required this.users,
  });

  final Map<String, CallUser> users;
}
